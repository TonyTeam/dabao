//
//  HeOrderVC.h
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"

@interface HeOrderVC : HeBaseViewController
@property(strong,nonatomic)NSDictionary *orderDetailDict;
@property(assign,nonatomic)NSInteger orderType;  //0:扫码 1:D币
@property(assign,nonatomic)BOOL popToRoot;

@end
