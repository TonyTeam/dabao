//
//  AppDelegate.m
//  beautyContest
//
//  Created by Tony on 16/7/29.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "HeTabBarVC.h"
#import <UMMobClick/MobClick.h>
#import "HeLoginVC.h"
#import "LoginAndRegisterController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize queue;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initialization];
    [self umengTrack];
    
    //清除缓存
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(clearImg:) object:nil];
    
    [operation setQueuePriority:NSOperationQueuePriorityNormal];
    [operation setCompletionBlock:^{
        //不上传到iCloud
        [Tool canceliClouldBackup];
    }];
    queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    [queue setMaxConcurrentOperationCount:1];
    //配置根控制器
    [self loginStateChange:nil];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)clearImg:(id)sender
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    
    NSString *libraryfolderPath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
    //    libraryfolderPath = [[NSString alloc] initWithFormat:@"libraryfolderPath = %@",libraryfolderPath];
    
    NSString* LibraryfileName = [libraryfolderPath stringByAppendingPathComponent:@"EaseMobLog"];
    childFilesEnumerator = [[manager subpathsAtPath:LibraryfileName] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [LibraryfileName stringByAppendingPathComponent:fileName];
        
        BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
        if (result) {
            NSLog(@"remove EaseMobLog succeed");
        }
        else{
            NSLog(@"remove EaseMobLog faild");
        }
        
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [path objectAtIndex:0];
    childFilesEnumerator = [[manager subpathsAtPath:cachesPath] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [cachesPath stringByAppendingPathComponent:fileName];
        NSRange range = [fileAbsolutePath rangeOfString:@"umeng"];
        
        if (range.length == 0) {
            BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
            if (result) {
                NSLog(@"remove caches succeed");
            }
            else{
                NSLog(@"remove caches faild");
            }
        }
        
    }
}

- (void)initialization
{
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:USERHAVELOGINKEY];
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    if (ISIOS7) {
        [[UINavigationBar appearance] setTintColor:NAVTINTCOLOR];
        UIImage *navBackgroundImage = [UIImage imageNamed:@"NavBarIOS7"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
        [[UINavigationBar appearance] setTitleTextAttributes:attributeDict];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    else{
        [[UINavigationBar appearance] setTintColor:APPDEFAULTORANGE];
        
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
        [[UINavigationBar appearance] setTitleTextAttributes:attributeDict];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

//初始化友盟的SDK
- (void)umengTrack
{
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [MobClick setLogEnabled:YES];
        UMConfigInstance.appKey = UMANALYSISKEY;
        UMConfigInstance.secret = @"secretstringaldfkals";
        //    UMConfigInstance.eSType = E_UM_GAME;
        [MobClick startWithConfigure:UMConfigInstance];
        
        //        [MobClick startWithAppkey:UMANALYSISKEY reportPolicy:(ReportPolicy) SEND_INTERVAL channelId:nil];
    }
    else{
        [MobClick setLogEnabled:YES];
        UMConfigInstance.appKey = UMANALYSISKEY_HD;
        UMConfigInstance.secret = @"secretstringaldfkals";
        //    UMConfigInstance.eSType = E_UM_GAME;
        [MobClick startWithConfigure:UMConfigInstance];
        
        //        [MobClick startWithAppkey:UMANALYSISKEY_HD reportPolicy:(ReportPolicy) SEND_INTERVAL channelId:nil];
    }
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setBackgroundTaskEnabled:YES];
    [MobClick setLogSendInterval:90];//每隔两小时上传一次
    //    [MobClick ];  //在线参数配置
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    BOOL haveLogin = (userAccount == nil) ? NO : YES;
    
    if (haveLogin) {//登陆成功加载主窗口控制器
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:20.0], NSFontAttributeName, nil]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        HeTabBarVC *tabbarVC = [[HeTabBarVC alloc] init];
        self.viewController = tabbarVC;
        
    }
    else{
        LoginAndRegisterController *loginVC = [[LoginAndRegisterController alloc] init];
        CustomNavigationController *loginNav = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
        self.viewController = loginNav;
    }
    self.window.rootViewController = self.viewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
