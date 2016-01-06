//
//  YNUrlImageView.m
//
//  Created by Yenchiayu on 2014/11/17.
//  Copyright (c) 2014年 顏嘉佑(Joe). All rights reserved.
//

#import "YNUrlImageView.h"

@implementation YNUrlImageView{
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self addSubview:self.progressView];
        self.progressView.hidden=YES;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.progressView.frame=CGRectMake(0, 0, self.bounds.size.width-10, 20);
    self.progressView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void)getItemImage:(NSURL *)urlImage{
    self.imageUrl=urlImage;
    BOOL imageExist = [ImageDataModel isImageExist:self.imageUrl];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    if (imageExist) {
        [self finishImageDownLoadfinishUrl:self.imageUrl];
    }else{
        self.image=nil;
        self.imageOeration.imageDownloadDelegate = nil;
        ImageUrlDownloadOperation * imageOperation = [[ImageUrlDownloadOperation alloc]init];
        imageOperation.imageUrl = self.imageUrl;
        imageOperation.imageDownloadDelegate=self;
        
        ImageUrlDownloadQueue * operationQueue= [ImageUrlDownloadQueue shareOperationQueue];
        self.imageOeration = [operationQueue addImageOperation:imageOperation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageDownloadCompleteNotifi:) name:@"YNUrlImageDownloadComplete" object:self.imageOeration];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageDownloadPercent:) name:@"YNUrlImageDownloadPercent" object:self.imageOeration];

        self.progressView.progress=0;
        self.progressView.hidden=NO;
    }
}
/*delegate mehtod*/
-(void)downloadPercent:(float)imagePercent{
    self.progressView.progress = imagePercent;
}
-(void)errorImageDownLoad:(NSError*)imageError{
    self.progressView.hidden=YES;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*notification-Joe*/
-(IBAction)imageDownloadPercent:(NSNotification*)sender{
    NSNumber *  percentDownload = sender.userInfo[@"percent"];
    [self downloadPercent:percentDownload.floatValue];
}

-(IBAction)imageDownloadCompleteNotifi:(NSNotification*)sender{
    BOOL imageExist = [ImageDataModel isImageExist:self.imageUrl];
    if (imageExist) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self finishImageDownLoadfinishUrl:self.imageUrl];
    }
}

-(void)finishImageDownLoadfinishUrl:(NSURL *)urlImage{
    if ([self.imageUrl.absoluteString isEqualToString:urlImage.absoluteString]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * itemImage = [UIImage imageWithData:[ImageDataModel imageFromTemp:self.imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self putUrlImageOnView:itemImage];
            });
        });
    }
}

-(void)putUrlImageOnView:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:image];
        self.progressView.hidden=YES;
    });
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
