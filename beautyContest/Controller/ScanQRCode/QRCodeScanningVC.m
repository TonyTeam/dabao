//
//  QRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "ScanSuccessJumpVC.h"
#import "HeQRCodePayVC.h"

@interface QRCodeScanningVC ()

@end

@implementation QRCodeScanningVC
@synthesize qrcodeDelegate;

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
        label.text = @"掃碼";
        [label sizeToFit];
        self.title = @"掃碼";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;

    ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
    jumpVC.jump_URL = string;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    SGQRCodeLog(@"noti - - %@", noti);
    NSString *string = noti.object;
    
    if ([string hasPrefix:@"http"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            HeQRCodePayVC *qrCodePayVC = [[HeQRCodePayVC alloc] init];
//            qrCodePayVC.qrCode = [[NSString alloc] initWithString:string];
//            qrCodePayVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController popViewControllerAnimated:YES];
            [qrcodeDelegate scanQRCodeWithString:string];
        });
//        [self qrCodeCreateWithQRCode:string];
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.hidesBottomBarWhenPushed = YES;
//        jumpVC.jump_URL = string;
//        [self.navigationController pushViewController:jumpVC animated:YES];
        
    } else { // 扫描结果为条形码
        [self showHint:@"该二维码非支付二维码"];
        return;
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.hidesBottomBarWhenPushed = YES;
        jumpVC.jump_bar_code = string;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}



- (void)dealloc {
    SGQRCodeLog(@"QRCodeScanningVC - dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
}

@end
