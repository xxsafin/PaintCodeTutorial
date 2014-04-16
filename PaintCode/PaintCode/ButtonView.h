//
//  ButtonView.h
//  PaintCode
//
//  Created by Xu Xian on 14-4-16.
//  Copyright (c) 2014年 Felipe Laso Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIButton

- (id)initWithFrame:(CGRect)frame red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;

@end
