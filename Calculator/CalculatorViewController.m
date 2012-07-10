//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Shitian Long on 6/30/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userHasEnteredAVariable;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *calculatorBrain;
@property (nonatomic, strong) NSMutableDictionary *variables;


- (void)cleanDisplay;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize varDisplay = _varDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredAVariable = _userHasEnteredAVariable;
@synthesize calculatorBrain = _calculatorBrain;
@synthesize variables = _variables;

- (CalculatorBrain *)calculatorBrain{
    if (!_calculatorBrain) {
        _calculatorBrain = [[CalculatorBrain alloc] init];
    }
    return _calculatorBrain;
}

- (NSDictionary *)variables
{
    if (!_variables) _variables = [[NSMutableDictionary alloc] init];
    return _variables;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDisplay) name:@"RPN_ERROR" object:nil];
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setHistoryDisplay:nil];
    [self setVarDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


// If user put more than two operands in stack, RPM calculator does not support, prompt error
// or minus number with sqrt
// divided by zero
- (void)cleanDisplay{
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"There is an error occur" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [error show];
    self.display.text = [NSString stringWithString:@""];
    self.historyDisplay.text = [NSString stringWithString:@""];
}


//digit pressed
//tag property is defined as corresponding number
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digitPressed = [NSString stringWithFormat:@"%d", sender.tag];
    
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = digitPressed;
    }
    else{
        self.display.text = [self.display.text stringByAppendingString:digitPressed]; 
    }

}

- (IBAction)variablesPressed:(UIButton *)sender {
    self.userHasEnteredAVariable = YES;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    [self.calculatorBrain pushVariable:sender.currentTitle];
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
}

- (IBAction)dicimalPressd {
    // dicimal in front of number
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    // no dicimal found in current string
    else if([self.display.text rangeOfString:@"."].location == NSNotFound){
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}


// initial var values  
- (IBAction)initVar:(UIButton *)sender {
    double test_1_x = 1.1;
    double test_1_y = 2.2;
    double test_2_x = 3.3;
    double test_2_y = 4.4;
    
    NSDictionary *varDic;
    
    switch (sender.tag) {
        case VAR_TEST_1:{
            [self updateVarDisplay:test_1_x Y:test_1_y];
            varDic = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"x", [NSNumber numberWithDouble:test_1_x],
                      @"y", [NSNumber numberWithDouble:test_1_y],
                      nil];
            break;
        }
            
        case VAR_TEST_2:{
            [self updateVarDisplay:test_2_x Y:test_2_y];
            varDic = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"x", [NSNumber numberWithDouble:test_2_x],
                      @"y", [NSNumber numberWithDouble:test_2_y],
                      nil];
            break;
        }
            
        case VAR_TEST_NULL:{
            [self updateVarDisplay:0.0 Y:0.0];
            varDic = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"x", [NSNumber numberWithDouble:0.0],
                      @"y", [NSNumber numberWithDouble:0.0],
                      nil];
            break;
        }
            
            
        default:
            break;
    }
    
    for (id key in self.variables)
    {
        NSString *var = [NSString stringWithFormat:@" %@=%@", key, [self.variables objectForKey:key]];
        self.varDisplay.text = [self.varDisplay.text stringByAppendingString:var];
    }
    
    
}


- (void)updateVarDisplay:(double)var_x Y:(double)var_y{
    NSString *varDisplayContent = [NSString stringWithFormat: @"X = %g , Y = %g"
                                   ,var_x
                                   ,var_y];
    self.varDisplay.text = varDisplayContent;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    CAL_OPERATOR cal_oper = sender.tag;
    
    if (cal_oper != OPER_PI && cal_oper != OPER_OPT_SIGN && self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    } else if (cal_oper == OPER_OPT_SIGN && self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [NSString stringWithFormat:@"%g", [self.display.text doubleValue] * -1];
        return;
    }
    if (self.userHasEnteredAVariable)
    {
        [self.calculatorBrain pushVariable:sender.currentTitle];
        self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.calculatorBrain.program usingVariableValues:self.variables.copy]];
    } else {
        self.display.text = [NSString stringWithFormat:@"%g", [self.calculatorBrain performOperation:cal_oper]];
    }
    
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}


- (IBAction)enterPressed{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    // if display end with ".", "." should be removed  
    if ([self.display.text hasSuffix:@"."]) {
        self.display.text = [self.display.text substringToIndex:([self.display.text length] - 1)];
    }
    
    //Handle UI
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
    
    //Handle Display
    [self.calculatorBrain pushOperand:[self.display.text doubleValue]];
}


- (IBAction)funcPressed:(UIButton *)sender {
    
   
    
    switch (sender.tag) {
        case FUNC_BACKWARD:{
            if (self.userIsInTheMiddleOfEnteringANumber)
            {
                self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
                if (self.display.text.length == 0)
                {
                    self.display.text = @"0";
                    self.userIsInTheMiddleOfEnteringANumber = NO;
                }
            } else {
                [self.calculatorBrain removeLastItem];
                self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
                if (self.userHasEnteredAVariable)
                {
                    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.calculatorBrain.program usingVariableValues:self.variables.copy]];
                } else {
                    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.calculatorBrain.program]];
                }
            }
            
            break;
        }
            
        case FUNC_CLEAR:{
             self.userIsInTheMiddleOfEnteringANumber = NO;
            
            //Handl UI
            self.display.text = @"";
            self.historyDisplay.text = @"";
            self.varDisplay.text = @"";
            
            //Handle logic
            [self.calculatorBrain clearBrain];
            break;
        }          
        default:
            break;
    }
    
}



@end
