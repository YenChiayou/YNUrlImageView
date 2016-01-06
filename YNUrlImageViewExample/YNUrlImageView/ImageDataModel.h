//
//  ImageDataModel.h
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/5.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataModel : NSObject
+(void)saveImageToTemp:(NSData*)imageDownload imageUrl:(NSURL*)imageUrl;
+(BOOL)isImageExist:(NSURL*)imageUrl;
+(NSData *)imageFromTemp:(NSURL*)imageUrl;
@end
