//
//  HeForGetPasswordVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeForGetPasswordVC.h"
#import "HeBaseTableViewCell.h"
#import "UIButton+countDown.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"

@interface HeForGetPasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)UITextField *accountField;
@property(strong,nonatomic)UITextField *verifyCodeField;
@property(strong,nonatomic)UITextField *passwordField;
@property(strong,nonatomic)UITextField *confirmPasswordField;
@property(strong,nonatomic)UIButton *getCodeButon;

@end

@implementation HeForGetPasswordVC
@synthesize tableview;
@synthesize datasource;
@synthesize accountField;
@synthesize verifyCodeField;
@synthesize passwordField;
@synthesize confirmPasswordField;
@synthesize getCodeButon;

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
        label.text = @"忘記密碼";
        [label sizeToFit];
        self.title = @"忘記密碼";
        
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
    if (_modifyType != 1) {
        self.navigationController.navigationBarHidden = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (_modifyType != 1) {
        self.navigationController.navigationBarHidden = YES;
    }
    
}

- (void)initializaiton
{
    [super initializaiton];
    datasource = @[@"手機號",@"輸入驗證碼",@"密碼",@"確認密碼"];
    if (_modifyType == 1) {
        datasource = @[@"輸入驗證碼",@"密碼",@"確認密碼"];
    }
}

- (void)initView
{
    [super initView];
    
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    if (_modifyType == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = APPDEFAULTTITLETEXTFONT;
        label.textColor = APPDEFAULTTITLECOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"修改密碼";
        [label sizeToFit];
        self.title = @"修改密碼";
    }
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
    tableview.tableFooterView = footerview;
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, SCREENWIDTH - 40, 40)];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.layer.masksToBounds = YES;
    confirmButton.layer.cornerRadius = 8.0;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [confirmButton setTitle:@"確認" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[Tool buttonImageFromColor:[UIColor colorWithRed:254.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] withImageSize:confirmButton.frame.size] forState:UIControlStateNormal];
    [footerview addSubview:confirmButton];
    
    accountField = [[UITextField alloc] init];
    accountField.delegate = self;
    accountField.font = [UIFont systemFontOfSize:15.0];
    accountField.placeholder = @"請輸入賬戶手機號";
    accountField.tag = 3;
    
    verifyCodeField = [[UITextField alloc] init];
    verifyCodeField.delegate = self;
    verifyCodeField.font = [UIFont systemFontOfSize:15.0];
    verifyCodeField.placeholder = @"請輸入驗證碼";
    
    passwordField = [[UITextField alloc] init];
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    passwordField.font = [UIFont systemFontOfSize:15.0];
    passwordField.placeholder = @"請輸入密碼";
    
    confirmPasswordField = [[UITextField alloc] init];
    confirmPasswordField.secureTextEntry = YES;
    confirmPasswordField.delegate = self;
    confirmPasswordField.font = [UIFont systemFontOfSize:15.0];
    confirmPasswordField.placeholder = @"請再次輸入密碼";
    
    getCodeButon = [[UIButton alloc] init];
    getCodeButon.layer.masksToBounds = YES;
    getCodeButon.layer.borderWidth = 1.0;
    getCodeButon.layer.cornerRadius = 6.0;
    getCodeButon.layer.borderColor = [UIColor colorWithRed:255.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0].CGColor;
    [getCodeButon setTitle:@"獲取驗證碼" forState:UIControlStateNormal];
    getCodeButon.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [getCodeButon setTitleColor:[UIColor colorWithRed:255.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    getCodeButon.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [getCodeButon addTarget:self action:@selector(getCodeButonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getCodeButonClick:(UIButton *)sender
{
    NSLog(@"getVerifyCode");
    [self cancelInputTap:nil];
    NSString *userPhone = accountField.text;
    if (_modifyType != 1) {
        
        if ((userPhone == nil || [userPhone isEqualToString:@""])) {
            [self showHint:@"請輸入手機號"];
            return;
        }
        if (![Tool isMobileNumber:userPhone]) {
            [self showHint:@"請輸入正確手機號"];
            return;
        }
    }
    else{
        userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY];
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/send-password-reset-captcha",BASEURL];
    NSDictionary * params  = @{@"cellphone": userPhone};
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
                    return;
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
    if ([verifyCodeField isFirstResponder]) {
        [verifyCodeField resignFirstResponder];
    }
    if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }
    if ([confirmPasswordField isFirstResponder]) {
        [confirmPasswordField resignFirstResponder];
    }
}

- (void)confirmButtonClick:(UIButton *)button
{
    NSLog(@"confirmButtonClick");
    [self cancelInputTap:nil];
    NSString *account = accountField.text;
    NSString *code = verifyCodeField.text;
    NSString *password = passwordField.text;
    NSString *confirmPassword = confirmPasswordField.text;
    
    if (_modifyType != 1) {
        if ((account == nil || [account isEqualToString:@""])) {
            [self showHint:@"請輸入手機號"];
            return;
        }
        if (![Tool isMobileNumber:account]) {
            [self showHint:@"請輸入正確手機號"];
            return;
        }
    }
    
    if ((code == nil || [code isEqualToString:@""])) {
        [self showHint:@"請輸入手機驗證碼"];
        return;
    }
    if ((password == nil || [password isEqualToString:@""])) {
        [self showHint:@"請輸入密碼"];
        return;
    }
    if ((confirmPassword == nil || [confirmPassword isEqualToString:@""])) {
        [self showHint:@"請再次輸入密碼"];
        return;
    }
    if (![password isEqualToString:confirmPassword]) {
        [self showHint:@"兩次輸入密碼不一致"];
        return;
    }
    
    if (_modifyType != 1) {
        [self forgetPassword];
    }
    else{
        [self modifyPassword];
    }
}

//忘記密碼
- (void)forgetPassword
{
    NSString *account = accountField.text;
    NSString *code = verifyCodeField.text;
    NSString *password = passwordField.text;

    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/reset-password",BASEURL];
    
    __weak HeForGetPasswordVC *weakSelf = self;
    NSDictionary * params  = @{@"cellphone": account,@"captcha":code,@"password":password};
    [self showHudInView:self.view hint:@"重置密碼中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        id success = respondDict[@"success"];
        if ([success isEqualToString:@"SUCCESS"]) {
            [weakSelf showHint:@"密碼重置成功,請重新登錄"];
            [weakSelf performSelector:@selector(logoutMethod) withObject:nil afterDelay:0.8];
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
                        errorString = [[NSMutableString alloc] initWithString:@"重置密碼出錯"];
                    }
                    [weakSelf showHint:errorString];
                    return;
                }
            }
        }
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)logoutMethod
{
    NSLog(@"logoutButton");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERACCOUNTKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKENKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERIDKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORDKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDETAILDATAKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
}

//修改密碼
- (void)modifyPassword
{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY];
    if (account == nil) {
        account = @"";
    }
    NSString *code = verifyCodeField.text;
    NSString *password = passwordField.text;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/reset-password",BASEURL];
    
    __weak HeForGetPasswordVC *weakSelf = self;
    
    NSDictionary * params  = @{@"cellphone": account,@"captcha":code,@"password":password};
    [self showHudInView:self.view hint:@"修改密碼中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        id success = respondDict[@"success"];
        if ([success isEqualToString:@"SUCCESS"]) {
            [weakSelf showHint:@"密碼修改成功,請重新登錄"];
            [weakSelf performSelector:@selector(logoutMethod) withObject:nil afterDelay:0.8];
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
                        errorString = [[NSMutableString alloc] initWithString:@"密碼修改出錯"];
                    }
                    [self showHint:errorString];
                    return;
                }
            }
        }
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGSize cellsize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat cellH = cellsize.height;
    
    static NSString *cellIndentifier = @"HeBaseTableViewCell";
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (SCREENWIDTH - 20) / 2.0, cellH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = datasource[row];
    titleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:titleLabel];
    
    CGSize titleszie = [MLLabel getViewSizeByString:datasource[row] maxWidth:(SCREENWIDTH - 20) / 2.0 font:[UIFont systemFontOfSize:15.0] lineHeight:1.2f lines:0];
    
    switch (row) {
        case 0:
        {
            if (_modifyType == 0) {
                accountField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
                [cell addSubview:accountField];
            }
            else{
                getCodeButon.frame = CGRectMake(SCREENWIDTH - 85, (cellH - 20) / 2.0, 70, 20);
                getCodeButon.layer.cornerRadius = 20.0 / 2.0;
                [cell addSubview:getCodeButon];
                
                verifyCodeField.frame = CGRectMake(titleszie.width + 20, 0, (CGRectGetMinX(getCodeButon.frame) - (titleszie.width + 10)), cellH);
                [cell addSubview:verifyCodeField];
            }
            
            break;
        }
        case 1:
        {
            if (_modifyType == 0) {
                getCodeButon.frame = CGRectMake(SCREENWIDTH - 85, (cellH - 20) / 2.0, 70, 20);
                getCodeButon.layer.cornerRadius = 20.0 / 2.0;
                [cell addSubview:getCodeButon];
                
                verifyCodeField.frame = CGRectMake(titleszie.width + 20, 0, (CGRectGetMinX(getCodeButon.frame) - (titleszie.width + 10)), cellH);
                [cell addSubview:verifyCodeField];
            }
            else{
                passwordField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
                [cell addSubview:passwordField];
            }
            break;
        }
        case 2:
        {
            if (_modifyType == 0) {
                passwordField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
                [cell addSubview:passwordField];
            }
            else{
                confirmPasswordField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
                [cell addSubview:confirmPasswordField];
            }
            
            break;
        }
        case 3:
        {
            confirmPasswordField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
            [cell addSubview:confirmPasswordField];
            
            break;
        }
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"section = %ld , row = %ld",section,row);
    
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
