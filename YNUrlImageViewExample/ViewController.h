//
//  ViewController.h
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/4.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak)IBOutlet UICollectionView * viewCollectionMusic;
@property (nonatomic,weak)IBOutlet UIActivityIndicatorView * indicatorView;
@property (nonatomic,weak)IBOutlet UIButton * btnReDownload;


@end

