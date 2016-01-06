//
//  ImageDataModel.m
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/5.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import "ImageDataModel.h"

@implementation ImageDataModel
+(NSString*)pathImageFloder{
    BOOL isDirectory;
    NSString *tempDir = NSTemporaryDirectory();
    NSString *ImagePath = [tempDir stringByAppendingPathComponent:@"YNUrlImage"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ImagePath isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] createDirectoryAtPath:ImagePath
                                  withIntermediateDirectories:YES
                                                   attributes:attr
                                                        error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
    return ImagePath;
}

+(BOOL)isImageExist:(NSURL*)imageUrl{
    NSString * filePath = [[ImageDataModel pathImageFloder] stringByAppendingPathComponent:[ImageDataModel convertUrl:imageUrl]];
    return [[NSFileManager defaultManager]fileExistsAtPath:filePath];

}

+(void)saveImageToTemp:(NSData*)imageDownload imageUrl:(NSURL*)imageUrl{
    NSString * filePath = [[ImageDataModel pathImageFloder] stringByAppendingPathComponent:[ImageDataModel convertUrl:imageUrl]];
    [imageDownload writeToFile:filePath options:NSDataWritingAtomic error:nil];
}

+(NSData *)imageFromTemp:(NSURL*)imageUrl{
    NSString * filePath = [[ImageDataModel pathImageFloder] stringByAppendingPathComponent:[ImageDataModel convertUrl:imageUrl]];
    NSData * image = [NSData dataWithContentsOfFile:filePath];
    return image;
}

+(NSString *)convertUrl:(NSURL*)url{
    NSString * fileString1 = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return fileString1;
}
@end
