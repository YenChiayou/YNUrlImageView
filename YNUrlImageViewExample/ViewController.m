//
//  ViewController.m
//  JoeYenItunesRSS
//
//  Created by Yenchiayu on 2016/1/4.
//  Copyright © 2016年 顏嘉佑(Joe). All rights reserved.
//

#import "ViewController.h"
#import "Musics.h"
#import "MusicCell.h"

@interface ViewController ()
@property (nonatomic)NSMutableArray * arrayMusics;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib * musicCellNib = [UINib nibWithNibName:@"MusicCell" bundle:nil];
    [self.viewCollectionMusic registerNib:musicCellNib forCellWithReuseIdentifier:musicCellID];
    
    [self.btnReDownload addTarget:self action:@selector(downloadMusics) forControlEvents:UIControlEventTouchUpInside];
    
    [self downloadMusics];
    
}

-(void)downloadMusics{
    [self.indicatorView startAnimating];
    self.btnReDownload.hidden = YES;
    self.viewCollectionMusic.hidden = YES;
    [Musics getMusicsWithBlock:^(NSArray *arrayMusics, NSError * error) {
        [self.indicatorView stopAnimating];
        if (!error) {
            self.arrayMusics = [[NSMutableArray alloc]initWithArray:arrayMusics];
            self.viewCollectionMusic.hidden = NO;
            [self.viewCollectionMusic reloadData];
        }else{
            self.btnReDownload.hidden = NO;
        }
    }];
}
#pragma mark - collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayMusics.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:musicCellID forIndexPath:indexPath];
    Music * itemMusic = self.arrayMusics[indexPath.row];
    cell.labelTitle.text = [NSString stringWithFormat:@"%@\n%@",itemMusic.name,itemMusic.artist];
#warning use YNUrlImageView
    [cell.imageViewPoster getItemImage:[NSURL URLWithString:itemMusic.imageUrl]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(screenWidth, screenWidth);
}

#pragma mark - memoryHadle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
