//
//  CalculatorModel.m
//  RPNCalculator
//
//  Created by Rick Wang on 12/8/13.
//  Copyright (c) 2012年 Mystical App. All rights reserved.
//

#import "CalculatorModel.h"


@interface CalculatorModel()
/* use strong for we are the only one holding it */
@property (nonatomic,strong) NSMutableArray* programStack;
@end


@implementation CalculatorModel

/* synthesize never allocate variable */
@synthesize programStack = _programStack;

/* always use the setter and getter instead of using _operandStack directly */
- (NSMutableArray*)programStack {
    /* lazy instantiated: initialize when needed */
    if (_programStack == nil)
        /* another way is to initialize it in the constructor */
        _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
 
- (void) setProgramStack: (NSMutableArray*) programStack {
    _programStack = programStack;
}

- (void)pushOperand:(double)operand {
    /* wrap the double into an object for addObject */
#if 0
    NSNumber* operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
#else
    /* nothing will happen to nil */
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
#endif

}

- (double)performOperation:(NSString*)operation {
    [self.programStack addObject:operation];
    return [CalculatorModel runProgram:self.program];
}

- (id) program {
    /* read-only snapshot for security */
    return [self.programStack copy];
}

+ (NSString*) descriptionOfProgram:(id)program {
    return @"Implement this in Assignment 2";
}

+ (double) popOperandOffStack:(NSMutableArray*) stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack)
        [stack removeLastObject];
    
    /* check if program survives when stack is nil or other classes */
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString* operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
            /* constant string is also ok! */
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"-" isEqualToString:operation]) {
            result = - [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"/" isEqualToString:operation]) {
            double denominator = [self popOperandOffStack:stack];
            if (denominator) {
                result = [self popOperandOffStack:stack] / denominator;
            } else {
                result = 0;
            }
        }
    }
    return result;
}

+ (double) runProgram:(id)program {
    /* introspection for id to prevent crash */
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    /* fewer line is simpler and better, don't handle nil */
    return [self popOperandOffStack:stack];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"stack = %@", self.programStack];
}

@end
