//
//  ZDSingleThreadDownloadTask.m
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDSingleThreadDownloadTask.h"

@interface ZDSingleThreadDownloadTask ()
@property (nonatomic, retain) NSURLConnection   *connection;
@property (nonatomic, retain) NSMutableData     *cachedData;
@end

@interface ZDSingleThreadDownloadTask (Private)
- (void)_persistentCacheData;
@end

@implementation ZDSingleThreadDownloadTask

+ (ZDSingleThreadDownloadTask *)taskWithURL:(NSURL *)url {
    return [[[self alloc] initWithURL:url] autorelease];
}

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        
        // Default
        NSString *defaultDownloadPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.cachePath = defaultDownloadPath;
    }
    
    return self;
}

- (void)dealloc {
    self.url = nil;
    [super dealloc];
}

#pragma mark - Override
- (void)startTask {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    self.connection = [NSURLConnection connectionWithRequest:request
                                                    delegate:self];
}

- (void)stopTask {
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    BOOL isDirectory = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.cachePath isDirectory:&isDirectory];
    if (!exist || (exist && !isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    self.cachedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSUInteger cachedDataSize = self.cachedData.length;
    NSUInteger newDataSize = data.length;
    
    if (cachedDataSize + newDataSize > self.maxCacheSize) {
        [self _persistentCacheData];
        self.cachedData = [NSMutableData dataWithData:data];
    } else {
        [self.cachedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.cachedData) {
        [self _persistentCacheData];
        self.cachedData = nil;
    }
}

#pragma mark - Private
- (void)_persistentCacheData {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.cachePath];
    if (!fileHandle) {
        [self.cachedData writeToFile:self.cachePath atomically:YES];
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:self.cachedData];
        [fileHandle closeFile];
    }
    
    self.cachedData = [NSMutableData data];
}

@end
