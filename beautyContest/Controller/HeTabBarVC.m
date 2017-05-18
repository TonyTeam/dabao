//
//  HeTabBarVC.m
//  huayoutong
//
//  Created by HeDongMing on 16/3/2.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "HeTabBarVC.h"
#import "RDVTabBarItem.h"
#import "RDVTabBar.h"
#import "RDVTabBarController.h"
#import "HeSysbsModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "RDVTabBarItem.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "HeOrderVC.h"
#import "HeNoticeDetailVC.h"
#import "HeFeedBackReplyVC.h"

@interface HeTabBarVC ()

@end

@implementation HeTabBarVC
@synthesize homepageVC;
@synthesize orderVC;
@synthesize userVC;
@synthesize feedbackVC;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initialization];
    [self updateUserData:nil];
    [self getUserInfo];
//    [self autoLogin];
    [self setupSubviews];
    //獲取最近10條回復
    [self loadRely];
    NSString *bindId = [[HeSysbsModel getSysModel].userDetailDict objectForKey:@"id"];
    if ([bindId isMemberOfClass:[NSNull class]] || bindId == nil) {
        bindId = @"";
    }
    [CloudPushSDK bindAccount:bindId withCallback:^(CloudPushCallbackResult *res){
        NSLog(@"res = %@",res);
    }];
}

- (void)initialization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:GETUSERDATA_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserData:) name:USERDATAUPDATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbsupdateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRely) name:UPDATEUSERREPLYNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:DABAO_PUSHNOTIFICATION object:nil];
    
}

//处理推送通知的跳转
- (void)handleNotification:(NSNotification *)notification
{
    NSString *json = notification.object[@"json"];
    
    NSDictionary *dict = [json objectFromJSONString];
    id selectObj = dict[@"selectIndex"];
    if (selectObj) {
        NSInteger selectIndex = [dict[@"selectIndex"] integerValue];
        if (selectIndex >= 0 && selectIndex < 4) {
            self.selectedIndex = selectIndex;
            CustomNavigationController *nav = (CustomNavigationController *)self.selectedViewController;
            [nav popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    id Extras = [[NSDictionary alloc] initWithDictionary:dict];
    if (!Extras) {
        return;
    }
    NSString *pushvc = Extras[@"pushvc"];
    if ([pushvc isEqualToString:@"HeOrderVC"]) {
        NSString *biz = Extras[@"biz"];
        if ([biz isMemberOfClass:[NSNull class]]) {
            biz = @"";
        }
        //ingot 元宝储值
        //qrpay 扫码支付
        NSInteger orderType = 0;
        if ([biz isEqualToString:@"qrpay"]) {
            orderType = 0;
        }
        else{
            orderType = 1;
        }
        
        NSString *oid = [NSString stringWithFormat:@"%@",Extras[@"oid"]];
        HeOrderVC *myorderVC = [[HeOrderVC alloc] init];
        myorderVC.orderType = orderType;
        myorderVC.orderDetailDict = @{@"oid":oid};
        CustomNavigationController *nav = (CustomNavigationController *)self.selectedViewController;
        [nav pushViewController:myorderVC animated:YES];
    }
    else if ([pushvc isEqualToString:@"HeNoticeDetailVC"]){
        NSString *post_id = [NSString stringWithFormat:@"%@",Extras[@"comment_id"]];
        HeNoticeDetailVC *noticeVC = [[HeNoticeDetailVC alloc] init];
        noticeVC.noticeDict = @{@"post_id":post_id};
        CustomNavigationController *nav = (CustomNavigationController *)self.selectedViewController;
        [nav pushViewController:noticeVC animated:YES];
    }
    else if ([pushvc isEqualToString:@"HeFeedBackReplyVC"]){
        HeFeedBackReplyVC *noticeVC = [[HeFeedBackReplyVC alloc] init];
        noticeVC.comment_id = [NSString stringWithFormat:@"%@",Extras[@"comment_id"]];
        CustomNavigationController *nav = (CustomNavigationController *)self.selectedViewController;
        [nav pushViewController:noticeVC animated:YES];
    }
    else{
        id myObj = [[NSClassFromString(pushvc) alloc] init];
        if (!myObj) {
            return;
        }
        UIViewController *myVC = nil;
        if ([myObj isKindOfClass:[UIViewController class]]) {
            myVC = (UIViewController *)myObj;
        }
        myVC.hidesBottomBarWhenPushed = YES;
        CustomNavigationController *nav = (CustomNavigationController *)self.selectedViewController;
        [nav pushViewController:myVC animated:YES];
    }
    
}

- (void)updateUserData:(NSNotification *)notification
{
    NSDictionary *userDetailDict = [[NSDictionary alloc] initWithDictionary:[HeSysbsModel getSysModel].userDetailDict];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *appWindow = appDelegate.window;
    NSString *shortNotice = userDetailDict[@"shortNotice"];
    UILabel *tipLabel = [appWindow viewWithTag:shortNoticeLabelTag];
    if (!tipLabel) {
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 21)];
        tipLabel.tag = shortNoticeLabelTag;
        tipLabel.backgroundColor = DEFAULTREDCOLOR;
        tipLabel.text = shortNotice;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:12.0];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNotice:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        tipLabel.userInteractionEnabled = YES;
        
        appWindow.userInteractionEnabled = YES;
        [tipLabel addGestureRecognizer:ges];
    }
    
    if ([shortNotice isMemberOfClass:[NSNull class]] || shortNotice == nil) {
        shortNotice = @"";
        tipLabel.hidden = YES;
        return;
    }
    CustomNavigationController *nav = (CustomNavigationController *)self.selectedViewController;
    if ([nav.viewControllers count] > 1) {
        tipLabel.hidden = YES;
    }
    else{
        tipLabel.hidden = NO;
    }
    
    [appWindow addSubview:tipLabel];
}

- (void)showNotice:(UITapGestureRecognizer *)ges
{
    NSDictionary *userDetailDict = [[NSDictionary alloc] initWithDictionary:[HeSysbsModel getSysModel].userDetailDict];
    NSString *shortNotice = userDetailDict[@"shortNotice"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"緊急通知" message:shortNotice delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)fbsupdateContent:(NSNotification *)notification
{
    NSLog(@"notification = %@",notification);
}
//后台自动登录
- (void)autoLogin
{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY];
    if (!account) {
        account = @"";
    }
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORDKEY];
    if (!password) {
        password = @"";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/login",BASEURL];
    NSDictionary * params  = @{@"cellphone": account,@"password" : password,@"rememberMe":@"1"};
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
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)loadRely
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/comment/index",BASEURL];
    NSDictionary * params  = nil;
    __weak HeTabBarVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSArray *replyArray = [respondString objectFromJSONString];
        if ([replyArray isKindOfClass:[NSArray class]] && [replyArray count] > 0) {
            NSDictionary *lastestDict = replyArray[0];
            id hasNewReplyObj = lastestDict[@"hasNewReply"];
            if ([hasNewReplyObj isMemberOfClass:[NSNull class]] || hasNewReplyObj == nil) {
                hasNewReplyObj = nil;
            }
            BOOL hasNewReply = [hasNewReplyObj boolValue];
            if (hasNewReply) {
                //如果有新的回复
                
                [feedbackVC haveReplyWithDict:lastestDict];
            }
            else{
                NSLog(@"暂未有新回复");
                feedbackVC.rdv_tabBarItem.badgeValue = nil;
            }
        }
        else{
            NSLog(@"暂未有新回复");
            feedbackVC.rdv_tabBarItem.badgeValue = nil;
        }
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
    }];
}

- (void)clearInfo
{
    
}

//获取用户的信息
- (void)getUserInfo
{
    __weak HeTabBarVC *weakSelf = self;
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/view",BASEURL];
    NSDictionary * params  = nil;
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:respondString forKey:USERDETAILDATAKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        id unreadAnncsQtyObj = respondDict[@"unreadAnncsQty"];
        NSInteger unreadAnncsQty = [unreadAnncsQtyObj integerValue];
        if (unreadAnncsQty > 0) {
            //有未读的消息
            [userVC haveUnReadMessage:unreadAnncsQty];
        }
        [HeSysbsModel getSysModel].userDetailDict = [[NSDictionary alloc] initWithDictionary:respondDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:USERDATAUPDATE_NOTIFICATION object:nil];
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
    }];
}

//设置根控制器的四个子控制器
- (void)setupSubviews
{
    homepageVC = [[HomePageVC alloc] init];
    CustomNavigationController *homePageNav = [[CustomNavigationController alloc] initWithRootViewController:homepageVC];
    
    orderVC = [[HeOrderRecordVC alloc] init];
    CustomNavigationController *orderNav = [[CustomNavigationController alloc]
                                            initWithRootViewController:orderVC];
    
    userVC = [[HeUserVC alloc] init];
    CustomNavigationController *userNav = [[CustomNavigationController alloc]
                                            initWithRootViewController:userVC];
    
    feedbackVC = [[HeFeedBackVC alloc] init];
    CustomNavigationController *feedbackNav = [[CustomNavigationController alloc]
                                           initWithRootViewController:feedbackVC];
    
    [self setViewControllers:@[homePageNav,orderNav,userNav,feedbackNav]];
    [self customizeTabBarForController];
}

//设置底部的tabbar
- (void)customizeTabBarForController{
    //    tabbar_normal_background   tabbar_selected_background
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages =  @[@"main_home", @"main_order", @"main_user", @"main_feedback"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_active",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        //后台自动登录失败，退出登录
        [self clearInfo];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GETUSERDATA_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERDATAUPDATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATEUSERREPLYNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DABAO_PUSHNOTIFICATION object:nil];
    
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
