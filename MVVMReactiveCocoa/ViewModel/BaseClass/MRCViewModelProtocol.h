//
//  MRCViewModelProtocol.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MRCTitleViewType) {
    MRCTitleViewTypeDefault,
    MRCTitleViewTypeDoubleTitle
};

@protocol MRCViewModelServices;

// The Protocol for viewModel.
@protocol MRCViewModelProtocol <NSObject>

@required

// Initialization method. This is the preferred way to create a new viewModel.
//
// services - The service bus of Model layer.
// params   - The parameters to be passed to view model.
//
// Returns a new view model.
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(id)params;

// The `services` parameter in `-initWithServices:params:` method.
@property (strong, nonatomic, readonly) id<MRCViewModelServices> services;

// The `params` parameter in `-initWithServices:params:` method.
@property (strong, nonatomic, readonly) id params;

@optional

@property (assign, nonatomic) MRCTitleViewType titleViewType;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *subtitle;

// The callback block.
@property (copy, nonatomic) VoidBlock_id callback;

// A RACSubject object, which representing all errors occurred in view model.
@property (strong, nonatomic, readonly) RACSubject *errors;

@property (assign, nonatomic) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (assign, nonatomic) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (strong, nonatomic) RACSubject *willDisappearSignal;

// An additional method, in which you can initialize data, RACCommand etc.
//
// This method will be execute after the execution of `-initWithServices:params:` method. But
// the premise is that you need to inherit `MRCViewModel`.
- (void)initialize;

@end
