//
//  ZDDownloadOperation.h
//  ZDDwonloadKit
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDDownloadTask;
@interface ZDDownloadOperation : NSOperation

@property (nonatomic, assign) ZDDownloadTask *task;

- (id)initWithTask:(ZDDownloadTask *)task;

@end
