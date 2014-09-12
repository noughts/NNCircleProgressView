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
	UIColor* _color;
	CGFloat _intercept;// 円弧表示の切片
	NSTimer* _timer;
	BOOL _beat;
}

-(void)awakeFromNib{
	[super awakeFromNib];
	
	_intercept = 0.33;
	int radius = self.frame.size.width / 2;
	
    _arc = [CAShapeLayer layer];
	
	CGFloat rad1 = 0 * M_PI / 180;
	CGFloat rad2 = 360 * M_PI / 180;
    _arc.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:radius startAngle:rad1 endAngle:rad2 clockwise:NO].CGPath;
	_arc.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	
    _arc.fillColor = [UIColor clearColor].CGColor;
    _arc.strokeColor = _color.CGColor;
    _arc.lineWidth = 2;
	_arc.strokeEnd = 0;
	
    [self.layer addSublayer:_arc];
}


-(void)setColor:(UIColor*)color{
	_color = color;
	_arc.strokeColor = _color.CGColor;
}

-(void)start{
	CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
	
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(time:) userInfo:nil repeats:YES];
}


-(void)time:(NSTimer*)timer{
	if( _beat ){
		[self setArcSizeFrom:0.1 to:0.5];
	} else {
		[self setArcSizeFrom:0.5 to:0.1];
	}
	_beat = !_beat;
}


-(void)setProgress:(CGFloat)progress{
	_progress = progress;
}

-(void)setArcSizeFrom:(CGFloat)from to:(CGFloat)to{
	CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = 0.6;
    drawAnimation.fromValue = @(from);
    drawAnimation.toValue   = @(to);
	drawAnimation.removedOnCompletion = NO;
	drawAnimation.fillMode = kCAFillModeForwards;
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_arc addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}






-(void)stop{
	[self.layer removeAllAnimations];
	[_timer invalidate];
}


@end
