//
//  CalculatorLogic.h
//  Calculator
//
//  Created by Shitian Long on 7/1/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorLogic : NSObject

- (NSString *)performOperationCos;
- (NSString *)performOperationDivide;
- (NSString *)performOperationE;
- (NSString *)performOperationLog;
- (NSString *)performOperationMinus;
- (NSString *)performOperationMutiply;
- (NSString *)performOperationOptSign;
- (NSString *)performOperationPi;
- (NSString *)performOperationPlus;
- (NSString *)performOperationSin;
- (NSString *)performOperationSqit;

- (void)updateLastOperand:(NSString *)updatedValue;
- (void)clearOperand;
- (void)pushInStack:(NSString *)vaule;

@end
