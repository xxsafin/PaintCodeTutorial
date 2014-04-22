//
//  BezierView.m
//  PaintCode
//
//  Created by Xu Xian on 14-4-16.
//  Copyright (c) 2014年 Felipe Laso Marsetti. All rights reserved.
//

#import "BezierView.h"

#define kArrowFrameHeight       38.0
#define kArrowFrameHeightHalf   19.0
#define kArrowFrameWidth        30.0
#define kArrowFrameWidthHalf    15.0

typedef enum {
    TouchStateInvalid,
    TouchStateRightArrow
} TouchStates;

@interface BezierView ()

@end

@implementation BezierView
{
    CGFloat _initialLeftArrowTipY;
    CGPoint _initialOrigin;
    CGPoint _leftArrowTip;
    CGPoint _rightArrowTip;
    TouchStates _touchState;
}


-(id)initWithLeftArrowTipPoint:(CGPoint)leftArrowTip
            rightArrowTipPoint:(CGPoint)rightArrowTip
                releaseHandler:(BezierViewReleaseHandler)releaseHandler
{
    CGFloat x = leftArrowTip.x;
    CGFloat y = leftArrowTip.y >= rightArrowTip.y ? rightArrowTip.y : leftArrowTip.y;
    CGFloat width = ABS(leftArrowTip.x - rightArrowTip.x);
    CGFloat height = ABS(leftArrowTip.y - rightArrowTip.y) + kArrowFrameHeight;
    CGRect frame = CGRectMake(x,
                              y,
                              width,
                              height);
    
    if(self = [super initWithFrame:frame])
    {
        CGFloat leftYPosition = leftArrowTip.y >= rightArrowTip.y ? height - kArrowFrameHeightHalf : kArrowFrameHeightHalf;
        CGFloat rightYPosition = rightArrowTip.y >= leftArrowTip.y ? height - kArrowFrameHeightHalf : kArrowFrameHeightHalf;
        
        _initialLeftArrowTipY = leftArrowTip.y;
        _initialOrigin = self.frame.origin;
        _leftArrowTip = CGPointMake(0, leftYPosition);
        _rightArrowTip = CGPointMake(width, rightYPosition);
        
        _touchState = TouchStateInvalid;
        self.releaseHandler = releaseHandler;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(CGRect)rightArrowFrame
{
    return CGRectMake(_rightArrowTip.x - kArrowFrameWidth,
                      _rightArrowTip.y - kArrowFrameHeightHalf,
                      kArrowFrameWidth,
                      kArrowFrameHeight);
}

#pragma mark - Touch Handling
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(CGRectContainsPoint(self.rightArrowFrame, point))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchState = TouchStateInvalid;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if(CGRectContainsPoint(self.rightArrowFrame, touchPoint))
    {
        _touchState = TouchStateRightArrow;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_touchState == TouchStateRightArrow)
    {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        
        if(touchPoint.y >= _leftArrowTip.y)
        {
            _leftArrowTip = CGPointMake(0, kArrowFrameHeightHalf);
            _rightArrowTip = CGPointMake(_rightArrowTip.x, touchPoint.y);
            
            self.frame = CGRectMake(_initialOrigin.x,
                                    _initialOrigin.y,
                                    self.frame.size.width,
                                    touchPoint.y + kArrowFrameHeightHalf);
        }
        else
        {
            CGFloat newYPosition = [self convertPoint:touchPoint toView:self.superview].y - kArrowFrameHeightHalf;
            
            CGFloat newHeight = _initialLeftArrowTipY - newYPosition + kArrowFrameHeight;
            
            self.frame = CGRectMake(_initialOrigin.x,
                                    newYPosition,
                                    self.frame.size.width,
                                    newHeight);
            
            _leftArrowTip = CGPointMake(0,
                                        newHeight - kArrowFrameHeightHalf);
            _rightArrowTip = CGPointMake(_rightArrowTip.x,
                                         kArrowFrameHeightHalf);
        }
        
        [self setNeedsDisplay];
    }
    else
    {
        //do nothing
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchState = TouchStateInvalid;
    
    //judge for release
    if(self.releaseHandler)
    {
        CGPoint superViewPosition = [self convertPoint:_rightArrowTip toView:self.superview];
        
        self.releaseHandler(superViewPosition);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor2 = [UIColor colorWithRed: 0.549 green: 0.627 blue: 0.753 alpha: 1];
    UIColor* fillColor = [UIColor colorWithRed: 0.22 green: 0.267 blue: 0.384 alpha: 1];
    UIColor* innerHighlightColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* outerShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)fillColor2.CGColor,
                               (id)fillColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* innerHighlight = innerHighlightColor;
    CGSize innerHighlightOffset = CGSizeMake(0.1, 1.1);
    CGFloat innerHighlightBlurRadius = 2;
    UIColor* outerShadow = outerShadowColor;
    CGSize outerShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat outerShadowBlurRadius = 2;
    
    //// Frames
    CGRect frame = CGRectMake(_leftArrowTip.x,
                              _leftArrowTip.y - kArrowFrameHeightHalf,
                              kArrowFrameWidth,
                              kArrowFrameHeight);
    CGRect frame2 = self.rightArrowFrame;
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 19)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 7.78)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2) + 13) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 54.27, CGRectGetMinY(frame) + 13) controlPoint2: CGPointMake(CGRectGetMinX(frame2) - 27.84, CGRectGetMinY(frame2) + 13)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2)) controlPoint1: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2) + 8.29) controlPoint2: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 30, CGRectGetMinY(frame2) + 19)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2) + 38)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2) + 25) controlPoint1: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2) + 38) controlPoint2: CGPointMake(CGRectGetMinX(frame2) + 10, CGRectGetMinY(frame2) + 29.99)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 25) controlPoint1: CGPointMake(CGRectGetMinX(frame2) - 23.27, CGRectGetMinY(frame2) + 25) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 55.54, CGRectGetMinY(frame) + 25)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 38) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 29.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 20, CGRectGetMinY(frame) + 38)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 19)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, outerShadowOffset, outerShadowBlurRadius, outerShadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [bezierPath addClip];
    CGRect bezierBounds = CGPathGetPathBoundingBox(bezierPath.CGPath);
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMinY(bezierBounds)),
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMaxY(bezierBounds)),
                                0);
    CGContextEndTransparencyLayer(context);
    
    ////// Bezier Inner Shadow
    CGRect bezierBorderRect = CGRectInset([bezierPath bounds], -innerHighlightBlurRadius, -innerHighlightBlurRadius);
    bezierBorderRect = CGRectOffset(bezierBorderRect, -innerHighlightOffset.width, -innerHighlightOffset.height);
    bezierBorderRect = CGRectInset(CGRectUnion(bezierBorderRect, [bezierPath bounds]), -1, -1);
    
    UIBezierPath* bezierNegativePath = [UIBezierPath bezierPathWithRect: bezierBorderRect];
    [bezierNegativePath appendPath: bezierPath];
    bezierNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = innerHighlightOffset.width + round(bezierBorderRect.size.width);
        CGFloat yOffset = innerHighlightOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    innerHighlightBlurRadius,
                                    innerHighlight.CGColor);
        
        [bezierPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezierBorderRect.size.width), 0);
        [bezierNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [bezierNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
    
    [fillColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
