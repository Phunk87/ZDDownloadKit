//
//  ZDSingleThreadDownloadTask.h
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDownloadTask.h"

@interface ZDSingleThreadDownloadTask : ZDDownloadTask

@property (nonatomic, copy) NSURL *url;

@property (nonatomic, assign) NSUInteger maxCacheSize;
@property (nonatomic, copy) NSString   *cachePath;      // Default: ~/Library/Caches/Downloads/.${[[url pathComponents] lastObject]}.downloading

+ (ZDSingleThreadDownloadTask *)taskWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url;

- (void)startTask;
- (void)stopTask;

@end