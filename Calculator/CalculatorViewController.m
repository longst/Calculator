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

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *calLogic;

- (void)displayHandlerWithoutEnter:(NSString *)operator;
- (void)cleanDisplay;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize inputDisplay = _log;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize calLogic = _calLogic;
 

- (CalculatorBrain *)calLogic{
    if (!_calLogic) {
        _calLogic = [[CalculatorBrain alloc] init];
    }
    return _calLogic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDisplay) name:@"RPN_ERROR" object:nil];
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setInputDisplay:nil];
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
    self.inputDisplay.text = [NSString stringWithString:@""];
}


//digit pressed
//tag property is defined as corresponding number
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digitPressed = [NSString stringWithFormat:@"%d", sender.tag];
    
    // Handle Dot
    if (sender.tag == DIGIT_DOT && [self.display.text rangeOfString:@"."].location == NSNotFound){
        
    }
    
    // Handle Number
    else if(sender.tag >= 0 && sender.tag <= 9){
        if (!self.userIsInTheMiddleOfEnteringANumber) {
            self.userIsInTheMiddleOfEnteringANumber = YES;
            self.display.text = digitPressed;
        }
        else{
           self.display.text = [self.display.text stringByAppendingString:digitPressed]; 
        }
        
    }

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



- (IBAction)operationPressed:(UIButton *)sender {    
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.calLogic performOperation:sender.tag];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    self.inputDisplay.text = [NSString stringWithFormat:@"%@ %@"
                              , self.inputDisplay.text
                              , [self.calLogic getOperator:sender.tag]
                              ];
    // Handle Log
    if (self.display.text.length == 0) {
        self.inputDisplay.text = [NSString stringWithString:@""];
        return;
    }
    else {
        self.inputDisplay.text = [NSString stringWithFormat:@"%@ %@ %@"
                         ,self.inputDisplay.text
                         ,@"="
                         ,self.display.text];
    }    
    //push result in stack
}


- (IBAction)enterPressed{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    // if display end with ".", "." should be removed  
    if ([self.display.text hasSuffix:@"."]) {
        self.display.text = [self.display.text substringToIndex:([self.display.text length] - 1)];
    }
    
    //Handle UI
    self.inputDisplay.text = [NSString stringWithFormat:@"%@ %@ "
                              ,self.inputDisplay.text
                              ,self.display.text];
    
    //Handle logic
    [self.calLogic pushOperand:[self.display.text doubleValue]];
}


- (IBAction)funcPressed:(UIButton *)sender {
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    switch (sender.tag) {
        case FUNC_BACKWARD:{
            
            [self.calLogic pushOperand:[self.display.text doubleValue]];
            //Handle UI
            if ([self.display.text length] > 0){
                self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
            }
            
            //Handle logic
            [self.calLogic updateLastOperand: self.display.text];
            break;
        }
            
        case FUNC_CLEAR:{
            //Handl UI
            self.display.text = [NSString stringWithString:@""];
            self.inputDisplay.text = [NSString stringWithString:@""];
            
            //Handle logic
            [self.calLogic clearBrain];
            break;
        }          
        default:
            break;
    }
    
}



@end
