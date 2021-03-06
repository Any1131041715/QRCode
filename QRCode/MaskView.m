//
//  MaskView.m
//  QRCodeDemo
//
//  Created by huanxin xiong on 2016/12/6.
//  Copyright © 2016年 xiaolu zhao. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()

@property (nonatomic, strong) CALayer *lineLayer;

@end

@implementation MaskView

- (void)drawRect:(CGRect)rect
{
    CGFloat WH = [[UIScreen mainScreen] bounds].size.width/1.3;
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = WH;
    CGFloat pickingFieldHeight = WH;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2, (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    //贝塞尔
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    //填充使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
    
    

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.lineLayer = [CALayer layer];
    self.lineLayer.contents = (id)[UIImage imageNamed:@"line"].CGImage;
    [self.layer addSublayer:self.lineLayer];
    [self resumeAnimation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//    
//    self.lineLayer = [CALayer layer];
//    self.lineLayer.contents = (id)[UIImage imageNamed:@"line"].CGImage;
//    [self.layer addSublayer:self.lineLayer];
//    [self resumeAnimation];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self setNeedsDisplay];
    
    self.lineLayer.frame = CGRectMake((self.frame.size.width - 300) / 2, (self.frame.size.height - 300) / 2, 300, 2);
}

- (void)stopAnimation
{
    [self.lineLayer removeAnimationForKey:@"translationY"];
}

- (void)resumeAnimation
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 1.5;
    basic.repeatCount = NSIntegerMax;
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
}

@end
