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
@property (nonatomic,strong) NSMutableArray* programStack;
@end


@implementation CalculatorModel

/* synthesize never allocate variable */
@synthesize programStack = _programStack;

+ (BOOL) isStringVariable:(NSString*) str {
    if ([str length] != 1)
        return NO;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]"                                                                   options:NSRegularExpressionCaseInsensitive                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:str                          options:0                                                          range:NSMakeRange(0, [str length])];
    if (numberOfMatches > 0)
        return YES;
    return NO;
}

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

- (void) pushVariable:(NSString *)variable {
    if ([CalculatorModel isStringVariable:variable]) {
        [self.programStack addObject:variable];
    }
    
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
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double n = [self popOperandOffStack:stack];
            if (n > 0)
                result = sqrt(n);
            else {
                NSLog(@"n = %g cannot be sqrted", n);
                result = n;
            }
        } else if ([operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffStack:stack] * -1;
        }

    }
    return result;
}

- (void) resetCalculator {
    [self.programStack removeAllObjects];
}

+ (double) runProgram:(id)program {
#if 0
    /* introspection for id to prevent crash */
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    /* fewer line is [simpler and better, don't handle nil */
    return [self popOperandOffStack:stack];
#else
    return [self runProgram:program usingVariableValues:nil];
#endif
}

+ (double) runProgram:(id)program usingVariableValues:(NSDictionary*) variableValues {
    /* introspection for id to prevent crash */
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    for (int i = 0 ; i < [stack count]; ++i) {
        id obj = [stack objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]] && [CalculatorModel isStringVariable:obj]) {
            NSNumber* num = @0;
            if ([[variableValues allKeys] containsObject:obj]) {
                num = [variableValues objectForKey:obj];
            }
            [stack removeObjectAtIndex:i];
            [stack insertObject:num atIndex:i];
        }
    }
    stack = [stack mutableCopy];
    return [self popOperandOffStack:stack];
}

+ (NSSet*) variablesUsedInProgram:(id) program {
    NSMutableSet* set;
    if ([program isKindOfClass:[NSArray class]]) {
        NSArray* array = (NSArray*) program;
        for (id obj in array) {
            if ([obj isKindOfClass:[NSString class]] && [ self isStringVariable:obj]) {
                if (set == nil) {
                    set = [[NSMutableSet alloc] initWithObjects:obj, nil];
                } else {
                    [set addObject:obj];
                }
            }
        }
    }
    return [set copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"stack = %@", self.programStack];
}

@end
