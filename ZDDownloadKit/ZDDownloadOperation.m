//
//  ZDDownloadOperation.m
//  ZDDwonloadKit
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDownloadOperation.h"
#import "ZDDownloadTask.h"

@implementation ZDDownloadOperation {
    BOOL _isExecuting;
    BOOL _isFinished;
    BOOL _isCancelled;
}

- (id)initWithTask:(ZDDownloadTask *)task {
    self = [super init];
    if (self) {
        self.task = task;
        task.operation = self;
    }
    
    return self;
}

- (void)dealloc {
    self.task = nil;
    [super dealloc];
}

- (void)start {
    [self.task startTask];
    
    while (!self.isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
}

- (void)cancel {
    [self.task stopTask];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    ZDDownloadTaskState state = self.task.state;
    BOOL isExecuting = (state == kZDDownloadTaskStateDownloading);
    
    if (_isExecuting != isExecuting) {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = isExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
    return _isExecuting;
}

- (BOOL)isFinished {
    ZDDownloadTaskState state = self.task.state;
    BOOL isFinished = (kZDDownloadTaskStateDownloaded == state ||
                       kZDDownloadTaskStateFailed == state ||
                       kZDDownloadTaskStatePaused == state);
    
    if (_isFinished != isFinished) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = isFinished;
        [self didChangeValueForKey:@"isFinished"];
    }
    return _isFinished;
}

- (BOOL)isCancelled {
    ZDDownloadTaskState state = self.task.state;
    BOOL isCancelled = (kZDDownloadTaskStatePaused == state ||
                        kZDDownloadTaskStateFailed == state);
    
    if (_isCancelled != isCancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _isCancelled = isCancelled;
        [self didChangeValueForKey:@"isCancelled"];
    }
    return _isCancelled;
}

@end
