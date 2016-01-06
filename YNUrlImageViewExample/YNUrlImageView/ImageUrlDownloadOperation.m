//
//  ImageUrlDownloadOperation.m
//
//  Created by Yenchiayu on 2014/11/17.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import "ImageUrlDownloadOperation.h"

@implementation ImageUrlDownloadOperation
{
    BOOL isLoading;
    NSURLConnection * imageDownLoadConnection;
    float dataLengh;
    BOOL shouldSave;
}
-(void)main{
    isLoading = YES;
    [self makeConnectionAction];
    while ( isLoading ){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

-(void)makeConnectionAction{
    self.imageData = [[NSMutableData alloc]init];
    NSMutableURLRequest * imageRequest = [NSMutableURLRequest requestWithURL:self.imageUrl];
    [imageRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [imageRequest setTimeoutInterval:20];
    imageDownLoadConnection = [[NSURLConnection alloc]initWithRequest:imageRequest delegate:self startImmediately:NO];
    [imageDownLoadConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse * httpResponse =(NSHTTPURLResponse*)response;
    shouldSave = httpResponse.statusCode == 200;
    if (shouldSave) {
        dataLengh =[response expectedContentLength];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.imageData appendData:data];
    if (dataLengh!=0) {
        double percent = self.imageData.length/dataLengh;
        NSNumber * theDataPercent = [NSNumber numberWithFloat:percent];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YNUrlImageDownloadPercent" object:self userInfo:@{@"imageUrl":self.imageUrl.absoluteString,@"percent":theDataPercent}];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (shouldSave) {
        [ImageDataModel saveImageToTemp:self.imageData imageUrl:self.imageUrl];
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:@"YNUrlImageDownloadComplete" object:self userInfo:@{@"imageUrl":self.imageUrl.absoluteString}];
    isLoading=NO;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if ([self.imageDownloadDelegate respondsToSelector:@selector(errorImageDownLoad:)]) {
        [self.imageDownloadDelegate errorImageDownLoad:error];
    }
    isLoading=NO;
}
-(void)dealloc{
    NSLog(@"dealloc %@",self);
}
@end
