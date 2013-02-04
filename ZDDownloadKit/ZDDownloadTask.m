//
//  ZDDownloadTask.m
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDownloadTask.h"

#define KeyDownloadTaskState    @"key.downloadTaskState"
#define KeyDownloadProgress     @"key.downloadProgress"

@implementation ZDDownloadTask

- (void)dealloc {
    self.operation = nil;
    [super dealloc];
}

- (void)startTask {}
- (void)stopTask {}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:_state forKey:KeyDownloadTaskState];
    [aCoder encodeFloat:_progress forKey:KeyDownloadProgress];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.state = [aDecoder decodeIntForKey:KeyDownloadTaskState];
        self.progress = [aDecoder decodeFloatForKey:KeyDownloadProgress];
    }
    
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    ZDDownloadTask *copy = [[self class] allocWithZone:zone];
    copy.state = self.state;
    copy.progress = self.progress;
    
    return copy;
}

@end
