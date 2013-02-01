//
//  ZDDownloadManager.h
//  ZDDwonloadKit
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDDownloadOperation.h"
#import "ZDDownloadTask.h"

@interface ZDDownloadManager : NSObject

@property (nonatomic, assign) NSUInteger maxConcurrentDownloadingCount;     // Default as 3
@property (nonatomic, readonly) NSUInteger downloadTaskCount;
@property (nonatomic, assign, setter = setRemoveTaskWhenCompletionEnabled:) BOOL isRemoveTaskWhenCompletionEnabled; // Default as YES

+ (ZDDownloadManager *)defaultManager;

// Add
- (void)addTask:(ZDDownloadTask *)task startImmediately:(BOOL)start;

// Start
- (void)startTask:(ZDDownloadTask *)task;
- (void)startTaskAtIndex:(NSUInteger)index;
- (void)startAllTasks;

// Stop
- (void)stopTask:(ZDDownloadTask *)task;
- (void)stopTaskAtIndex:(NSUInteger)index;
- (void)stapAllTasks;

// Remove
- (void)removeTask:(ZDDownloadTask *)task;
- (void)removeTaskAtIndex:(NSUInteger)index;
- (void)removeAllTasks;

// Access
- (ZDDownloadTask *)taskAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfTask:(ZDDownloadTask *)task;

@end
