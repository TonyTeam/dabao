//
//  HeLoginVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeLoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKProfile.h>

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
    [self cancelInputTap:nil];
    NSString *account = accountField.text;
    NSString *password = passwordField.text;
    
    if (account == nil || [account isEqualToString:@""]) {
        [self showHint:@"請輸入登錄賬號"];
        return;
    }
    if (password == nil || [password isEqualToString:@""]) {
        [self showHint:@"請輸入登錄密碼"];
        return;
    }
    if (![Tool isMobileNumber:account]) {
        [self showHint:@"請輸入正確手機號"];
        return;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/login",BASEURL];
    NSDictionary * params  = @{@"cellphone": account,@"password" : password,@"rememberMe":@"1"};
    [self showHudInView:self.view hint:@"登錄中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        NSString *user_id = respondDict[@"user_id"];
        NSString *token = respondDict[@"token"];
        if ([user_id isMemberOfClass:[NSNull class]] || user_id == nil) {
            user_id = @"";
        }
        if ([token isMemberOfClass:[NSNull class]] || token == nil) {
            token = @"";
        }
        [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:USERIDKEY];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:USERTOKENKEY];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:USERACCOUNTKEY];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:USERPASSWORDKEY];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
    
}

- (IBAction)faceBookLogin:(id)sender
{
    NSLog(@"faceBookLogin");
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         NSLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             FBSDKProfile *userProfile = [FBSDKProfile currentProfile];
             NSLog(@"userProfile = %@",userProfile);
         }
     }];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 3) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:textField.text];
        [text replaceCharactersInRange:range withString:string];
        return [text length] <= taiWanPhoneMaxLength;
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
