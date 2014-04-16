//
//  FirstViewController.h
//  PaintCode
//
//  Created by Felipe on 5/21/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

@class ButtonView;
@interface ButtonViewController : UIViewController

@property (weak, nonatomic) IBOutlet ButtonView *customButton;

@property (weak, nonatomic) IBOutlet UISlider *redColorSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenColorSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueColorSlider;

@end
