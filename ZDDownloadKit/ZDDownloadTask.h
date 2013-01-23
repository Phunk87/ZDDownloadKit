//
//  ZDDownloadTask.h
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDDownloadTaskDataDefines.h"

@interface ZDDownloadTask : NSObject

@property (nonatomic, retain) NSOperation *operation;
@property (nonatomic, readonly) ZDDownloadTaskState state;
@property (nonatomic, readonly) float progress;

+ (ZDDownloadTask *)task;

// Base operation
- (void)startTask;
- (void)stopTask;

@end
