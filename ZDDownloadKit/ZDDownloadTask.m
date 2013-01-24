//
//  ZDDownloadTask.m
//  Demo
//
//  Created by Oneday on 13-1-23.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDownloadTask.h"

@implementation ZDDownloadTask

+ (ZDDownloadTask *)task {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.operation = nil;
    [super dealloc];
}

- (void)startTask {}
- (void)stopTask {}

@end
