//
//  NNCircleProgressArcLayer.m
//  NNCircleProgressViewDemo
//
//  Created by noughts on 2014/09/13.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "NNCircleProgressArcLayer.h"

@implementation NNCircleProgressArcLayer

+(BOOL)needsDisplayForKey:(NSString *)key{
	if( [key isEqualToString:@"strokeStart"] ){
		return YES;
	}
	return [super needsDisplayForKey:key];
}

@end
