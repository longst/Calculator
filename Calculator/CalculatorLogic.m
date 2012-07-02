//
//  CalculatorLogic.m
//  Calculator
//
//  Created by Shitian Long on 7/1/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import "CalculatorLogic.h"
#include <math.h>

@interface CalculatorLogic()
@property (nonatomic, strong)NSMutableArray *operandStack;

- (double)popOperand;

@end

@implementation CalculatorLogic

@synthesize operandStack = _operandStack;


- (NSMutableArray *)operandStack{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}



- (void)pushInStack:(NSString *)vaule{
    if (self.operandStack.count >= 2) {
        [self clearOperand];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
    }
    else{
        [self.operandStack addObject:vaule];
    }
}



- (void)updateLastOperand:(NSString *)updatedValue{
    [self.operandStack replaceObjectAtIndex:(self.operandStack.count-1) withObject:updatedValue];
}


- (void)clearOperand{
    [self.operandStack removeAllObjects];
}

- (double)popOperand{
    NSString *valueInString = [self.operandStack lastObject];
    if (valueInString) {
        [self.operandStack removeLastObject];
    }
    return [valueInString doubleValue];
}


- (NSString *)performOperationCos{
    double a = [self popOperand];
    double performResult = cos(a);
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationDivide{
    double a = [self popOperand];
    double b = [self popOperand];
    NSString *resultInString;
    if (a == 0) {
        [self clearOperand];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
    }
    else{
        double performResult =  b / a;
        resultInString = [NSString stringWithFormat:@"%g", performResult];
        [self pushInStack:resultInString];
    }

    return resultInString;
}


- (NSString *)performOperationE{
    double a = [self popOperand];
    double performResult = exp(a);
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationLog{
    double a = [self popOperand];
    NSString *resultInString;
    if (a < 0) {
        [self clearOperand];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
    }
    else {
        double performResult = log(a);
        resultInString = [NSString stringWithFormat:@"%g", performResult];
        [self pushInStack:resultInString];
        
    }
    return resultInString;
}


- (NSString *)performOperationMinus{
    double a = [self popOperand];
    double b = [self popOperand];
    double performResult = b - a;
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationMutiply{
    double a = [self popOperand];
    double b = [self popOperand];
    double performResult = a * b;
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationOptSign{
    double a = [self popOperand];
    double performResult = 0 - a;
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationPi{
    NSString *resultInString = [NSString stringWithFormat:@"%g", M_PI];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationPlus{
    double a = [self popOperand];
    double b = [self popOperand];
    double performResult = a + b;
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationSin{
    double a = [self popOperand];
    double performResult = sin(a);
    NSString *resultInString = [NSString stringWithFormat:@"%g", performResult];
    [self pushInStack:resultInString];
    return resultInString;
}


- (NSString *)performOperationSqit{
    double a = [self popOperand];
    NSString *resultInString;
    if (a < 0) {
        [self clearOperand];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
    }
    else {
        double performResult = sqrt(a);
        resultInString = [NSString stringWithFormat:@"%g", performResult];
        [self pushInStack:resultInString];
    }
    
    return resultInString;
}




@end
