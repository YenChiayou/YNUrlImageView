//
//  MusicCell.h
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/5.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNUrlImageView.h"
#define musicCellID @"musicCollectionCell"
@interface MusicCell : UICollectionViewCell
@property (nonatomic,weak)IBOutlet UILabel * labelTitle;
@property (nonatomic,weak)IBOutlet YNUrlImageView * imageViewPoster;
@end
