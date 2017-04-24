//
//  HeLoginVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeLoginVC.h"

@interface HeLoginVC ()<UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UIButton *loginButton;
@property(strong,nonatomic)IBOutlet UIButton *faceBookButton;

@property(strong,nonatomic)IBOutlet UIButton *securityButton;
@property(strong,nonatomic)IBOutlet UITextField *accountField;
@property(strong,nonatomic)IBOutlet UITextField *passwordField;

@end

@implementation HeLoginVC
@synthesize loginButton;
@synthesize securityButton;
@synthesize accountField;
@synthesize passwordField;
@synthesize faceBookButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = APPDEFAULTTITLETEXTFONT;
        label.textColor = APPDEFAULTTITLECOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"登錄";
        [label sizeToFit];
        self.title = @"登錄";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initializaiton
{
    [super initializaiton];
    
}

- (void)initView
{
    [super initView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREENWIDTH - 20, 50) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREENWIDTH - 20, 50);
    maskLayer.path = maskPath.CGPath;
    loginButton.layer.mask = maskLayer;
    
    faceBookButton.layer.masksToBounds = YES;
    faceBookButton.layer.cornerRadius = 3.0;
    
    
}

- (void)cancelInputTap:(UIButton *)sender
{
    if ([accountField isFirstResponder]) {
        [accountField resignFirstResponder];
    }
    if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }
}

- (IBAction)loginButtonClick:(id)sender
{
    NSLog(@"loginButtonClick");
    [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:USERACCOUNTKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
}

- (IBAction)faceBookLogin:(id)sender
{
    NSLog(@"faceBookLogin");
}

- (IBAction)securityButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    passwordField.secureTextEntry = !sender.selected;
    NSLog(@"securityButtonClick");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
