//
//  HttpRequestHelper.m
//
//  Created by Yenchiayu on 2014/11/7.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import "HttpRequestHelper.h"

@implementation HttpRequestHelper{
}
+(NSOperationQueue*)shareOperationQueue{
    static dispatch_once_t once;
    static NSOperationQueue * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[NSOperationQueue alloc] init];
        [sharedInstance setMaxConcurrentOperationCount:10];
    });
    return sharedInstance;
}


+(NSMutableURLRequest*)requestMakeFromUrl:(NSString*)urlString{
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:20];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    return urlRequest;
}


+(void)resultFromRequest:(NSMutableURLRequest*)requestYN complet:(resultCompleter)resultComplete errorHandle:(errorHandler)errorHandle{

    HttpOperation *operationDownLoad = [HttpOperation opearationWithRequest:requestYN];
    operationDownLoad.completeResult = resultComplete;
    operationDownLoad.completeError = errorHandle;
    

    NSOperationQueue * downloadQueue = [HttpRequestHelper shareOperationQueue];
    operationDownLoad.urlString = requestYN.URL.absoluteString;
    operationDownLoad.independentID = [requestYN valueForHTTPHeaderField:IndependentID]?:@"onlyRequest";
    BOOL shoudAddInQueue = YES;
    for (HttpOperation * op in [downloadQueue operations]) {
        op.queuePriority = NSOperationQueuePriorityNormal;
        if ([op.urlString isEqualToString:requestYN.URL.absoluteString] && [op.independentID isEqualToString:operationDownLoad.independentID]) {
            op.queuePriority =NSOperationQueuePriorityVeryHigh;
            op.completeResult = resultComplete;
            op.completeError = errorHandle;
            if (!op.isCancelled) {
                shoudAddInQueue = NO;
            }
        }
    }
    if (shoudAddInQueue) {
        operationDownLoad.queuePriority=NSOperationQueuePriorityVeryHigh;
        [downloadQueue addOperation:operationDownLoad];
    }
    
    
}
+(void)operationCancel:(NSURLRequest*)requestCancel{
    NSOperationQueue * downloadQueue = [HttpRequestHelper shareOperationQueue];
    HttpOperation *operationDownLoad = [[HttpOperation alloc]init];
    operationDownLoad.urlString = requestCancel.URL.absoluteString;
    operationDownLoad.independentID = [requestCancel valueForHTTPHeaderField:IndependentID]?:@"onlyRequest";
    for (HttpOperation * op  in downloadQueue.operations) {
        if ([op.urlString isEqualToString:operationDownLoad.urlString] && [op.independentID isEqualToString:operationDownLoad.independentID]) {
            [op cancel];
        }
    }
}

@end
