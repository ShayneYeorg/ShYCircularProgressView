//
//  ShYCircularProgressView.m
//  TestCircularProgress
//
//  Created by 杨淳引 on 16/4/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "ShYCircularProgressView.h"

//角度转为弧度
#define DEGREES_TO_RADIANS(x) (0.0174532925 * (x))

@interface ShYCircularProgressView ()

@property (nonatomic, assign) CGFloat progress; //当前进度百分比
@property (nonatomic, assign) CGFloat terminalProgress; //目标百分比
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ShYCircularProgressView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)clean {
    //清空进度条
    self.progress = 0;
    self.terminalProgress = 0;
    if ([self.timer isValid]) [self.timer invalidate];
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    //无论如何先清空进度条
    [self clean];
    
    if (progress <= 0) {
        return; //捣乱的滚蛋
        
    } else if (progress > 1) {
        progress = 1;
    }
    
    self.terminalProgress = progress;
    if (animated) {
        self.progress = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    } else {
        self.progress = progress;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)progressChange {
    self.progress += 0.01;
    [self setNeedsDisplay];
    if (self.progress > self.terminalProgress) {
        [self.timer invalidate];
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat progressWidth = 5;
    CGPoint centerPoint = CGPointMake(rect.size.width / 2, rect.size.width / 2);
    CGFloat radius = MAX(rect.size.height, rect.size.width) / 2;
    CGFloat pointWidth = progressWidth * (rect.size.width / 125); //起点、结束点、终点处制造圆角效果的小圆点的直径
    
    //起点
    CGFloat startDegree = -155;
    CGFloat startX = centerPoint.x + (radius-(pointWidth/2)) * cos(startDegree * M_PI / 180);
    CGFloat startY = centerPoint.y - (radius-(pointWidth/2)) * sin(startDegree * M_PI / 180);
    CGPoint startPoint = CGPointMake(startX, startY);
    
    //运动结束点
    CGFloat stopRadian = DEGREES_TO_RADIANS((self.progress*230)-205);
    CGFloat stopX = centerPoint.x + (radius-(pointWidth/2)) * cos(-(self.progress*230+155) * M_PI / 180);
    CGFloat stopY = centerPoint.y - (radius-(pointWidth/2)) * sin(-(self.progress*230+155) * M_PI / 180);
    CGPoint stopPoint = CGPointMake(stopX, stopY);
    
    //终点
    CGFloat endRadian = DEGREES_TO_RADIANS(230-205);
    CGFloat endX = centerPoint.x + (radius-(pointWidth/2)) * cos(-(230+155) * M_PI / 180);
    CGFloat endY = centerPoint.y - (radius-(pointWidth/2)) * sin(-(230+155) * M_PI / 180);
    CGPoint endPoint = CGPointMake(endX, endY);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画背景条所属的扇形
    [self.backTrackColor setFill];
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_TO_RADIANS(-startDegree), endRadian, NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    //背景条的起点
    CGContextAddEllipseInRect(context, CGRectMake(startPoint.x - pointWidth/2, startPoint.y - pointWidth/2, pointWidth, pointWidth));
    CGContextFillPath(context);
    
    //背景条的终点
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pointWidth/2, endPoint.y - pointWidth/2, pointWidth, pointWidth));
    CGContextFillPath(context);
    
    //画进度条所属的扇形
    [self.progressTrackColor setFill];
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_TO_RADIANS(-startDegree), stopRadian, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    //terminalProgress为0的时候不要显示出进度条的起点和结束点
    if (self.terminalProgress != 0) {
        //进度条的起点
        CGContextAddEllipseInRect(context, CGRectMake(startPoint.x - pointWidth/2, startPoint.y - pointWidth/2, pointWidth, pointWidth));
        CGContextFillPath(context);
    
        //进度条的结束点
        CGContextAddEllipseInRect(context, CGRectMake(stopPoint.x - pointWidth/2, stopPoint.y - pointWidth/2, pointWidth, pointWidth));
        CGContextFillPath(context);
    }
    
    //将扇形中间部分挖空
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius - pointWidth;
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
    CGContextFillPath(context);
}

#pragma mark - Getter

- (UIColor *)backTrackColor {
    if (!_backTrackColor) {
        _backTrackColor = [UIColor colorWithRed:((11) / 255.0) green:((114) / 255.0) blue:((188) / 255.0) alpha:1.0]; //默认颜色
        
    }
    return _backTrackColor;
}

- (UIColor *)progressTrackColor {
    if (!_progressTrackColor) {
        _progressTrackColor = [UIColor colorWithRed:((136) / 255.0) green:((231) / 255.0) blue:((60) / 255.0) alpha:1.0]; //默认颜色
    }
    return _progressTrackColor;
}

@end
