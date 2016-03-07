//
//  browsePicCell.m
//  browsePic
//
//  Created by Air on 16/3/7.
//  Copyright © 2016年 super-Yang. All rights reserved.
//

#import "browsePicCell.h"
#import "ShowImageView.h"
#define ScreenSize  [[UIScreen mainScreen] bounds]

@implementation browsePicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    imageArray = [NSMutableArray array];
    [self loadImageView];
    // Configure the view for the selected state
}
- (void)loadImageView
{
    CGFloat padding = 10;
    CGFloat picWidth = 60;
    CGFloat picHeight = 60;
   
    for (int i = 0; i < 3; i++) {
        UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+50+(picWidth+padding)*i, 20, picWidth, picHeight)];
        picImageView.userInteractionEnabled = YES;
        picImageView.tag = 2000 + i;
        picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [imageArray addObject:picImageView.image];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [picImageView addGestureRecognizer:tap];
        [self.contentView addSubview:picImageView];
    }

}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIImageView *iconImageView =(UIImageView *)tap.view;
    CGRect oldframe = [tap.view convertRect:tap.view.bounds toView:self.contentView.window];
    UIView *blackView = [[UIView alloc] initWithFrame:ScreenSize];
    blackView.backgroundColor = [UIColor blackColor];
    [self.window addSubview:blackView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.image = iconImageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [blackView addSubview:imageView];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = ScreenSize;
        
    } completion:^(BOOL finished) {
        
        ShowImageView *showImageView = [[ShowImageView alloc]initWithFrame:ScreenSize byClickTag:tap.view.tag appendArray:imageArray];
        [self.window addSubview:showImageView];
        __weak typeof(showImageView)weakself = showImageView;
        showImageView.removeImg = ^(){
            __strong typeof(weakself)strongself = weakself;
            imageView.image = imageArray[strongself.page];
            CGRect currentOldframe = [[self.contentView viewWithTag:strongself.page+2000] convertRect:[self.contentView viewWithTag:strongself.page+2000].bounds toView:self.contentView.window];
            [strongself removeFromSuperview];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                imageView.frame = currentOldframe;
                blackView.alpha = 0;
                
            } completion:^(BOOL finished) {
                [blackView removeFromSuperview];
                
            }];
            
           
        };
        
    }];

}
@end
