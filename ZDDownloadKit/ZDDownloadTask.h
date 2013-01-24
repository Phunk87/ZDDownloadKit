//
//  ZDDownloadTask.h
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDDownloadTaskDataDefines.h"

/*!
 这是一个基类，需要继承使用
 */
@interface ZDDownloadTask : NSObject
<
NSURLConnectionDataDelegate
>

@property (nonatomic, retain) NSOperation *operation;

@property (nonatomic, readonly) ZDDownloadTaskState state;
@property (nonatomic, readonly) float progress;

+ (ZDDownloadTask *)task;

// Base operation
- (void)startTask;
- (void)stopTask;

@end
