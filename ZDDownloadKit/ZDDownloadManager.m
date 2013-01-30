//
//  ZDDownloadManager.m
//  ZDDwonloadKit
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDownloadManager.h"
#import "ZDDownloadTaskDataDefines.h"

#define kDefaultMaxConcurrentDownloadingCount   3

@interface ZDDownloadManager ()
@property (nonatomic, retain) NSOperationQueue  *downloadQueue;
@property (nonatomic, retain) NSMutableArray *taskList;
@end

@implementation ZDDownloadManager

#pragma mark - Lifecycle
+ (ZDDownloadManager *)defaultManager {
    static dispatch_once_t onceToken;
    static ZDDownloadManager *s_manager;
    
    dispatch_once(&onceToken, ^{
        s_manager = [[self alloc] init];
    });
    
    return s_manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.maxConcurrentDownloadingCount = kDefaultMaxConcurrentDownloadingCount;
        
        self.downloadQueue = [[[NSOperationQueue alloc] init] autorelease];
        self.downloadQueue.maxConcurrentOperationCount = self.maxConcurrentDownloadingCount;
        
        self.taskList = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.downloadQueue = nil;
    self.taskList = nil;
    [super dealloc];
}

#pragma mark - Getter && Setter
- (NSUInteger)downloadTaskCount {
    return [self.taskList count];
}

#pragma mark - Add
- (void)addTask:(ZDDownloadTask *)task startImmediately:(BOOL)start {
    [self.taskList addObject:task];
    
    if (start) {
        [self startTask:task];
    }
}

#pragma mark - Start
- (void)startTask:(ZDDownloadTask *)task {
    @autoreleasepool {
        ZDDownloadOperation *operation = [[[ZDDownloadOperation alloc] initWithTask:task] autorelease];
        [self.downloadQueue addOperation:operation];
    }
}

- (void)startTaskAtIndex:(NSUInteger)index {
    ZDDownloadTask * task = [self.taskList objectAtIndex:index];
    [self startTask:task];
}

- (void)startAllTasks {
    for (ZDDownloadTask * task in self.taskList) {
        [self startTask:task];
    }
}

#pragma mark - Stop
- (void)stopTask:(ZDDownloadTask *)task {
    if (kZDDownloadTaskStateDownloading == task.state) {
        [[task operation] cancel];
        [task setOperation:nil];
    }
}

- (void)stopTaskAtIndex:(NSUInteger)index {
    ZDDownloadTask * task = [self.taskList objectAtIndex:index];
    [self stopTask:task];
}

- (void)stapAllTasks {
    for (ZDDownloadTask * task in self.taskList) {
        [self stopTask:task];
    }
}

#pragma mark - Remove
- (void)removeTask:(ZDDownloadTask *)task {
    [self stopTask:task];
    [self.taskList removeObject:task];
}

- (void)removeTaskAtIndex:(NSUInteger)index {
    ZDDownloadTask * task = [self.taskList objectAtIndex:index];
    [self removeTask:task];
}

- (void)removeAllTasks {
    for (ZDDownloadTask * task in self.taskList) {
        [self removeTask:task];
    }
}

#pragma mark - Access
- (ZDDownloadTask *)taskAtIndex:(NSUInteger)index {
    return [self.taskList objectAtIndex:index];
}

- (NSUInteger)indexOfTask:(ZDDownloadTask *)task {
    return [self.taskList indexOfObject:task];
}

@end
