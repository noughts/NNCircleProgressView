//
//  NNCircleProgressView.m
//  NNCircleProgressViewDemo
//
//  Created by noughts on 2014/09/12.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "NNCircleProgressView.h"

@implementation NNCircleProgressView{
	CAShapeLayer* _arc;
	CGFloat _progress;
}

-(void)awakeFromNib{
	[super awakeFromNib];
	
	int radius = self.frame.size.width / 2;
	
    _arc = [CAShapeLayer layer];
	
	CGFloat rad1 = 0 * M_PI / 180;
	CGFloat rad2 = 360 * M_PI / 180;
    _arc.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:radius startAngle:rad1 endAngle:rad2 clockwise:YES].CGPath;
	_arc.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	
    _arc.fillColor = [UIColor clearColor].CGColor;
    _arc.strokeColor = [UIColor purpleColor].CGColor;
    _arc.lineWidth = 2;
	_arc.strokeEnd = 0.33;
	
    [self.layer addSublayer:_arc];
}

-(void)start{
	CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


-(void)setProgress:(CGFloat)progress{
	CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = 0.25;
	// 進捗が0の時にも線が見えるようにする
	CGFloat from = (100-33)/100.0 * _progress;
	CGFloat to = (100-33)/100.0 * progress;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.33+from];
    drawAnimation.toValue   = [NSNumber numberWithFloat:0.33+to];
	drawAnimation.removedOnCompletion = NO;
	drawAnimation.fillMode = kCAFillModeForwards;
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_arc addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
	_progress = progress;
}

-(void)stop{
	[self.layer removeAllAnimations];
}


@end
