//
//  ImageUrlDownloadQueue.m
//
//  Created by Yenchiayu on 2014/11/17.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import "ImageUrlDownloadQueue.h"

@implementation ImageUrlDownloadQueue
+(ImageUrlDownloadQueue*)shareOperationQueue{
    static dispatch_once_t once;
    static ImageUrlDownloadQueue * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[ImageUrlDownloadQueue alloc] init];
        [sharedInstance setMaxConcurrentOperationCount:2];
    });
    return sharedInstance;
}

-(ImageUrlDownloadOperation*)addImageOperation:(ImageUrlDownloadOperation *)operation{

    for (ImageUrlDownloadOperation * imageOperation  in self.operations) {

        imageOperation.queuePriority = imageOperation.imageDownloadDelegate? NSOperationQueuePriorityHigh:NSOperationQueuePriorityNormal;
    }

    NSInteger indexOperation = [[[self.operations valueForKey:@"imageUrl"]valueForKey:@"absoluteString"]indexOfObject:operation.imageUrl.absoluteString];
    
    if (indexOperation!=NSNotFound) {
       ImageUrlDownloadOperation* op = self.operations[indexOperation];
        op.imageDownloadDelegate = operation.imageDownloadDelegate;
        op.queuePriority=NSOperationQueuePriorityVeryHigh;
        return op;
    }else{
        operation.queuePriority=NSOperationQueuePriorityVeryHigh;
        [self addOperation:operation];

        return operation;
    }
}

@end
