//
//  HeForGetPasswordVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeModifyPayPasswordVC.h"
#import "HeBaseTableViewCell.h"
#import "UIButton+countDown.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"

@interface HeModifyPayPasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)UITextField *verifyCodeField;
@property(strong,nonatomic)UITextField *passwordField;
@property(strong,nonatomic)UITextField *confirmPasswordField;
@property(strong,nonatomic)UIButton *getCodeButon;

@end

@implementation HeModifyPayPasswordVC
@synthesize tableview;
@synthesize datasource;
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
        label.text = @"修改支付密碼";
        [label sizeToFit];
        self.title = @"修改支付密碼";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
}


- (void)initializaiton
{
    [super initializaiton];
    datasource = @[@"輸入驗證碼",@"密碼",@"確認密碼"];
    
}

- (void)initView
{
    [super initView];
    
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    
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
    
   
    
    verifyCodeField = [[UITextField alloc] init];
    verifyCodeField.delegate = self;
    verifyCodeField.font = [UIFont systemFontOfSize:15.0];
    verifyCodeField.placeholder = @"請輸入驗證碼";
    
    passwordField = [[UITextField alloc] init];
    passwordField.delegate = self;
    passwordField.font = [UIFont systemFontOfSize:15.0];
    passwordField.placeholder = @"請輸入密碼";
    
    confirmPasswordField = [[UITextField alloc] init];
    confirmPasswordField.delegate = self;
    confirmPasswordField.font = [UIFont systemFontOfSize:15.0];
    confirmPasswordField.placeholder = @"請輸入密碼";
    
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
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/send-pay-pwd-captcha",BASEURL];
    [self showHudInView:self.view hint:@"獲取中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:nil success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        id success = respondDict[@"success"];
        if ([success isEqualToString:@"SUCCESS"]) {
            [self showHint:@"驗證碼已發送，請注意查收"];
            [sender startWithTime:60 title:@"獲取驗證碼" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        }
        else{
            [self showHint:@"發送驗證碼出錯"];
        }
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

//取消输入
- (void)cancelInputTap:(UIButton *)sender
{
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
    NSString *verifyCode = verifyCodeField.text;
    NSString *password = passwordField.text;
    NSString *confirmPassword = confirmPasswordField.text;
    if (verifyCode == nil || [verifyCode isEqualToString:@""]) {
        [self showHint:@"請輸入驗證碼"];
        return;
    }
    if (password == nil || [password isEqualToString:@""]) {
        [self showHint:@"請輸入支付密碼"];
        return;
    }
    if (confirmPassword == nil || [confirmPassword isEqualToString:@""]) {
        [self showHint:@"請再次輸入支付密碼"];
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/set-pay-pwd",BASEURL];
    
    NSDictionary * params  = @{@"captcha":verifyCode,@"password":password};
    [self showHudInView:self.view hint:@"支付密碼设置中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        id success = respondDict[@"success"];
        if ([success isEqualToString:@"SUCCESS"]) {
            [self showHint:@"支付密碼设置成功"];
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:0.3];
        }
        else{
            [self showHint:@"支付密碼设置出錯"];
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
            getCodeButon.frame = CGRectMake(SCREENWIDTH - 85, (cellH - 20) / 2.0, 70, 20);
            getCodeButon.layer.cornerRadius = 20.0 / 2.0;
            [cell addSubview:getCodeButon];
            
            verifyCodeField.frame = CGRectMake(titleszie.width + 20, 0, (CGRectGetMinX(getCodeButon.frame) - (titleszie.width + 10)), cellH);
            [cell addSubview:verifyCodeField];
            
            break;
        }
        case 1:
        {
            passwordField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
            [cell addSubview:passwordField];
            
            break;
        }
        case 2:
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
