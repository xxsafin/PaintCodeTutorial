//
//  BezierView.h
//  PaintCode
//
//  Created by Xu Xian on 14-4-16.
//  Copyright (c) 2014年 Felipe Laso Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BezierViewReleaseHandler)(CGPoint releasePoint);

@interface BezierView : UIView

@property (copy, nonatomic) BezierViewReleaseHandler releaseHandler;

-(id)initWithLeftArrowTipPoint:(CGPoint)leftArrowTip
            rightArrowTipPoint:(CGPoint)rightArrowTip
                releaseHandler:(BezierViewReleaseHandler)releaseHandler;

@end
