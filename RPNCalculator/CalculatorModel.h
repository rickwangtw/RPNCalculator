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
- (void)pushVariable:(NSString*) variable;

/* use id to gain flexibility of this interface */
@property (readonly) id program;

+ (double) runProgram:(id)program;
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary*) variableValues;
+ (NSString*) descriptionOfProgram:(id)program;
+ (BOOL) isStringVariable:(NSString*) str;
+ (NSSet*) variablesUsedInProgram:(id) program;
@end
