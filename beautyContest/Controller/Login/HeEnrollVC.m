//
//  HeEnrollVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeEnrollVC.h"
#import "UIButton+countDown.h"

@interface HeEnrollVC ()<UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UIButton *enrollButton;
@property(strong,nonatomic)IBOutlet UIButton *getCodeButton;
@property(strong,nonatomic)IBOutlet UITextField *accountField;
@property(strong,nonatomic)IBOutlet UITextField *codeField;
@property(strong,nonatomic)IBOutlet UITextField *passwordField;

@end

@implementation HeEnrollVC
@synthesize enrollButton;
@synthesize getCodeButton;
@synthesize accountField;
@synthesize codeField;
@synthesize passwordField;

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
        label.text = @"註冊";
        [label sizeToFit];
        self.title = @"註冊";
        
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
    enrollButton.layer.mask = maskLayer;
    
    getCodeButton.layer.masksToBounds = YES;
    getCodeButton.layer.cornerRadius = 5.0;
    getCodeButton.layer.borderWidth = 1.0;
    getCodeButton.layer.borderColor = [UIColor colorWithRed:252.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0].CGColor;
    
}

- (IBAction)getVerifyCode:(id)sender
{
    NSLog(@"getVerifyCode");
    [self cancelInputTap:nil];
    NSString *userPhone = accountField.text;
    if ((userPhone == nil || [userPhone isEqualToString:@""])) {
        [self showHint:@"請輸入手機號"];
        return;
    }
    if (![Tool isMobileNumber:userPhone]) {
        [self showHint:@"請輸入正確手機號"];
        return;
    }
    
    [sender startWithTime:60 title:@"獲取驗證碼" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
}

//取消输入
- (void)cancelInputTap:(UIButton *)sender
{
    if ([accountField isFirstResponder]) {
        [accountField resignFirstResponder];
    }
    if ([codeField isFirstResponder]) {
        [codeField resignFirstResponder];
    }
    if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }
}

- (IBAction)enrollButtonClick:(id)sender
{
    NSLog(@"enrollButtonClick");
}

- (IBAction)scanDaBaoProtocol:(id)sender
{
    NSLog(@"scanDaBaoProtocol");
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
