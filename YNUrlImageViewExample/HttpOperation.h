//
//  HttpOperation.h
//
//  Created by Yenchiayu on 2015/2/10.
//  Copyright (c) 2015年 顏嘉佑(Joe). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define errorHttpAlertDefaultID @"HttpErrorAlertShow"
#define isAlertShowed [[NSUserDefaults standardUserDefaults]boolForKey:errorHttpAlertDefaultID]

typedef void (^resultCompleter)(id data);
typedef void (^errorHandler)(id error);

@interface HttpOperation : NSOperation<NSURLConnectionDataDelegate>

@property (nonatomic) NSString * urlString;
@property (nonatomic) NSString * independentID;
@property (nonatomic,strong) resultCompleter completeResult;
@property (nonatomic,strong) errorHandler completeError;

@property (nonatomic) NSMutableURLRequest * requestDataUrl;
@property (nonatomic) NSURLConnection * connection;
@property (nonatomic) NSURLResponse * response;
+(instancetype)opearationWithRequest:(NSMutableURLRequest*)request;

@end
