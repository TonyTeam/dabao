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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/signup-by-cellphone",BASEURL];
    NSDictionary * params  = @{@"cellphone": userPhone,@"sendCaptcha":@"1"};
    [self showHudInView:self.view hint:@"獲取中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        id success = respondDict[@"success"];
        if ([success isEqualToString:@"SUCCESS"]) {
            [self showHint:@"驗證碼已發送，請注意查收"];
            [sender startWithTime:60 title:@"獲取驗證碼" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        }
        else{
            NSDictionary *resultDict = [respondString objectFromJSONString];
            if ([resultDict isKindOfClass:[NSDictionary class]]) {
                NSDictionary *error = resultDict[@"error"];
                if (error) {
                    NSArray *allkey = error.allKeys;
                    NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:0];
                    for (NSInteger index = 0; index < [allkey count]; index++) {
                        NSString *key = allkey[index];
                        NSString *value = error[key];
                        [errorString appendFormat:@"%@",value];
                    }
                    if ([allkey count] == 0) {
                        errorString = [[NSMutableString alloc] initWithString:@"發送驗證碼出錯"];
                    }
                    [self showHint:errorString];
                }
            }
        }
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
    
    
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
    [self cancelInputTap:nil];
    NSString *account = accountField.text;
    NSString *code = codeField.text;
    NSString *password = passwordField.text;
    if ((account == nil || [account isEqualToString:@""])) {
        [self showHint:@"請輸入手機號"];
        return;
    }
    if (![Tool isMobileNumber:account]) {
        [self showHint:@"請輸入正確手機號"];
        return;
    }
    if ((code == nil || [code isEqualToString:@""])) {
        [self showHint:@"請輸入手機驗證碼"];
        return;
    }
    if ((password == nil || [password isEqualToString:@""])) {
        [self showHint:@"請輸入註冊密碼"];
        return;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/signup-by-cellphone",BASEURL];
    
    NSDictionary * params  = @{@"cellphone": account,@"captcha":code,@"password":password,@"password_repeat":password,@"signup_referer":@"iOS ",@"device_id":[Tool getDeviceUUid]};
    [self showHudInView:self.view hint:@"註冊中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        NSString *error = respondDict[@"error"][@"cellphone"];
        if (error) {
            NSDictionary *resultDict = [respondString objectFromJSONString];
            if ([resultDict isKindOfClass:[NSDictionary class]]) {
                NSDictionary *error = resultDict[@"error"];
                if (error) {
                    NSArray *allkey = error.allKeys;
                    NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:0];
                    for (NSInteger index = 0; index < [allkey count]; index++) {
                        NSString *key = allkey[index];
                        NSString *value = error[key];
                        [errorString appendFormat:@"%@",value];
                    }
                    if ([allkey count] == 0) {
                        errorString = [[NSMutableString alloc] initWithString:ERRORREQUESTTIP];
                    }
                    [self showHint:errorString];
                }
            }
            return;
        }
        accountField.text = nil;
        passwordField.text = nil;
        codeField.text = nil;
        [self showHint:@"註冊成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ENROLLSUCCESS_NOTIFICATION object:nil];
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 3) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:textField.text];
        [text replaceCharactersInRange:range withString:string];
        return [text length] <= taiWanPhoneMaxLength;
    }
    return YES;
}

- (void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
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
