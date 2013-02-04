//
//  ZDDownloadTask.h
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDDownloadTaskDataDefines.h"
#import "ZDDownloadOperation.h"

/*!
 这是一个基类，需要继承使用
 */
@interface ZDDownloadTask : NSObject
<
NSURLConnectionDataDelegate,
NSURLConnectionDelegate,
NSCoding,
NSCopying
>

@property (nonatomic, assign) ZDDownloadOperation *operation;

@property (nonatomic, assign) ZDDownloadTaskState state;
@property (nonatomic, assign) float progress;

// Base operation
- (void)startTask;
- (void)stopTask;

@end
