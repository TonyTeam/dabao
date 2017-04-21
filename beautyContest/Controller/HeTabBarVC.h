//
//  HeTabBarVC.h
//  huayoutong
//
//  Created by HeDongMing on 16/3/2.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "HeBaseViewController.h"
#import "RDVTabBarController.h"
#import "HomePageVC.h"
#import "HeOrderVC.h"
#import "HeUserVC.h"
#import "HeFeedBackVC.h"
#import "HeOrderRecordVC.h"

@interface HeTabBarVC : RDVTabBarController<UIAlertViewDelegate>
@property(strong,nonatomic)HomePageVC *homepageVC;
@property(strong,nonatomic)HeOrderRecordVC *orderVC;
@property(strong,nonatomic)HeUserVC *userVC;
@property(strong,nonatomic)HeFeedBackVC *feedbackVC;

@end
