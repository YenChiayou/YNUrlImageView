//
//  ImageUrlDownloadOperation.h
//
//  Created by Yenchiayu on 2014/11/17.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataModel.h"
@protocol ImageDownloadDelegate <NSObject>
-(void)errorImageDownLoad:(NSError*)imageError;
@end

@interface ImageUrlDownloadOperation : NSOperation<NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSURL * imageUrl;
@property (nonatomic,weak)id <ImageDownloadDelegate> imageDownloadDelegate;
@property (nonatomic,strong) NSMutableData * imageData;
@end
