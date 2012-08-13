//
//  CalculatorViewController.m
//  RPNCalculator
//
//  Created by Rick Wang on 12/8/13.
//  Copyright (c) 2012年 Mystical App. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorModel.h"

@interface CalculatorViewController ()
    // for private methods, properties
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorModel* brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorModel*) brain {
    if (_brain == nil)
        _brain = [[CalculatorModel alloc]init];
    return _brain;
}

/*
    IBAction == void
    id: pointer to any class of object
    copy and paste -> linkage for digitPressed
 */
- (IBAction)digitPressed:(id)sender {
    /* copied to digit */
    NSString* digit = [ (UIButton*)sender currentTitle ];
    /* 
        send digit to the console for debug
        constant NSString: '@"OOXX"'
        %s == char*
        %@ == send object description, and will be NSString
     */
    NSLog(@"digit pressed = %@", digit);
#if 0 /* complicated version */
    UILabel* myDisplay = [ self display ];
    /* UILabel* myDisplay = self.display; */
    NSString* currentText = [myDisplay text];
    /* NSString* currentText = myDisplay.text; */
    /* NSString* currentText = self.display.text; */
    NSString* newText = [currentText stringByAppendingString:digit];
    [myDisplay setText:newText];
    /* myDisplay.text = newText; */
#else
    /* currentTitle is copy? */
    if (self.userIsInTheMiddleOfEnteringANumber) {
        /*
        self.display.text = [self.display.text stringByAppendingString:[(UIButton*)sender currentTitle]];
         */
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
 //       self.display.text = [(UIButton*)sender currentTitle];
        self.display.text = digit;
//        self.display.text = ((UIButton*)sender).currentTitle;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
#endif
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(id)sender {
    /* save an enter */
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    double result = [self.brain performOperation:((UIButton*)sender).currentTitle];
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    NSLog(@"%g", result);
    self.display.text = resultString;
}
- (IBAction)dotPressed:(UIButton *)sender {
    NSRange range = [self.display.text rangeOfString:@"."];
    
    if (range.length == 0) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

@end
