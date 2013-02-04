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
#define kDefaultRemoveTaskWhenCompletionEnabled YES

#define KeyDownloadArchive          @"key.downloadArchive"

#define downloadArchivePlistPath    @"~/Documents/zddownload.plist"

@interface ZDDownloadManager ()
@property (nonatomic, retain) NSOperationQueue  *downloadQueue;
@property (nonatomic, retain) NSMutableArray *taskList;
@property (nonatomic, copy) NSString *archivePath;
@end

@interface ZDDownloadManager (Private)
- (void)_readFromDisk;
- (void)_writeToDisk;
@end

@implementation ZDDownloadManager

#pragma mark - Lifecycle
+ (ZDDownloadManager *)defaultManager {
    static dispatch_once_t onceToken;
    static ZDDownloadManager *s_manager;
    
    dispatch_once(&onceToken, ^{
        s_manager = [[self alloc] init];
        [s_manager _readFromDisk];
    });
    
    return s_manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.maxConcurrentDownloadingCount = kDefaultMaxConcurrentDownloadingCount;
        self.isRemoveTaskWhenCompletionEnabled = kDefaultRemoveTaskWhenCompletionEnabled;
        
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

- (NSString *)archivePath {
    NSString *path = [downloadArchivePlistPath stringByExpandingTildeInPath];
    return path;
}

#pragma mark - Add
- (void)addTask:(ZDDownloadTask *)task startImmediately:(BOOL)start {
    [self.taskList addObject:task];
    [self _writeToDisk];
    
    if (start) {
        [self startTask:task];
    }
}

#pragma mark - Start
- (void)startTask:(ZDDownloadTask *)task {
    @autoreleasepool {
        ZDDownloadOperation *operation = [[[ZDDownloadOperation alloc] initWithTask:task] autorelease];
        [task.operation addObserver:self
                         forKeyPath:@"isFinished"
                            options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                            context:nil];
        [task addObserver:self
               forKeyPath:@"progress"
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                  context:nil];
        
        [self.downloadQueue addOperation:operation];
        
        [self _writeToDisk];
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
        
        [self _writeToDisk];
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
    if (kZDDownloadTaskStateDownloading == task.state ||
        kZDDownloadTaskStateWaiting == task.state) {
        [self stopTask:task];
    }
    
    [task.operation removeObserver:self
                        forKeyPath:@"isFinished"];
    [task removeObserver:self
              forKeyPath:@"progress"];
    
    [self.taskList removeObject:task];
    
    [self _writeToDisk];
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[NSOperation class]]) {
        if ([keyPath isEqualToString:@"isFinished"] &&
            self.isRemoveTaskWhenCompletionEnabled) {
            BOOL isFinished = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
            
            if (isFinished) {
                for (ZDDownloadTask * task in self.taskList) {
                    if (task.operation == object) {
                        [self removeTask:task];
                        break;
                    }
                }
            }
        }
    } else if ([object isKindOfClass:[ZDDownloadTask class]]) {
        if ([keyPath isEqualToString:@"progress"]) {
            [self _writeToDisk];
        }
    }
}

#pragma mark - Private
- (void)_readFromDisk {
    [self.downloadQueue cancelAllOperations];
    [self.taskList removeAllObjects];
    
    NSString *archiverFilePath = self.archivePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:archiverFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:archiverFilePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *savedTaskList = [unarchiver decodeObjectForKey:KeyDownloadArchive];
        [unarchiver finishDecoding];
        
        [self.taskList addObjectsFromArray:savedTaskList];
        
        [unarchiver release];
    }
    
    for (ZDDownloadTask *task in self.taskList) {
        if (kZDDownloadTaskStateDownloaded != task.state) {
            [self startTask:task];
        }
    }
}

- (void)_writeToDisk {
    NSString *archiverFilePath = self.archivePath;
    
    NSMutableData *archiveData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
    NSArray *taskListToSave = [self.taskList copy];
    [archiver encodeObject:taskListToSave forKey:KeyDownloadArchive];
    [archiver finishEncoding];
    
    [archiveData writeToFile:archiverFilePath atomically:YES];
    
    [taskListToSave release];
    [archiveData release];
    [archiver release];
}

@end
