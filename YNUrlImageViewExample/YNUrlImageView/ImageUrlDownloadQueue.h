//
//  ImageUrlDownloadQueue.h
//
//  Created by Yenchiayu on 2014/11/17.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUrlDownloadOperation.h"
@interface ImageUrlDownloadQueue : NSOperationQueue
+(ImageUrlDownloadQueue*)shareOperationQueue;

-(ImageUrlDownloadOperation*)addImageOperation:(ImageUrlDownloadOperation *)operation;

@end
