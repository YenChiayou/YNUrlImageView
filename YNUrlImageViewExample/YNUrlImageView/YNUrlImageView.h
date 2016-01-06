//
//  YNUrlImageView.h
//
//  Created by Yenchiayu on 2014/11/17.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageUrlDownloadQueue.h"

@interface YNUrlImageView : UIImageView<ImageDownloadDelegate>
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic,weak) ImageUrlDownloadOperation * imageOeration;
@property (nonatomic) UIProgressView * progressView;


-(void)getItemImage:(NSURL*)urlImage;

@end
