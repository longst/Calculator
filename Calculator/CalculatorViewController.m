//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Shitian Long on 6/30/12.
//  Copyright (c) 2012 OptiCaller Software AB. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorLogic.h"

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


@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorLogic *calLogic;

- (void)displayHandlerWithoutEnter:(NSString *)operator;
- (void)cleanDisplay;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize log = _log;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize calLogic = _calLogic;
 

- (CalculatorLogic *)calLogic{
    if (!_calLogic) {
        _calLogic = [[CalculatorLogic alloc] init];
    }
    return _calLogic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDisplay) name:@"RPN_ERROR" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setLog:nil];
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
    self.log.text = [NSString stringWithString:@""];
}


//digit pressed
//tag property is defined as corresponding number
- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digitPressed = [NSString stringWithFormat:@"%d", sender.tag];
    
    // Handle Dot
    if (sender.tag == DIGIT_DOT && [self.display.text rangeOfString:@"."].location == NSNotFound){
        self.userIsInTheMiddleOfEnteringANumber = YES;
        if (self.display.text.length == 0) {
            self.display.text = @"0.";
        }
        else {
            self.display.text = [NSString stringWithFormat:@"%@%@"
                                 ,self.display.text
                                 ,@"."
                                 ];
        }
        
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



// entre is not pressed, during user is entering a number
// Entre logic should be here
- (void)displayHandlerWithoutEnter:(NSString *) operator{
    
    // for two operands operation
    if ([operator isEqualToString:@"+"] 
        || [operator isEqualToString:@"-"] 
        || [operator isEqualToString:@"*"] 
        || [operator isEqualToString:@"/"]){
        
        if (self.userIsInTheMiddleOfEnteringANumber) {
            if (self.log.text.length == 0) {
                self.log.text = [NSString stringWithFormat:@"%@ %@ %@"
                                 , @"0"
                                 , operator
                                 , self.display.text];
            }
            else {
                self.log.text = [NSString stringWithFormat:@"%@ %@ %@"
                                 , self.log.text
                                 , operator
                                 , self.display.text];
            }
            
            self.userIsInTheMiddleOfEnteringANumber = NO;
            //Handle logic
            [self.calLogic pushInStack:self.display.text];
        }
        else {
            if (self.log.text.length == 0) {
                // Nothing happens when there is no operand in display
                return;
            }
            else {
                self.log.text = [NSString stringWithFormat:@"%@ %@"
                                 , self.log.text
                                 , operator
                                 ];
            }
        }
        
    }
    
    // for single operand operation
    else {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.log.text = [NSString stringWithFormat:@"%@ %@"
                             , operator
                             , self.display.text
                             ];
            [self.calLogic pushInStack:self.display.text];
        }
        else {
            self.log.text = [NSString stringWithFormat:@"%@ %@"
                             , operator
                             , self.display.text
                             ];
        }
    }
    
}


- (IBAction)operationPressed:(UIButton *)sender {    
    
    //Handle Display
    switch (sender.tag) {
        case OPER_COS:{
            [self displayHandlerWithoutEnter: @"COS"];
            self.display.text = [self.calLogic performOperationCos];
            break;
        }
            
        case OPER_DIVIDE:{
            [self displayHandlerWithoutEnter: @"/"];
            self.display.text = [self.calLogic performOperationDivide];
            break;
        }
            
        case OPER_E:{
             [self displayHandlerWithoutEnter: @"e"];
            self.display.text = [self.calLogic performOperationE];
            break;
        }
            
        case OPER_LOG:{
            [self displayHandlerWithoutEnter: @"log"];
            self.display.text = [self.calLogic performOperationLog];
            break;
        }
            
        case OPER_MINUS:{
            [self displayHandlerWithoutEnter: @"-"];
            self.display.text = [self.calLogic performOperationMinus];
            break;
        }
            
        case OPER_MUTIPLY:{
            [self displayHandlerWithoutEnter: @"*"];
            self.display.text = [self.calLogic performOperationMutiply];
            break;
        }
            
        case OPER_OPT_SIGN:{
            [self displayHandlerWithoutEnter: @"(+/-)"];
            self.display.text = [self.calLogic performOperationOptSign];
            break;
        }
            
        case OPER_PI:{
            self.display.text = [self.calLogic performOperationPi];
            break;
        }
            
        case OPER_PLUS:{
            [self displayHandlerWithoutEnter: @"+"];
            self.display.text = [self.calLogic performOperationPlus];
            break;
        }
            
        case OPER_SIN:{
            [self displayHandlerWithoutEnter: @"SIN"];
            self.display.text = [self.calLogic performOperationSin];
            break;
        }
            
        case OPER_SQIT:{
            self.display.text = [self.calLogic performOperationSqit];
            break;
        }
            
        default:
            break;
    }
    
    //protect error case like 12/0
    // Handle Log
    if (self.display.text.length == 0) {
        self.log.text = [NSString stringWithString:@""];
        return;
    }
    else {
        self.log.text = [NSString stringWithFormat:@"%@ %@ %@"
                         ,self.log.text
                         ,@"="
                         ,self.display.text];
    }    
    //push result in stack
}


- (IBAction)funcPressed:(UIButton *)sender {
    
    switch (sender.tag) {
        case FUNC_BACKWARD:{
            
            [self.calLogic pushInStack:self.display.text];
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
            self.log.text = [NSString stringWithString:@""];
            
            //Handle logic
            [self.calLogic clearOperand];
            break;
        }
            
        case FUNC_ENTER:{
            //Handle UI
            self.log.text = [NSString stringWithFormat:@"%@ %@ "
                             ,self.log.text
                             ,self.display.text];
            self.userIsInTheMiddleOfEnteringANumber = NO;
            //Handle logic
            [self.calLogic pushInStack:self.display.text];
            break;
        }
                        
        default:
            break;
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
