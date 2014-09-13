//
//  NNCircleProgressView.m
//  NNCircleProgressViewDemo
//
//  Created by noughts on 2014/09/12.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "NNCircleProgressView.h"
#import "NNCircleProgressArcLayer.h"

@implementation NNCircleProgressView{
	CAShapeLayer* _arc;
	CGFloat _progress;
	UIColor* _color;
	CGFloat _intercept;// 円弧表示の切片
	CGFloat _lineWidth;
	NSTimer* _timer;
	NSInteger _startAngle;
	NSInteger _endAngle;
	BOOL _beat;
}

+(Class)layerClass{
	return [NNCircleProgressArcLayer class];
}

-(void)awakeFromNib{
	[super awakeFromNib];
	
	_arc = (CAShapeLayer*)self.layer;
	
	if( _lineWidth == 0 ){
		_lineWidth = 1;
	}
	
	_intercept = 0.33;
	int radius = self.frame.size.width / 2;
	
	CGFloat rad1 = 0 * M_PI / 180;
	CGFloat rad2 = 360*999 * M_PI / 180;
	
	CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _arc.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:rad1 endAngle:rad2 clockwise:YES].CGPath;
	
	
    _arc.fillColor = [UIColor clearColor].CGColor;
    _arc.strokeColor = _color.CGColor;
    _arc.lineWidth = _lineWidth;
	_arc.strokeStart = 0;
	_arc.strokeEnd = 0;
	
}


-(void)setLineWidth:(CGFloat)lineWidth{
	_arc.lineWidth = lineWidth;
	_lineWidth = lineWidth;
}

-(void)setColor:(UIColor*)color{
	_color = color;
	_arc.strokeColor = _color.CGColor;
}

-(void)start{
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hoge) userInfo:nil repeats:YES];
	
	CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)hoge{
	_beat = !_beat;
	
	CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
	
	CGFloat progress = 0.25;
	NSInteger posi = 10;
	NSInteger nega = posi+100;
	if( nega+posi > 360 ){
		nega = 360 - posi;
	}
	
	anim1.fromValue = @([self strokeValueFromAngle:_endAngle]);
	anim2.fromValue = @([self strokeValueFromAngle:_startAngle-posi]);
	if( _beat ){
		_endAngle += nega;
	} else {
		_startAngle += nega;
	}
	anim1.toValue = @([self strokeValueFromAngle:_endAngle]);
	anim2.toValue = @([self strokeValueFromAngle:_startAngle-posi]);
	
	CAAnimationGroup* group = [[CAAnimationGroup alloc] init];
	group.duration = 0.33;
	group.animations = @[anim1, anim2];
	group.removedOnCompletion = NO;
	group.fillMode = kCAFillModeForwards;
	group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[_arc addAnimation:group forKey:@"hge"];
}


-(CGFloat)strokeValueFromAngle:(NSInteger)angle{
	NSInteger maxAngle = 360 * 999;
	return (CGFloat)angle / (CGFloat)maxAngle;
}


-(void)setProgress:(CGFloat)progress{
	CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = 0.25;
	// 進捗が0の時にも線が見えるようにする
	CGFloat from = (1-_intercept) * _progress;
	CGFloat to = (1-_intercept) * progress;
    drawAnimation.fromValue = [NSNumber numberWithFloat:_intercept+from];
    drawAnimation.toValue   = [NSNumber numberWithFloat:_intercept+to];
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
