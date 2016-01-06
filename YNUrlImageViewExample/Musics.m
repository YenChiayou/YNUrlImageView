//
//  Musics.m
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/4.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import "Musics.h"
#import "httpRequestHelper.h"
@implementation Musics
+(void)getMusicsWithBlock:(void (^)(NSArray * arrayMusics , NSError * error))complete{
    NSMutableURLRequest * request = [HttpRequestHelper requestMakeFromUrl:@"https://itunes.apple.com/tw/rss/topalbums/limit=20/json"];
    [HttpRequestHelper resultFromRequest:request complet:^(id data) {
       NSMutableArray * musicsArray = [Musics musicArrayFormData:data[@"feed"][@"entry"]];
        complete(musicsArray,nil);
    } errorHandle:^(id error) {
        complete(@[],error);

    }];
}

+(NSMutableArray*)musicArrayFormData:(NSArray*)arrayData{
    NSMutableArray * arrayMusics = [[NSMutableArray alloc]init];
    for (NSDictionary * dicMusic in arrayData) {
        Music * itemMusic = [Music new];
        itemMusic.dic = dicMusic;
        [arrayMusics addObject:itemMusic];
    }
    return arrayMusics;
}


@end


@implementation Music

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.imageUrl = [dic[@"im:image"]firstObject][@"label"];
    self.name = dic[@"im:name"][@"label"];
    self.artist = dic[@"im:artist"][@"label"];
}

-(void)setImageUrl:(NSString *)imageUrl{
    float currentWidth = screenWidth * 2;
    NSString * stringWidth = [NSString stringWithFormat:@"%.0fx%.0f",currentWidth,currentWidth];
    NSString * stringReplace = [imageUrl stringByReplacingOccurrencesOfString:@"55x55" withString:stringWidth];
    _imageUrl = stringReplace;
}

@end