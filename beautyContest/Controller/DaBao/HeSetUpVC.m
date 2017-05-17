//
//  HeSetUpVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeSetUpVC.h"
#import <CloudPushSDK/CloudPushSDK.h>

@interface HeSetUpVC ()
@property(strong,nonatomic)IBOutlet UIButton *logoutButton;

@end

@implementation HeSetUpVC
@synthesize logoutButton;

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
        label.text = @"設置";
        [label sizeToFit];
        self.title = @"設置";
        
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
}

- (void)initView
{
    [super initView];
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius = 8.0;
    [logoutButton setBackgroundImage:[Tool buttonImageFromColor:[UIColor colorWithRed:254.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] withImageSize:logoutButton.frame.size] forState:UIControlStateNormal];
}

- (IBAction)logoutButtonClick:(id)sender
{
    NSLog(@"logoutButton");
    //取消绑定账号
    [CloudPushSDK unbindAccount:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERACCOUNTKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKENKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERIDKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORDKEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDETAILDATAKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
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
