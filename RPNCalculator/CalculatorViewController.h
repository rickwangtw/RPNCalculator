//
//  CalculatorViewController.h
//  RPNCalculator
//
//  Created by Rick Wang on 12/8/13.
//  Copyright (c) 2012年 Mystical App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
/*
    we don't need strong for the display should be hold by the main window
    IBOutlet == NOTHING
*/
@property (weak, nonatomic) IBOutlet UILabel *display;

@end
