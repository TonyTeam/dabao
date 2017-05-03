//
//  HeUserVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeUserVC.h"
#import "HeBaseTableViewCell.h"
#import "HeBankCardVC.h"
#import "HeNoticeVC.h"
#import "HeSecurityVC.h"
#import "HeAboutUsVC.h"
#import "HeSetUpVC.h"
#import "HeDCoinStoreVC.h"
#import "HeDCoinDetailVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKProfile.h>
#import "AppDelegate.h"

#define ALERTTAG 200

@interface HeUserVC ()<UITableViewDelegate,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)NSArray *icon_datasource;
@property(strong,nonatomic)IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)IBOutlet UILabel *nickLabel;
@property(strong,nonatomic)IBOutlet UIImageView *userImage;
@property(strong,nonatomic)IBOutlet UIView *bgView;
@property(strong,nonatomic)IBOutlet UIButton *facebookButton;
@property(strong,nonatomic)NSDictionary *userDetailDict;

@property(strong,nonatomic)IBOutlet UILabel *dcoinLabel;
@property(strong,nonatomic)IBOutlet UILabel *bankCardNumLabel;

@property(strong,nonatomic)UIView *dismissView;

@end

@implementation HeUserVC
@synthesize tableview;
@synthesize datasource;
@synthesize icon_datasource;
@synthesize nameLabel;
@synthesize nickLabel;
@synthesize userImage;
@synthesize bgView;
@synthesize facebookButton;
@synthesize userDetailDict;
@synthesize dcoinLabel;
@synthesize bankCardNumLabel;
@synthesize dismissView;

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
        label.text = @"我的大寶";
        [label sizeToFit];
        self.title = @"我的大寶";
        
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
    self.navigationController.navigationBarHidden = NO;
}

- (void)initializaiton
{
    [super initializaiton];
    datasource = @[@[@"消息通知",@"賬戶安全",@"關於大寶"],@[@"設置"]];
    icon_datasource = @[@[@"icon_notice",@"icon_security",@"icon_about"],@[@"icon_setup"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataUpdate:) name:USERDATAUPDATE_NOTIFICATION object:nil];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.frame.size.width / 2.0;
    
    facebookButton.layer.masksToBounds = YES;
    facebookButton.layer.cornerRadius = 3.0;
    
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    
    userDetailDict = [[NSDictionary alloc] initWithDictionary:[HeSysbsModel getSysModel].userDetailDict];
    
    id ingots = userDetailDict[@"ingots"];
    if ([ingots isMemberOfClass:[NSNull class]] || ingots == nil) {
        ingots = @"";
    }
    dcoinLabel.text = [NSString stringWithFormat:@"￥%@",ingots];
    NSInteger bankCarNum = [userDetailDict[@"bankAccountsQty"] integerValue];
    bankCardNumLabel.text = [NSString stringWithFormat:@"%ld張銀行卡記錄",bankCarNum];
    
    NSString *name = userDetailDict[@"name"];
    if ([name isMemberOfClass:[NSNull class]] || name == nil || [name isEqualToString:@""]) {
        name = @"您未設置名字，請點擊設置";
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserName:)];
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired = 1;
        nickLabel.userInteractionEnabled = YES;
        [nickLabel addGestureRecognizer:tapGes];
    }
    else{
        nickLabel.userInteractionEnabled = NO;
    }
    nickLabel.text = name;
    
    id fb_userinfo = userDetailDict[@"fb_userinfo"];
    if ([fb_userinfo isMemberOfClass:[NSNull class]]) {
        fb_userinfo = [[NSDictionary alloc] init];
    }
    NSString *fb_name = fb_userinfo[@"name"];
    if ([fb_name isMemberOfClass:[NSNull class]] || fb_name == nil || [fb_name isEqualToString:@""]) {
        fb_name = userDetailDict[@"cellphone"];
        if ([fb_name isMemberOfClass:[NSNull class]]) {
            fb_name = @"";
        }
    }
    nameLabel.text = fb_name;
    
    NSString *fb_avatar = fb_userinfo[@"avatar"];
    if ([fb_avatar isMemberOfClass:[NSNull class]] || fb_avatar == nil) {
        fb_avatar = @"";
    }
    [userImage sd_setImageWithURL:[NSURL URLWithString:fb_avatar] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height)];
    dismissView.backgroundColor = [UIColor blackColor];
    dismissView.hidden = YES;
    dismissView.alpha = 0.7;
    [self.view addSubview:dismissView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewGes:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [dismissView addGestureRecognizer:tapGes];
    
    NSString *fb_id = userDetailDict[@"fb_id"];
    if ([fb_id isMemberOfClass:[NSNull class]]) {
        fb_id = @"";
        facebookButton.hidden = NO;
    }
    else{
        facebookButton.hidden = YES;
    }
}

//添加用戶名字
- (void)updateUserName:(UITapGestureRecognizer *)ges
{
    [self.view addSubview:dismissView];
    dismissView.hidden = NO;
    
    CGFloat viewX = 10;
    CGFloat viewY = 80;
    CGFloat viewW = SCREENWIDTH - 2 * viewX;
    CGFloat viewH = 200;
    UIView *shareAlert = [[UIView alloc] init];
    shareAlert.frame = CGRectMake(viewX, viewY, viewW, viewH);
    shareAlert.backgroundColor = [UIColor whiteColor];
    shareAlert.layer.cornerRadius = 5.0;
    shareAlert.layer.borderWidth = 0;
    shareAlert.layer.masksToBounds = YES;
    shareAlert.tag = ALERTTAG;
    shareAlert.layer.borderColor = [UIColor clearColor].CGColor;
    shareAlert.userInteractionEnabled = YES;
    
    CGFloat labelH = 30;
    CGFloat labelY = 0;
    
    UIFont *shareFont = [UIFont systemFontOfSize:15.0];
    
    UILabel *messageTitleLabel = [[UILabel alloc] init];
    messageTitleLabel.font = shareFont;
    messageTitleLabel.textColor = [UIColor blackColor];
    messageTitleLabel.textAlignment = NSTextAlignmentCenter;
    messageTitleLabel.backgroundColor = [UIColor clearColor];
    messageTitleLabel.text = @"請輸入名字";
    messageTitleLabel.frame = CGRectMake(0, 0, viewW, labelH);
    [shareAlert addSubview:messageTitleLabel];
    
    labelY = labelY + labelH;
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:17.0];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = @"注意!!!姓名添加后不能修改";
    contentLabel.frame = CGRectMake(0, labelY, viewW, labelH);
    [shareAlert addSubview:contentLabel];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logoImage"]];
    logoImage.frame = CGRectMake(20, 5, 30, 30);
    [shareAlert addSubview:logoImage];
    
    
    labelY = labelY + labelH + 10;
    UITextField *textview = [[UITextField alloc] init];
    textview.tag = 10;
    textview.backgroundColor = [UIColor whiteColor];
    textview.tintColor= [UIColor blueColor];
    textview.placeholder = @"請輸入您的名字";
    textview.font = shareFont;
    textview.delegate = self;
    textview.frame = CGRectMake(10, labelY, shareAlert.frame.size.width - 20, 50);
    textview.layer.borderWidth = 1.0;
    textview.layer.cornerRadius = 5.0;
    textview.layer.masksToBounds = YES;
    textview.layer.borderColor = [UIColor colorWithWhite:0xcc / 255.0 alpha:1.0].CGColor;
    [shareAlert addSubview:textview];
    
    
    CGFloat buttonDis = 10;
    CGFloat buttonW = (viewW - 3 * buttonDis) / 2.0;
    CGFloat buttonH = 50;
    CGFloat buttonY = viewH - 50;
    CGFloat buttonX = 10;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [shareButton setTitle:@"確認" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(alertbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag = 1;
    [shareButton.titleLabel setFont:shareFont];
    [shareButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    [shareAlert addSubview:shareButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX + buttonDis + buttonW, buttonY, buttonW, buttonH)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(alertbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 0;
    [cancelButton.titleLabel setFont:shareFont];
    [cancelButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    [shareAlert addSubview:cancelButton];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewH - 50, viewW, 1)];
    sepLine.backgroundColor = [UIColor colorWithWhite:230.0 / 255.0 alpha:1.0];
    [shareAlert addSubview:sepLine];
    
    UIView *sepLine1 = [[UIView alloc] initWithFrame:CGRectMake((viewW - 1) / 2.0, viewH - 50, 1, 50)];
    sepLine1.backgroundColor = [UIColor colorWithWhite:230.0 / 255.0 alpha:1.0];
    [shareAlert addSubview:sepLine1];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [shareAlert.layer addAnimation:popAnimation forKey:nil];
    [self.view addSubview:shareAlert];
}

- (void)alertbuttonClick:(UIButton *)button
{
    UIView *mydismissView = dismissView;
    mydismissView.hidden = YES;
    
    UIView *alertview = [self.view viewWithTag:ALERTTAG];
    
    UIView *subview = [alertview viewWithTag:10];
    if (button.tag == 0) {
        [alertview removeFromSuperview];
        return;
    }
    UITextField *textview = nil;
    if ([subview isMemberOfClass:[UITextField class]]) {
        textview = (UITextField *)subview;
    }
    textview.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    NSString *password = textview.text;
    [alertview removeFromSuperview];
    if (password == nil || [password isEqualToString:@""]) {
        
        [self showHint:@"請輸入您的名字"];
        return;
    }
    [self requestUpdateUserNameWithName:password];
}

- (void)requestUpdateUserNameWithName:(NSString *)name
{
    [self showHudInView:tableview hint:@"添加中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/update-name",BASEURL];
    
    NSString *myuserName = [NSString stringWithFormat:@"%@",name];
    NSDictionary *params  = @{@"name":myuserName};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [respondString objectFromJSONString];
        NSString *error = resultDict[@"error"][@"name"];
        if (error) {
            [self showHint:error];
            return;
        }
        nickLabel.text = name;
        nickLabel.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:GETUSERDATA_NOTIFICATION object:nickLabel];
        [self showHint:@"添加成功"];
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (IBAction)relateFackBook:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *appWindow = appDelegate.window;
    UILabel *tipLabel = [appWindow viewWithTag:shortNoticeLabelTag];
    tipLabel.hidden = YES;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
    
    __weak HeUserVC *weakSelf = self;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         NSLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
         
         tipLabel.hidden = NO;
         
         if (error) {
             [self showHint:@"FaceBook登錄失敗"];
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             FBSDKProfile *userProfile = [FBSDKProfile currentProfile];
             [weakSelf faceBookRelateWithToken:result.token.tokenString];
             NSLog(@"userProfile = %@",userProfile);
             
             
         }
     }];
    
    
    
}

- (void)faceBookRelateWithToken:(NSString *)accessToken
{
    NSLog(@"relateFackBook");
    NSString *faceBookAccessToken = [NSString stringWithFormat:@"%@",accessToken];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/connect-facebook",BASEURL];
    NSDictionary * params  = @{@"fb_access_token": faceBookAccessToken};
    [self showHudInView:self.tableview hint:@"關聯中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        
        id success = respondDict[@"success"];
        if ([success isEqualToString:@"SUCCESS"]) {
            [self showHint:@"關聯成功"];
            facebookButton.hidden = YES;
            //更新當前用戶的資料
            [[NSNotificationCenter defaultCenter] postNotificationName:GETUSERDATA_NOTIFICATION object:nil];
        }
        else{
            [self showHint:@"關聯出錯"];
        }
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)userDataUpdate:(NSNotification *)notification
{
    userDetailDict = [[NSDictionary alloc] initWithDictionary:[HeSysbsModel getSysModel].userDetailDict];
    
    id ingots = userDetailDict[@"ingots"];
    if ([ingots isMemberOfClass:[NSNull class]] || ingots == nil) {
        ingots = @"";
    }
    
    NSArray *bankAccounts = userDetailDict[@"bankAccounts"];
    if ([bankAccounts isMemberOfClass:[NSNull class]]) {
        bankAccounts = [NSArray array];
    }
    bankCardNumLabel.text = [NSString stringWithFormat:@"%ld張銀行卡記錄",[bankAccounts count]];
    
    NSString *name = userDetailDict[@"name"];
    if ([name isMemberOfClass:[NSNull class]] || name == nil || [name isEqualToString:@""]) {
        name = @"您未設置名字，請點擊設置";
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserName:)];
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired = 1;
        nickLabel.userInteractionEnabled = YES;
        [nickLabel addGestureRecognizer:tapGes];
    }
    else{
        nickLabel.userInteractionEnabled = NO;
    }
    nickLabel.text = name;
    
    id fb_userinfo = userDetailDict[@"fb_userinfo"];
    if ([fb_userinfo isMemberOfClass:[NSNull class]]) {
        fb_userinfo = [[NSDictionary alloc] init];
    }
    NSString *fb_name = fb_userinfo[@"name"];
    if ([fb_name isMemberOfClass:[NSNull class]] || fb_name == nil || [fb_name isEqualToString:@""]) {
        fb_name = userDetailDict[@"cellphone"];
        if ([fb_name isMemberOfClass:[NSNull class]]) {
            fb_name = @"";
        }
    }
    nameLabel.text = fb_name;
    
    NSString *fb_avatar = fb_userinfo[@"avatar"];
    if ([fb_avatar isMemberOfClass:[NSNull class]] || fb_avatar == nil) {
        fb_avatar = @"";
    }
    [userImage sd_setImageWithURL:[NSURL URLWithString:fb_avatar] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    
    NSString *fb_id = userDetailDict[@"fb_id"];
    if ([fb_id isMemberOfClass:[NSNull class]]) {
        fb_id = @"";
        facebookButton.hidden = NO;
    }
    else{
        facebookButton.hidden = YES;
    }
}

//D幣儲值
- (IBAction)storeDCointDetail:(id)sender
{
    HeDCoinStoreVC *coinStoreVC = [[HeDCoinStoreVC alloc] init];
    coinStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coinStoreVC animated:YES];
}
//瀏覽儲值記錄
- (IBAction)scanStoreDCointDetail:(id)sender
{
    HeDCoinDetailVC *coinDetailVC = [[HeDCoinDetailVC alloc] init];
    coinDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coinDetailVC animated:YES];
}
//查看銀行卡
- (IBAction)scanBankCard:(id)sender
{
    HeBankCardVC *bankCardVC = [[HeBankCardVC alloc] init];
    bankCardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bankCardVC animated:YES];
}


- (void)dismissViewGes:(UITapGestureRecognizer *)ges
{
    UIView *mydismissView = ges.view;
    mydismissView.hidden = YES;
    UIView *alertview = [self.view viewWithTag:ALERTTAG];
    [alertview removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datasource count];
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
    
    CGFloat iconImageX = 10;
    CGFloat iconImageY = 15;
    CGFloat iconImageH = cellH - 2 * iconImageY;
    CGFloat iconImageW = iconImageH;
    
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon_datasource[section][row]]];
    iconImage.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    [cell addSubview:iconImage];
    
    CGFloat titleLabelX = CGRectGetMaxX(iconImage.frame) + 8;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = SCREENWIDTH - 10 - titleLabelX;
    CGFloat titleLabelH = cellH;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:titleLabel];
    titleLabel.text = datasource[section][row];
    
    UIImageView *icon_gray_choose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gray_choose"]];
    icon_gray_choose.contentMode = UIViewContentModeScaleAspectFit;
    icon_gray_choose.layer.masksToBounds = YES;
    icon_gray_choose.frame = CGRectMake(SCREENWIDTH - 30, (cellH - 20) / 2.0, 20, 20);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryView = icon_gray_choose;
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];

    
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"section = %ld , row = %ld",section,row);
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    HeNoticeVC *noticeVC = [[HeNoticeVC alloc] init];
                    noticeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:noticeVC animated:YES];
                    break;
                }
                case 1:
                {
                    HeSecurityVC *securityVC = [[HeSecurityVC alloc] init];
                    securityVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:securityVC animated:YES];
                    break;
                }
                case 2:
                {
                    HeAboutUsVC *aboutVC = [[HeAboutUsVC alloc] init];
                    aboutVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (row) {
                case 0:
                {
                    HeSetUpVC *setupVC = [[HeSetUpVC alloc] init];
                    setupVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setupVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERDATAUPDATE_NOTIFICATION object:nil];
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
