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
@property (nonatomic, assign) int64_t           downloadedSize;
@property (nonatomic, assign) int64_t           totalSize;
@end

@interface ZDSingleThreadDownloadTask (Private)
- (NSString *)_defaultCacheDirectory;
- (void)_persistentCacheData;
- (void)_setState:(ZDDownloadTaskState)state;
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
        self.maxCacheSize = 1024 * 512; // 512k
        
        NSString *urlLastComponent = [[url pathComponents] lastObject];
        NSString *cacheFileName = [NSString stringWithFormat:@".%@.downloading", urlLastComponent];
        NSString *defaultCacheDirectory = [self _defaultCacheDirectory];
        NSString *cacheFilePath = [defaultCacheDirectory stringByAppendingPathComponent:cacheFileName];
        BOOL isDirectory = YES;
        NSUInteger count = 0;
        
        while ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath isDirectory:&isDirectory] && !isDirectory) {
            cacheFileName = [NSString stringWithFormat:@".%@_%d.downloading", urlLastComponent, ++count];
            cacheFilePath = [defaultCacheDirectory stringByAppendingPathComponent:cacheFileName];
        }
        
        self.cachePath = cacheFilePath;
        
        // status
        self.state = kZDDownloadTaskStateWaiting;
        self.progress = 0.0f;
    }
    
    return self;
}

- (void)dealloc {
    self.url = nil;
    self.cachePath = nil;
    self.cachedData = nil;
    [super dealloc];
}

#pragma mark - Override
- (void)startTask {
    self.state = kZDDownloadTaskStateDownloading;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    self.connection = [NSURLConnection connectionWithRequest:request
                                                    delegate:self];
}

- (void)stopTask {
    self.state = kZDDownloadTaskStatePaused;
    
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSUInteger statusCode = httpResponse.statusCode;
    
    switch (statusCode) {
        case 200:
            if (!_cachedData) {
                self.cachedData = [NSMutableData data];
            }
            
            if (0 == self.totalSize) {
                self.totalSize = [[[httpResponse allHeaderFields] valueForKey:@"Content-Length"] integerValue];
            }
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSUInteger cachedDataSize = self.cachedData.length;
    NSUInteger newDataSize = data.length;
    
    self.downloadedSize += newDataSize;
    
    if (self.totalSize) {
        float progress = ((float)_downloadedSize) / ((float)_totalSize);
        
        // 取3位小数
        progress = (float)(unsigned int)(progress * 1000);
        progress /= 1000.0f;
        
        if (self.progress != progress) {
            self.progress = progress > 1.0f ? 1.0f : progress;
        }
    }
    
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
    
    self.state = kZDDownloadTaskStateDownloaded;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.state = kZDDownloadTaskStateFailed;
}

#pragma mark - Private
- (NSString *)_defaultCacheDirectory {
    NSString *defaultDownloadPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [defaultDownloadPath stringByAppendingPathComponent:@"Downloads"];
}

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
