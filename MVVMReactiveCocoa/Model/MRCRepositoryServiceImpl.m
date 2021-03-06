//
//  MRCRepositoryServiceImpl.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/1/27.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "MRCRepositoryServiceImpl.h"

@implementation MRCRepositoryServiceImpl

- (RACSignal *)requestRepositoryReadmeHTMLString:(OCTRepository *)repository reference:(NSString *)reference {
    return [[[RACSignal
        createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *accessToken   = [SSKeychain accessToken];
            NSString *authorization = [NSString stringWithFormat:@"token %@", accessToken];
            
            MKNetworkEngine *networkEngine = [[MKNetworkEngine alloc] initWithHostName:@"api.github.com"
                                                                    customHeaderFields:@{ @"Authorization": authorization}];
            
            NSString *path = [NSString stringWithFormat:@"repos/%@/%@/readme", repository.ownerLogin, repository.name];
            MKNetworkOperation *operation = [networkEngine operationWithPath:path
                                                                      params:@{@"ref": reference}
                                                                  httpMethod:@"GET"
                                                                         ssl:YES];
            [operation addHeaders:@{ @"Accept": @"application/vnd.github.VERSION.html" }];
            [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [subscriber sendNext:completedOperation.responseString];
                    [subscriber sendCompleted];
                });
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [subscriber sendError:error];
                });
            }];
            
            [networkEngine enqueueOperation:operation];
            
            return [RACDisposable disposableWithBlock:^{
                [operation cancel];
            }];
        }]
        replayLazily]
        setNameWithFormat:@"-requestRepositoryReadmeHTMLString: %@ reference: %@", repository, reference];
}

@end
