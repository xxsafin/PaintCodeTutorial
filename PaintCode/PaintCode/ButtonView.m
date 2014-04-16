//
//  ButtonView.m
//  PaintCode
//
//  Created by Xu Xian on 14-4-16.
//  Copyright (c) 2014年 Felipe Laso Marsetti. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _red = 1;
        _green = 0;
        _blue = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        // Initialization code
        _red = 1;
        _green = 0;
        _blue = 0;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    self = [self initWithFrame:frame];
    
    if(self)
    {
    }
    
    return self;
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)value {
    [super setHighlighted:value];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)value {
    [super setSelected:value];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    
    
    UIColor* buttonColorLight = [UIColor colorWithRed:_red green: _green blue:_blue alpha: 1];
    if(self.state == UIControlStateHighlighted)
    {
        buttonColorLight = [UIColor colorWithRed:_red
                                           green:_green
                                            blue:_blue alpha:0.5];
    }
    
    CGFloat buttonColorLightRGBA[4];
    [buttonColorLight getRed:&buttonColorLightRGBA[0]
                       green:&buttonColorLightRGBA[1]
                        blue:&buttonColorLightRGBA[2]
                       alpha:&buttonColorLightRGBA[3]];
    
    UIColor* buttonColorDark = [UIColor colorWithRed:buttonColorLightRGBA[0]* 0.5
                                               green:buttonColorLightRGBA[1] * 0.5
                                                blue:buttonColorLightRGBA[2] * 0.5
                                                alpha:buttonColorLightRGBA[3]];
    UIColor* innerGlowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* highLightColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Gradient Declarations
    NSArray* buttonGradientColors = [NSArray arrayWithObjects:
                                     (id)buttonColorLight.CGColor,
                                     (id)[UIColor colorWithRed: buttonColorLightRGBA[0] * 0.75
                                                         green: buttonColorLightRGBA[1] * 0.75
                                                          blue: buttonColorLightRGBA[2] * 0.75
                                                         alpha: buttonColorLightRGBA[3]].CGColor,
                                     (id)buttonColorDark.CGColor, nil];
    CGFloat buttonGradientLocations[] = {0, 0.50, 1};
    CGGradientRef buttonGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)buttonGradientColors, buttonGradientLocations);
    
    //// Shadow Declarations
    UIColor* glow = innerGlowColor;
    CGSize glowOffset = CGSizeMake(0.1, -0.1);
    CGFloat glowBlurRadius = 3;
    UIColor* hightlight = highLightColor;
    CGSize hightlightOffset = CGSizeMake(0.1, 2.1);
    CGFloat hightlightBlurRadius = 3;
    
    //// Frames
//    CGRect buttonFrame = CGRectMake(0, 0, 480, 49);
    
    
    //// Group
    {
        //// Rounded Rectangle Drawing
        CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(rect) + 4, CGRectGetMinY(rect) + 4, CGRectGetWidth(rect) - 7, CGRectGetHeight(rect) - 8);
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 4];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, glowOffset, glowBlurRadius, glow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, buttonGradient,
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        
        ////// Rounded Rectangle Inner Shadow
        CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -hightlightBlurRadius, -hightlightBlurRadius);
        roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -hightlightOffset.width, -hightlightOffset.height);
        roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
        
        UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
        [roundedRectangleNegativePath appendPath: roundedRectanglePath];
        roundedRectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = hightlightOffset.width + round(roundedRectangleBorderRect.size.width);
            CGFloat yOffset = hightlightOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        hightlightBlurRadius,
                                        hightlight.CGColor);
            
            [roundedRectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
            [roundedRectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [roundedRectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
    }
    
    
    //// Cleanup
    CGGradientRelease(buttonGradient);
    CGColorSpaceRelease(colorSpace);
    

}

@end
