//
//  CalculatorLogic.h
//  Calculator
//
//  Created by Shitian Long on 7/1/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OPER_PLUS=1,
    OPER_MINUS,
    OPER_MUTIPLY,
    OPER_DIVIDE,
    OPER_LOG,
    OPER_SQIT,
    OPER_COS,
    OPER_SIN,
    OPER_PI,
    OPER_E,
    OPER_OPT_SIGN,
}CAL_OPERATOR;

typedef enum{
    FUNC_BACKWARD=1,
    FUNC_CLEAR,
    FUNC_ENTER,
}CAL_FUNC;

typedef enum{
    DIGIT_DOT = 10
}CAL_DIGIT;

@interface CalculatorBrain : NSObject


@property (readonly) id program;

- (void)pushOperand:(double)vaule;
- (void)pushVariable:(NSString *)variable;

- (void)clearBrain;

- (double)performOperation:(CAL_OPERATOR)op;

- (NSString *)getOperator:(CAL_OPERATOR)op;
- (void)removeLastItem;


+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

// run program without variable
+ (double)runProgram:(id)program;


+ (NSString *)descriptionOfProgram:(id)program;


+ (NSSet *)variablesUsedInProgram:(id)program;




@end
