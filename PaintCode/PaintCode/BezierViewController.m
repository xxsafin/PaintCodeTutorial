//
//  BezierViewController.m
//  PaintCode
//
//  Created by Felipe on 5/21/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "BezierViewController.h"
#import "BezierView.h"

#define kInteractThreshold 10

@implementation BezierViewController
{
    BezierView *_firstArrow;
    BezierView *_secondArrow;
    BezierView *_thirdArrow;
    
    BOOL _firstResultCorrect;
    BOOL _secondResultCorrect;
    BOOL _thirdResultCorrect;
    
    UIAlertView *_resultAlert;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _firstArrow = [[BezierView alloc] initWithLeftArrowTipPoint:CGPointMake(CGRectGetMaxX(_firstEquation.frame),
                                                                            CGRectGetMidY(_firstEquation.frame))
                                             rightArrowTipPoint:CGPointMake(CGRectGetMinX(_thirdResult.frame),
                                                                            CGRectGetMidY(_thirdResult.frame))
                                                 releaseHandler:^(CGPoint releasePoint) {
                                                     [self processInteractionWithReleasePoint:releasePoint forViewWithTag:1];
                                                 }];
    [self.view addSubview:_firstArrow];
    
    
    _secondArrow = [[BezierView alloc] initWithLeftArrowTipPoint:CGPointMake(CGRectGetMaxX(_secondEquation.frame),
                                                                            CGRectGetMidY(_secondEquation.frame))
                                             rightArrowTipPoint:CGPointMake(CGRectGetMinX(_firstResult.frame),
                                                                            CGRectGetMidY(_firstResult.frame))
                                                 releaseHandler:^(CGPoint releasePoint) {
                                                     [self processInteractionWithReleasePoint:releasePoint forViewWithTag:2];
                                                 }];
    [self.view addSubview:_secondArrow];
    
    _thirdArrow = [[BezierView alloc] initWithLeftArrowTipPoint:CGPointMake(CGRectGetMaxX(_thirdEquation.frame),
                                                                             CGRectGetMidY(_thirdEquation.frame))
                                              rightArrowTipPoint:CGPointMake(CGRectGetMinX(_secondResult.frame),
                                                                             CGRectGetMidY(_secondResult.frame))
                                                  releaseHandler:^(CGPoint releasePoint) {
                                                      [self processInteractionWithReleasePoint:releasePoint forViewWithTag:3];
                                                  }];
    [self.view addSubview:_thirdArrow];
}

-(void)processInteractionWithReleasePoint:(CGPoint)releasePoint forViewWithTag:(NSUInteger)tag
{
    switch (tag) {
        case 1:
            [self changeResult:ABS(CGRectGetMidY(_firstResult.frame) - releasePoint.y) < kInteractThreshold
                           tag:1];
            break;
        case 2:
            
            [self changeResult:ABS(CGRectGetMidY(_secondResult.frame) - releasePoint.y) < kInteractThreshold
                           tag:2];
            break;
        case 3:
            
            [self changeResult:ABS(CGRectGetMidY(_thirdResult.frame) - releasePoint.y) < kInteractThreshold
                           tag:3];
            break;
    }
    
    if(_firstResultCorrect && _secondResultCorrect && _thirdResultCorrect)
    {
        if(!_resultAlert)
        {
            _resultAlert = [[UIAlertView alloc] initWithTitle:@"小朋友"
                                                      message:@"算数学的不错哇！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil];
        }
        
        [_resultAlert show];
    }
}

-(void)changeResult:(BOOL)result tag:(NSUInteger)tag
{
    switch (tag) {
        case 1:
            _firstResultCorrect = result;
            _firstEquation.textColor = _firstResultCorrect? [UIColor greenColor] : [UIColor blackColor];
            _firstResult.textColor = _firstResultCorrect? [UIColor greenColor] : [UIColor blackColor];
            break;
        case 2:
            _secondResultCorrect = result;
            _secondEquation.textColor = _secondResultCorrect? [UIColor greenColor] : [UIColor blackColor];
            _secondResult.textColor = _secondResultCorrect? [UIColor greenColor] : [UIColor blackColor];
            break;
        case 3:
            _thirdResultCorrect = result;
            _thirdEquation.textColor = _thirdResultCorrect? [UIColor greenColor] : [UIColor blackColor];
            _thirdResult.textColor = _thirdResultCorrect? [UIColor greenColor] : [UIColor blackColor];
            break;
    }
}

@end
