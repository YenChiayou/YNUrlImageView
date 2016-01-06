//
//  HttpRequestHelper.h
//
//  Created by Yenchiayu on 2014/11/7.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//
#define IndependentID @"IndependentID"



#import <Foundation/Foundation.h>
#import "HttpOperation.h"
@interface HttpRequestHelper : NSObject
+(NSOperationQueue*)shareOperationQueue;

+(NSMutableURLRequest*)requestMakeFromUrl:(NSString*)urlString;

+(void)resultFromRequest:(NSMutableURLRequest*)requestYN complet:(resultCompleter)resultComplete errorHandle:(errorHandler)errorHandle;
+(void)operationCancel:(NSURLRequest*)requestCancel;
@end
