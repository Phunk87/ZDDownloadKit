//
//  ZDDownloadOperation.m
//  ZDDwonloadKit
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDownloadOperation.h"
#import "ZDDownloadTask.h"

@implementation ZDDownloadOperation

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
    return (state == kZDDownloadTaskStateDownloading);
}

- (BOOL)isFinished {
    ZDDownloadTaskState state = self.task.state;
    return (kZDDownloadTaskStateDownloaded == state ||
            kZDDownloadTaskStateFailed == state ||
            kZDDownloadTaskStatePaused == state);
}

- (BOOL)isCancelled {
    ZDDownloadTaskState state = self.task.state;
    return (kZDDownloadTaskStatePaused == state ||
            kZDDownloadTaskStateFailed == state);
}

@end
