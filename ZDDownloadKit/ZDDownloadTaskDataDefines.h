//
//  ZDDownloadTaskDataDefines.h
//  ZDDwonloadKit
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#ifndef ZDDwonloadKit_ZDDownloadTaskDataDefines_h
#define ZDDwonloadKit_ZDDownloadTaskDataDefines_h

typedef enum {
    kZDDownloadTaskStateWaiting = 0,
    kZDDownloadTaskStateDownloading,
    kZDDownloadTaskStateDownloaded,
    kZDDownloadTaskStatePaused,
    kZDDownloadTaskStateFailed
} ZDDownloadTaskState;

#endif
