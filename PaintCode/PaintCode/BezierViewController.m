//
//  BezierViewController.m
//  PaintCode
//
//  Created by Felipe on 5/21/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "BezierViewController.h"
#import "BezierView.h"

@implementation BezierViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    BezierView *midArrow = [[BezierView alloc] initWithLeftArrowTipPoint:CGPointMake(20, 20)
                                                      rightArrowTipPoint:CGPointMake(300, 130)
                                                          releaseHandler:nil];
    [self.view addSubview:midArrow];
}

@end
