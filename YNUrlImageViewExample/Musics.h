//
//  Musics.h
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/4.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import <Foundation/Foundation.h>
#define screenWidth MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

@interface Musics : NSObject
+(void)getMusicsWithBlock:(void (^)(NSArray * arrayMusics,NSError * error))complete;
@end

@interface Music : NSObject
@property (nonatomic)NSDictionary * dic;
@property (nonatomic)NSString * name;
@property (nonatomic)NSString * artist;
@property (nonatomic)NSString * imageUrl;


@end