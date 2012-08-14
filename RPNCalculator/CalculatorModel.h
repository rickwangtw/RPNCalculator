//
//  CalculatorModel.h
//  RPNCalculator
//
//  Created by Rick Wang on 12/8/13.
//  Copyright (c) 2012年 Mystical App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString*)operation;
- (void)resetCalculator;

@end
