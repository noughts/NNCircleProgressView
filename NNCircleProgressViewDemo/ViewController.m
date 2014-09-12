//
//  ViewController.m
//  NNCircleProgressViewDemo
//
//  Created by noughts on 2014/09/12.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "ViewController.h"
#import "NNCircleProgressView.h"


@implementation ViewController{
	__weak IBOutlet NNCircleProgressView* _progressView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}



-(IBAction)start:(id)sender{
	[_progressView start];
}

-(IBAction)stop:(id)sender{
	[_progressView stop];
}

-(IBAction)onValueChange:(UISlider*)sender{
	[_progressView setProgress:sender.value];
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
