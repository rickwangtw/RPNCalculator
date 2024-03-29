//
//  CalculatorModel.m
//  RPNCalculator
//
//  Created by Rick Wang on 12/8/13.
//  Copyright (c) 2012年 Mystical App. All rights reserved.
//

#import "CalculatorModel.h"
#include <math.h>


@interface CalculatorModel()
/* use strong for we are the only one holding it */
@property (nonatomic,strong) NSMutableArray* operandStack;
@end


@implementation CalculatorModel

/* synthesize never allocate variable */
@synthesize operandStack = _operandStack;

/* always use the setter and getter instead of using _operandStack directly */
- (NSMutableArray*)operandStack {
    /* lazy instantiated: initialize when needed */
    if (_operandStack == nil)
        /* another way is to initialize it in the constructor */
        _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}
 
- (void) setOperandStack: (NSMutableArray*) operandStack {
    _operandStack = operandStack;
}

- (void)pushOperand:(double)operand {
    /* wrap the double into an object for addObject */
#if 0
    NSNumber* operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
#else
    /* nothing will happen to nil */
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
#endif

}

- (double) popOperand {
    NSNumber* operandObject = [self.operandStack lastObject];
    /* array index out of bound crash! */
    if (operandObject)
        /* the doubleValue method only peeks! */
        [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString*)operation {
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    /* constant string is also ok! */
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([@"-" isEqualToString:operation]) {
        result = - [self popOperand] + [self popOperand];
    } else if ([@"/" isEqualToString:operation]) {
        double denominator = [self popOperand];
        if (denominator) {
            result = [self popOperand] / denominator;
        } else {
            result = 0;
        }
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        double n = [self popOperand];
        if (n > 0)
            result = sqrt(n);
        else {
            NSLog(@"n = %g cannot be sqrted", n);
            result = n;
        }
    } else if ([operation isEqualToString:@"pi"]) {
        result = M_PI;
    } else if ([operation isEqualToString:@"+/-"]) {
        result = [self popOperand] * -1;
    }
    
    [self pushOperand:result];
    return result;
}

- (void) resetCalculator {
    [self.operandStack removeAllObjects];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"stack = %@", self.operandStack];
}

@end
