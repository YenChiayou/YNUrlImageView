//
//  HttpOperation.m
//
//  Created by Yenchiayu on 2015/2/10.
//  Copyright (c) 2015年 顏嘉佑(Joe). All rights reserved.
//

#import "HttpOperation.h"

@interface HttpOperation (){
}
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, getter = isCancelled) BOOL cancelled;
@property (nonatomic,strong)  NSMutableData * dataDownlaod;

@end



@implementation HttpOperation

@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;


+(instancetype)opearationWithRequest:(NSMutableURLRequest*)request{
    return [[self alloc]initWithRequest:request];
}


-(instancetype)initWithRequest:(NSMutableURLRequest*)requestYN{
    self = [super init];
    if (self) {
        self.requestDataUrl = requestYN;
        self.connection = [[NSURLConnection alloc]initWithRequest:requestYN delegate:self startImmediately:NO];
    }
    return self;
}

-(BOOL)isAsynchronous{
    return YES;
}

-(void)start{
    @synchronized (self)
    {
        if (!self.executing && !self.cancelled)
        {
            [self willChangeValueForKey:@"isExecuting"];
            self.executing = YES;
            [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [self.connection start];
            [self didChangeValueForKey:@"isExecuting"];
        }else{
            [self willChangeValueForKey:@"isExecuting"];
            self.executing = YES;
            [self didChangeValueForKey:@"isExecuting"];
            [self finish];
        }
    }
}
- (void)cancel
{
    @synchronized (self)
    {
        if (!self.cancelled)
        {
            [self willChangeValueForKey:@"isCancelled"];
            self.cancelled = YES;
            [self.connection cancel];
            [self didChangeValueForKey:@"isCancelled"];
            //call callback
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
            [self connection:self.connection didFailWithError:error];
        }
    }
}
- (void)finish
{
    @synchronized (self)
    {
        if (self.executing && !self.finished)
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            self.connection = nil;
            self.executing = NO;
            self.finished = YES;
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}
#pragma mark - connectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self.dataDownlaod == nil) {
        self.dataDownlaod = [[NSMutableData alloc]init];
    }

    [self.dataDownlaod appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self.completeResult) {
        id requestData = [self jsonObjectFromData:self.dataDownlaod];
        self.completeResult(requestData);
    }

    [self finish];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (!self.cancelled) {
        NSLog(@"httpError:%@\nurl:%@",error.localizedDescription,connection.currentRequest.URL.absoluteString);
        [HttpOperation interNetErrorAlert];
        if (self.completeError) {
            self.completeError(error);
        }
    }
    [self finish];
}
#pragma mark - jsonSerialization
-(id)jsonObjectFromData:(NSData*)data{
    NSError * dataError;
//    NSLog(@"response %@",self.response);
//    NSLog(@"url:%@\nData:%@",self.requestDataUrl,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dataError];
    if (dataError) {
//        NSLog(@"httpOreationJsonError:%@",dataError);
        if (self.completeError) {
            self.completeError(dataError);
        }
    }
    return dic;
}
#pragma alerViewErrorOccur
+(void)interNetErrorAlert{
    if (!isAlertShowed) {
        UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:@"系統通知" message:@"請檢查網路狀態" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:errorHttpAlertDefaultID];
        }];
        [alertControl addAction:actionOK];
        [[[[UIApplication sharedApplication]keyWindow]rootViewController]presentViewController:alertControl animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:errorHttpAlertDefaultID];
        }];
    }

}

-(void)dealloc{
    NSLog(@"HttpOreation Dealloc %@",self.urlString);
}
@end
