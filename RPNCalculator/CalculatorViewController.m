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
@property (nonatomic) BOOL skipEnterKey;
@property (nonatomic,strong) CalculatorModel* brain;
- (void) insertCmdToDisplay:(NSString*) cmd;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize cmdDisplay = _cmdDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize skipEnterKey = _skipEnterKey;
@synthesize brain = _brain;

- (void) insertCmdToDisplay:(NSString *)cmd {
    self.cmdDisplay.text = [self.cmdDisplay.text stringByAppendingString:@" "];
    self.cmdDisplay.text = [self.cmdDisplay.text stringByAppendingString: cmd];
}

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
    self.skipEnterKey = NO;
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
    if (!self.skipEnterKey) {
        double value = self.display.text.doubleValue;
        [self.brain pushOperand:value];
        [self insertCmdToDisplay:[NSString stringWithFormat:@"%g", value]];
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(id)sender {
    NSString* operation = [(UIButton*) sender currentTitle];

    /* save an enter */
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    [self insertCmdToDisplay:operation];
    
    double result = [self.brain performOperation:operation];
    if ([operation isEqualToString:@"pi"]) {
        self.skipEnterKey = YES;
    } else {
        self.skipEnterKey = NO;
    }
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    NSLog(@"%g", result);
    self.display.text = resultString;
}
- (IBAction)dotPressed:(UIButton *)sender {
    NSRange range = [self.display.text rangeOfString:@"."];
    
    if (range.length == 0) {
        if (self.userIsInTheMiddleOfEnteringANumber == NO)
            self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)cPressed {
    self.cmdDisplay.text = @"";
    [self.brain resetCalculator];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSString* origStr = self.display.text;
        unsigned length = [origStr length];
        /* contains chars without including the index */
        NSString* newStr = [origStr substringToIndex:length - 1];
        NSLog(@"new string = %@", newStr);
        self.display.text = newStr;
    }
}
@end
