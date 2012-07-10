//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Shitian Long on 6/30/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    VAR_TEST_1=1,
    VAR_TEST_2=2,
    VAR_TEST_NULL=0,
}VAR_VALUE;

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;
@property (weak, nonatomic) IBOutlet UILabel *varDisplay;

@end
