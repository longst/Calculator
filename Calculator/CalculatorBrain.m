//
//  CalculatorLogic.m
//  Calculator
//
//  Created by Shitian Long on 7/1/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong)NSMutableArray *operandStack;

- (double)popOperand;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;


- (NSMutableArray *)operandStack{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}


- (void)pushOperand:(double)vaule{
    [self.operandStack addObject:[NSNumber numberWithDouble:vaule]];
}


- (void)clearBrain{
    [self.operandStack removeAllObjects];
}

- (double)popOperand{
    NSString *valueInString = [self.operandStack lastObject];
    if (valueInString) {
        [self.operandStack removeLastObject];
    }
    return [valueInString doubleValue];
}


- (double)performOperation:(CAL_OPERATOR)op{
    double result = 0.0;
    switch (op) {
        case OPER_COS:{
            result = cos([self popOperand]);
            break;
        }
            
        case OPER_DIVIDE:{
            double divisor = [self popOperand];
            if (divisor == 0) {
                [self clearBrain];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
            }
            else{
                result = [self popOperand] / divisor;
            }
            
            break;
        }
            
        case OPER_E:{
            result = exp([self popOperand]);
            break;
        }
            
        case OPER_LOG:{
            double based = [self popOperand];
            if (based < 0) {
                [self clearBrain];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
            }
            else {
                result = log(based);
            }
            break;
        }
            
        case OPER_MINUS:{
            result = -[self popOperand] + [self popOperand];
            break;
        }
            
        case OPER_MUTIPLY:{
            result = [self popOperand] * [self popOperand];
            break;
        }
            
        case OPER_OPT_SIGN:{
            result = -[self popOperand];
        }
            
        case OPER_PI:{
            result = M_PI;
            break;
        }
            
        case OPER_PLUS:{
            result = [self popOperand] + [self popOperand];
            break;
        }
            
        case OPER_SIN:{
            result = sin([self popOperand]);
            break;
        }
            
        case OPER_SQIT:{
            double based = [self popOperand];
            if (based < 0) {
                [self clearBrain];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RPN_ERROR" object:nil];
            }
            else {
                result = sqrt(based);
            }
            break;
        }
            
        default:
            break;
    }
    
    [self pushOperand:result];
    return result;
}


- (void)updateLastOperand:(NSString *)updatedValue{
    [self.operandStack replaceObjectAtIndex:(self.operandStack.count-1) withObject:updatedValue];
}




@end
