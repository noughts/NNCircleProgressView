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
	CGFloat _prevProgress;
	UIColor* _color;
	CGFloat _intercept;// 円弧表示の切片
	CGFloat _lineWidth;
	NSTimer* _timer;
	NSInteger _startAngle;
	NSInteger _endAngle;
	NSInteger _startAngleWhenProgressStart;// プログレスが0から増えたタイミングのstartAngle
	BOOL _beat;
	NSInteger _pathMultiplier;
	CADisplayLink* _link;
	float _rotation;
}

+(Class)layerClass{
	return [NNCircleProgressArcLayer class];
}

-(void)awakeFromNib{
	[super awakeFromNib];
	
	_pathMultiplier = 200;
	_arc = (CAShapeLayer*)self.layer;
	
	if( _lineWidth == 0 ){
		_lineWidth = 1;
	}
	
	_intercept = 0.33;
	int radius = self.frame.size.width / 2;
	
	CGFloat rad1 = 0 * M_PI / 180;
	CGFloat rad2 = 360*_pathMultiplier * M_PI / 180;
	
	CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _arc.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:rad1 endAngle:rad2 clockwise:YES].CGPath;
	
	
    _arc.fillColor = [UIColor clearColor].CGColor;
	if( _color ){
		_arc.strokeColor = _color.CGColor;
	} else {
		_arc.strokeColor = [UIColor whiteColor].CGColor;
	}
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
	[_arc removeAllAnimations];
	_progress = 0;
	_prevProgress = 0;
	_startAngleWhenProgressStart = 0;
	_startAngle = 0;
	_endAngle = 0;
	_beat = NO;
	_arc.strokeStart = 0;
	_arc.strokeEnd = 0;
	if( _timer ){
		[_timer invalidate];
	}
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimerTick) userInfo:nil repeats:YES];
	[self onTimerTick];
	
	if( _link ){
		[_link invalidate];
	}
	_link = [CADisplayLink displayLinkWithTarget:self selector:@selector(onEnterFrame)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


-(void)onEnterFrame{
	CGAffineTransform transform = CGAffineTransformMakeRotation(_rotation);
	self.transform = transform;
	_rotation += 0.15;
	
	if( _progress == 0 ){
		return;
	}
	if( _prevProgress == 0 && _progress != 0 ){
		// はじめてプログレスが0を超えた時
		_startAngleWhenProgressStart = _startAngle;
		[_arc removeAnimationForKey:@"beat"];
		_arc.strokeStart = [self strokeValueFromAngle:_startAngle];
		_arc.strokeEnd = [self strokeValueFromAngle:_endAngle];
	}
	
	NSInteger toAngle = _startAngleWhenProgressStart + 360*_progress;
	double targetStrokeEnd = [self strokeValueFromAngle:toAngle];
	double distance = targetStrokeEnd - (double)_arc.strokeEnd;
	
	_arc.strokeEnd += distance / 4;
	_prevProgress = _progress;
}





-(void)onTimerTick{
	if( _progress != 0 ){
		[_timer invalidate];
		return;
	}
	
	_beat = !_beat;
	
	CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
	
	NSInteger posi = 30;
	NSInteger nega = 180;
	
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
	[_arc addAnimation:group forKey:@"beat"];
}


-(double)strokeValueFromAngle:(NSInteger)angle{
	NSInteger maxAngle = 360 * _pathMultiplier;
	return (double)angle / (double)maxAngle;
}





-(void)stop{
	[_timer invalidate];
	[self.layer removeAllAnimations];
	[_link invalidate];
}


@end
