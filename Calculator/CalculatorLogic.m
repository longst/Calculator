//
//  CalculatorLogic.m
//  Calculator
//
//  Created by Shitian Long on 7/1/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//
// Again, unsure why you did not use his ioriginal code...
#import "CalculatorLogic.h"
#include <math.h>   // Not really needed. All the necessary fucntions are part of foundation, in your .h include

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


// No. Where is pushOperand?
// In reality, this should be a double you push down, and...
// [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
// Again, see what he did

- (void)pushInStack:(NSString *)vaule{
    if (self.operandStack.count >= 2) {
        [self clearOperand];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
    }
    else{
        [self.operandStack addObject:vaule];
    }
}


// This assignment does not support replacing stuff on stack. You are not allowing for a true RPN calculator
- (void)updateLastOperand:(NSString *)updatedValue{
    [self.operandStack replaceObjectAtIndex:(self.operandStack.count-1) withObject:updatedValue];
}

// Right idea, but wrong name - you are clearing the entire brain, not just an operand
- (void)clearOperand{
    [self.operandStack removeAllObjects];
}

- (double)popOperand{
    // This requires everything to be strings. Numbers can be stores as NSNumbers, and operations as strings, see his code
    NSString *valueInString = [self.operandStack lastObject];
    if (valueInString) {
        [self.operandStack removeLastObject];
    }
    return [valueInString doubleValue];
}

// WAY overkill. The entire performOperation method I have, with comments, is < 30 lines. You have over 6 times as many
// poor form
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
