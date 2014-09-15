//
//  NNCircleProgressView.h
//  NNCircleProgressViewDemo
//
//  Created by noughts on 2014/09/12.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNCircleProgressView : UIView

@property(nonatomic) UIColor* color;
@property(nonatomic) CGFloat progress;

-(void)start;
-(void)stop;

@end
