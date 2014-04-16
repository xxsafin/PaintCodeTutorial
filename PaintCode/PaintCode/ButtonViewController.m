//
//  FirstViewController.m
//  PaintCode
//
//  Created by Felipe on 5/21/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "ButtonViewController.h"

#import "ButtonView.h"

@implementation ButtonViewController
{
    UIAlertView *_colorAlert;
}

-(void)viewDidLoad
{
//    _customButton
    self.redColorSlider.value = self.customButton.red;
    self.greenColorSlider.value = self.customButton.green;
    self.blueColorSlider.value = self.customButton.blue;
}

- (IBAction)colorValueChanged:(id)sender {
    if(sender == _redColorSlider)
    {
        _customButton.red = _redColorSlider.value;
    }
    else if (sender == _greenColorSlider)
    {
        _customButton.green = _greenColorSlider.value;
    }
    else if (sender == _blueColorSlider)
    {
        _customButton.blue = _blueColorSlider.value;
    }
    
    [_customButton setNeedsDisplay];
}

- (IBAction)tapButton:(id)sender {
    
    if(!_colorAlert)
    {
        _colorAlert = [[UIAlertView alloc] initWithTitle:@"RGB colors "
                                                 message:@"some message"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    }
    
    _colorAlert.message = [NSString stringWithFormat:@"R : %f\nG : %f\nB : %f\n",
                           _redColorSlider.value,
                           _greenColorSlider.value,
                           _blueColorSlider.value];
    
    [_colorAlert show];
    
}

@end
