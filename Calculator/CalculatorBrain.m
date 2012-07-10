//
//  CalculatorLogic.m
//  Calculator
//
//  Created by Shitian Long on 7/1/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;

+ (BOOL)isOperation:(NSString *)operation;
+ (BOOL)isFunction:(NSString *)inString;


@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;


- (id)program{
    return [self.programStack copy];
}


- (NSMutableArray *)programStack{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}


- (void)pushOperand:(double)vaule{
    [self.programStack addObject:[NSNumber numberWithDouble:vaule]];
}




- (void)clearBrain{
    [self.programStack removeAllObjects];
}




+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    
    NSMutableArray *stack;
    NSMutableArray *newStack = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    for (id stackItem in stack)
    {
        if ([stackItem isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)stackItem;
            if (![self isOperation:string] && ![self isFunction:string])
            {
                if ([variableValues objectForKey:stackItem])
                {
                    [newStack addObject:(NSNumber *)[variableValues objectForKey:stackItem]];
                } else {
                    [newStack addObject:[NSNumber numberWithInt:0]];
                }
            } else {
                [newStack addObject:stackItem];
            }
        } else {
            [newStack addObject:stackItem];
        }
    }
    
    return [self popOperandOfStack:newStack];
    
}

+ (BOOL) isFunction:(NSString *)inString
{
    if ([inString isEqualToString:@"sin"] || [inString isEqualToString:@"cos"] || [inString isEqualToString:@"sqrt"])
    {
        return YES;
    }
    
    return NO;
}


+ (NSString *)descriptionOfProgram:(id)program{
    NSMutableArray *infixExpression = [[NSMutableArray alloc] init];
    
    for (NSObject *stackItem in program)
    {
        if ([stackItem isKindOfClass:[NSNumber class]])
        {
            [infixExpression addObject:stackItem];
        } else if ([stackItem isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)stackItem;
            if ([self isOperation:string]) {
                id operand1 = [infixExpression lastObject];
                if (operand1) [infixExpression removeLastObject];
                id operand2 = [infixExpression lastObject];
                if (operand2) [infixExpression removeLastObject];
                id nextItem = [infixExpression lastObject];
                if (nextItem)
                {
                    [infixExpression addObject:[NSString stringWithFormat:@"(%@ %@ %@)", operand2, string, operand1]];
                    
                } else {
                    [infixExpression addObject:[NSString stringWithFormat:@"%@ %@ %@", operand2, string, operand1]];
                }
            } else if ([self isFunction:string]) {
                id operand1 = [infixExpression lastObject];
                if (operand1) [infixExpression removeLastObject];
                [infixExpression addObject:[NSString stringWithFormat:@"%@(%@)", string, operand1]];
            } else {
                [infixExpression addObject:stackItem];
            }
        }
    }
    
    return [infixExpression componentsJoinedByString:@", "];
}


+ (double)runProgram:(id)program{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOfStack:stack];
    
}



+ (double)popOperandOfStack:(NSMutableArray*) stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOfStack:stack] * M_PI / 180);
        }
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOfStack:stack];
            if (divisor == 0) {
                //[self clearBrain];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
            }
            else{
                result = [self popOperandOfStack:stack] / divisor;
            }
        }
        
        else if ([operation isEqualToString:@"e"]) {
            result = exp([self popOperandOfStack:stack]);
        }
        
        else if ([operation isEqualToString:@"log"]) {
            double based = [self popOperandOfStack:stack];
            if (based < 0) {
                //[self clearBrain];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
            }
            else {
                result = log(based);
            }
        }
        
        else if ([operation isEqualToString:@"-"]) {
            result = -[self popOperandOfStack:stack] + [self popOperandOfStack:stack];
        }
        
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOfStack:stack] * [self popOperandOfStack:stack];
        }
        
        else if ([operation isEqualToString:@"+/-"]) {
            result = -[self popOperandOfStack:stack];
        }
        
        else if ([operation isEqualToString:@"pi"]) {
            result = M_PI;
        }
        
        else if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOfStack:stack] + [self popOperandOfStack:stack];
        }
        
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOfStack:stack] * M_PI / 180);
        }
        
        else if ([operation isEqualToString:@"sqit"]) {
            double based = [self popOperandOfStack:stack];
            if (based < 0) {
                //[self clearBrain];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
            }
            else {
                result = sqrt(based);
            }
        }
        
    }
    
    return result;
}

- (double)performOperation:(CAL_OPERATOR)op{    
    [self.programStack addObject:[self getOperator:op]];
    
    return [[self class] runProgram:self.program];
}




- (NSString *)getOperator:(CAL_OPERATOR)op{
    NSDictionary *operatorDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"cos", [NSNumber numberWithInt:OPER_COS],
                                 @"/", [NSNumber numberWithInt:OPER_DIVIDE],
                                 @"e", [NSNumber numberWithInt:OPER_E],
                                 @"log", [NSNumber numberWithInt:OPER_LOG],
                                 @"-", [NSNumber numberWithInt:OPER_MINUS],
                                 @"*", [NSNumber numberWithInt:OPER_MUTIPLY],
                                 @"+/-", [NSNumber numberWithInt:OPER_OPT_SIGN],
                                 @"pi", [NSNumber numberWithInt:OPER_PI],
                                 @"+", [NSNumber numberWithInt:OPER_PLUS],
                                 @"sin", [NSNumber numberWithInt:OPER_SIN],
                                 @"sqit",[NSNumber numberWithInt:OPER_SQIT],
                                 nil];
    
    NSString *operator = [operatorDic objectForKey:[NSNumber numberWithInt:op]];
    
    return operator;
}



+ (BOOL) isOperation:(NSString *)inString
{
    if ([inString isEqualToString:@"+"] || [inString isEqualToString:@"-"] || [inString isEqualToString:@"*"] || [inString isEqualToString:@"/"])
    {
        return YES;
    }
    
    return NO;
}


+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSArray *stack = (NSArray *)program;
    NSMutableSet *v = [[NSMutableSet alloc] init];
    for (id stackItem in stack)
    {
        if ([stackItem isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)stackItem;
            if (![self isOperation:string] && ![self isFunction:string])
            {
                [v addObject:string];
            }
        }
    }
    if ([v count] == 0)
    {
        return nil;
    } else {
        return [v copy];
    }
}

- (void)removeLastItem
{
    if ([self.programStack count] > 0)
    {
        [self.programStack removeLastObject];
    }
}



@end
