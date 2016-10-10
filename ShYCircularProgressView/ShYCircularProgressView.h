//
//  ShYCircularProgressView.h
//  TestCircularProgress
//
//  Created by 杨淳引 on 16/4/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShYCircularProgressView : UIView

@property (nonatomic, strong) UIColor *backTrackColor; //背景条颜色
@property (nonatomic, strong) UIColor *progressTrackColor; //进度条颜色

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)clean;

@end

