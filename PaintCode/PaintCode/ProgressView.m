//
//  ProgressView.m
//  PaintCode
//
//  Created by Xu Xian on 14-4-16.
//  Copyright (c) 2014年 Felipe Laso Marsetti. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{//// General Declarations
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColorDark = [UIColor colorWithRed: 0.322 green: 0.322 blue: 0.322 alpha: 1];
    UIColor* gradientColorLight = [UIColor colorWithRed: 0.416 green: 0.416 blue: 0.416 alpha: 1];
    UIColor* darkShadowColor = [UIColor colorWithRed: 0.2 green: 0.2 blue: 0.2 alpha: 1];
    UIColor* lightShadowColor = [UIColor colorWithRed: 0.671 green: 0.671 blue: 0.671 alpha: 1];
    UIColor* progressGradientColorDark = [UIColor colorWithRed: 0.188 green: 0.188 blue: 0.188 alpha: 1];
    UIColor* progressGradientColorLight = [UIColor colorWithRed: 0.247 green: 0.247 blue: 0.247 alpha: 1];
    UIColor* progressTrackColor = [UIColor colorWithRed: 0 green: 0.886 blue: 0.886 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColorDark.CGColor,
                               (id)gradientColorLight.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    NSArray* progressGradientColors = [NSArray arrayWithObjects:
                                       (id)progressGradientColorDark.CGColor,
                                       (id)progressGradientColorLight.CGColor, nil];
    CGFloat progressGradientLocations[] = {0, 1};
    CGGradientRef progressGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)progressGradientColors, progressGradientLocations);
    
    //// Shadow Declarations
    UIColor* darkShadow = darkShadowColor;
    CGSize darkShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat darkShadowBlurRadius = 1.5;
    UIColor* lightShadow = lightShadowColor;
    CGSize lightShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat lightShadowBlurRadius = 0;
    
    //// Frames
    CGRect progressBarFrame = rect;
    
    //// Subframes
    CGRect progressTrackFrame = CGRectMake(
                                           CGRectGetMinX(progressBarFrame) + 12,
                                           CGRectGetMinY(progressBarFrame) + 11,
                                           self.progress * (CGRectGetWidth(progressBarFrame) - 28),
                                           CGRectGetHeight(progressBarFrame) - 24);
    
    
    //// ProgressBar
    {
        //// Border Drawing
        CGRect borderRect = CGRectMake(CGRectGetMinX(progressBarFrame), CGRectGetMinY(progressBarFrame), CGRectGetWidth(progressBarFrame), 34);
        UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: borderRect cornerRadius: 4];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, darkShadowOffset, darkShadowBlurRadius, darkShadow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [borderPath addClip];
        CGContextDrawLinearGradient(context, gradient,
                                    CGPointMake(CGRectGetMidX(borderRect), CGRectGetMinY(borderRect)),
                                    CGPointMake(CGRectGetMidX(borderRect), CGRectGetMaxY(borderRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        
        ////// Border Inner Shadow
        CGRect borderBorderRect = CGRectInset([borderPath bounds], -lightShadowBlurRadius, -lightShadowBlurRadius);
        borderBorderRect = CGRectOffset(borderBorderRect, -lightShadowOffset.width, -lightShadowOffset.height);
        borderBorderRect = CGRectInset(CGRectUnion(borderBorderRect, [borderPath bounds]), -1, -1);
        
        UIBezierPath* borderNegativePath = [UIBezierPath bezierPathWithRect: borderBorderRect];
        [borderNegativePath appendPath: borderPath];
        borderNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = lightShadowOffset.width + round(borderBorderRect.size.width);
            CGFloat yOffset = lightShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        lightShadowBlurRadius,
                                        lightShadow.CGColor);
            
            [borderPath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderBorderRect.size.width), 0);
            [borderNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [borderNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        
        
        //// ProgressBorder Drawing
        CGRect progressBorderRect = CGRectMake(CGRectGetMinX(progressBarFrame) + 10, CGRectGetMinY(progressBarFrame) + 9, CGRectGetWidth(progressBarFrame) - 24, 14);
        UIBezierPath* progressBorderPath = [UIBezierPath bezierPathWithRoundedRect: progressBorderRect cornerRadius: 7];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, lightShadowOffset, lightShadowBlurRadius, lightShadow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [progressBorderPath addClip];
        CGContextDrawLinearGradient(context, progressGradient,
                                    CGPointMake(CGRectGetMidX(progressBorderRect), CGRectGetMinY(progressBorderRect)),
                                    CGPointMake(CGRectGetMidX(progressBorderRect), CGRectGetMaxY(progressBorderRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        
        ////// ProgressBorder Inner Shadow
        CGRect progressBorderBorderRect = CGRectInset([progressBorderPath bounds], -darkShadowBlurRadius, -darkShadowBlurRadius);
        progressBorderBorderRect = CGRectOffset(progressBorderBorderRect, -darkShadowOffset.width, -darkShadowOffset.height);
        progressBorderBorderRect = CGRectInset(CGRectUnion(progressBorderBorderRect, [progressBorderPath bounds]), -1, -1);
        
        UIBezierPath* progressBorderNegativePath = [UIBezierPath bezierPathWithRect: progressBorderBorderRect];
        [progressBorderNegativePath appendPath: progressBorderPath];
        progressBorderNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = darkShadowOffset.width + round(progressBorderBorderRect.size.width);
            CGFloat yOffset = darkShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        darkShadowBlurRadius,
                                        darkShadow.CGColor);
            
            [progressBorderPath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(progressBorderBorderRect.size.width), 0);
            [progressBorderNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [progressBorderNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        
        
        //// ProgressTrackGroup
        {
            //// ProgressTrackActive Drawing
            UIBezierPath* progressTrackActivePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(progressTrackFrame), CGRectGetMinY(progressTrackFrame), CGRectGetWidth(progressTrackFrame), 10) cornerRadius: 5];
            [progressTrackColor setFill];
            [progressTrackActivePath fill];
        }
    }
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(progressGradient);
    CGColorSpaceRelease(colorSpace);
    
}

@end
