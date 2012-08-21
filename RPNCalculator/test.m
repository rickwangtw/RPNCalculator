#import <Foundation/NSObject.h>
#import <stdio.h>
#import "CalculatorModel.h"

int main(void) {
	NSSet* set = [[NSSet alloc] initWithObjects:@"a", @"z", @"A", @"Z", @"%", @"+", @"g", @"G", nil];
	for (NSString* str in set) {
		BOOL result = [CalculatorModel isStringVariable:str];
		NSLog(@"result of %@ is %i", str, result);
	}

	NSArray* array = [[NSArray alloc] initWithObjects:@1, @2, @"+", @"x", @"*", @3, @"/", @"y", @"-", @"Z", @"+", nil];
//	NSArray* array = [[NSArray alloc] initWithObjects:@1, @2, @"+", @"x", @"/", @3, @"-", nil];
//	NSArray* array = [[NSArray alloc] initWithObjects:@1, @2, @"+", @2  , @"*", @3, @"/", @4  , @"-", @10 , @"+", nil];
//	NSArray* array = [[NSArray alloc] initWithObjects:@3, @2, @"+", nil];
//	NSArray* array = [[NSArray alloc] initWithObjects:@3, @2, @"-", nil];
//	NSArray* array = [[NSArray alloc] initWithObjects:@3, @2, @"*", nil];
//	NSArray* array = [[NSArray alloc] initWithObjects:@3, @2, @"/", nil];
	for (NSString* str in array) {
		NSLog(@"elements in array: %@", str);
	}
	NSSet* myset = [CalculatorModel variablesUsedInProgram:array];
	NSLog(@"variabled used: %@", myset);
	[myset dealloc];
#if 1
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys: @2, @"x",
		@4, @"y",
		@10, @"Z",
		nil];
	double ans = [CalculatorModel runProgram:array usingVariableValues:dic];
#else
	double ans = [CalculatorModel runProgram:array];
#endif
	NSLog(@"result = %g", ans);

	return 0;
}
