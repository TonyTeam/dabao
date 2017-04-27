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
    [self getUserInfo];
    [self autoLogin];
    [self setupSubviews];
}

//后台自动登录
- (void)autoLogin
{
    
}

- (void)clearInfo
{
    
}

//获取用户的信息
- (void)getUserInfo
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/view",BASEURL];
    NSDictionary * params  = nil;
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:respondString forKey:USERDETAILDATAKEY];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        [HeSysbsModel getSysModel].userDetailDict = [[NSDictionary alloc] initWithDictionary:respondDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:USERDATAUPDATE_NOTIFICATION object:nil];
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
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
