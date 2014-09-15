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
	__weak IBOutlet UISlider* slider;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_progressView.color = [UIColor redColor];
}



-(IBAction)start:(id)sender{
	[_progressView start];
}

-(IBAction)stop:(id)sender{
	[_progressView stop];
}

-(IBAction)onValueChange:(UISlider*)sender{
	_progressView.progress = sender.value;
//	[_progressView setProgress:sender.value animated:YES];
}


-(IBAction)onSetProgressButtonTap:(id)sender{
	_progressView.progress = slider.value;
//	[_progressView setProgress:slider.value animated:YES];
}










- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
