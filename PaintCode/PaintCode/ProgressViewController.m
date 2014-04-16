//
//  SecondViewController.m
//  PaintCode
//
//  Created by Felipe on 5/21/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "ProgressViewController.h"

#import "ProgressView.h"

#define INTERVAL_PROGRESS 0.1

@implementation ProgressViewController

-(void)viewDidLoad
{
    //    _customButton
    [super viewDidLoad];
    
    self.progressView.progress = 0.0;
    
    [_progressView setNeedsDisplay];
}
- (IBAction)pressProgress:(id)sender {
    self.progressView.progress = MIN(1.0, self.progressView.progress + INTERVAL_PROGRESS);
    
    [self.progressView setNeedsDisplay];
}

@end
