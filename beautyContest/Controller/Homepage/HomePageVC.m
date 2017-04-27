//
//  HomePageVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HomePageVC.h"
#import "HeScanQRCodeVC.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"
#import "HeDCoinStoreVC.h"
#import "HeDCoinDetailVC.h"
#import "Masonry.h"
#import "QRCodeGenerateVC.h"
#import "QRCodeScanningVC.h"

@interface HomePageVC ()
{
    BOOL adjustView;
}
@property(strong,nonatomic)IBOutlet UIButton *scanButton;
@property(strong,nonatomic)IBOutlet UILabel *coinTitleLabel;
@property(strong,nonatomic)IBOutlet UILabel *coinValueLabel;
@property(strong,nonatomic)IBOutlet UILabel *unitLabel;
@property(strong,nonatomic)NSDictionary *userDetailDict;

@end

@implementation HomePageVC
@synthesize scanButton;
@synthesize coinTitleLabel;
@synthesize coinValueLabel;
@synthesize unitLabel;
@synthesize userDetailDict;

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
        label.text = @"首頁";
        [label sizeToFit];
        self.title = @"首頁";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    if (SCREENHEIGH < 600) {
        adjustView = NO;
    }
    else{
//        [self initView];
    }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    adjustView = YES;
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"viewWillLayoutSubviews");
    
    
}

- (void)viewDidLayoutSubviews
{
//    NSLog(@"viewDidLayoutSubviews");
//    if (SCREENHEIGH < 600 && !adjustView) {
//        CGRect buttonFrame = scanButton.frame;
//        buttonFrame.size.width = 200;
//        buttonFrame.size.height = 191;
//        buttonFrame.origin.x = (SCREENWIDTH - buttonFrame.size.width) / 2.0;
//        scanButton.frame = buttonFrame;
//        [self initView];
//    }
    
}

- (void)initializaiton
{
    [super initializaiton];
    adjustView = NO;
    userDetailDict = [[NSDictionary alloc] initWithDictionary:[HeSysbsModel getSysModel].userDetailDict];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataUpdate:) name:USERDATAUPDATE_NOTIFICATION object:nil];
}

- (void)initView
{
    [super initView];
    NSString *titleString = @"掃描功能說明:";
    NSString *first_explaintString = @"將鏡頭對準二維碼";
    NSString *second_explaintString = @"即可完成掃碼付款";
    
    CGFloat maxWidth = SCREENWIDTH / 2.0;
    UIFont *textfont = [UIFont systemFontOfSize:13.0];
    CGSize titlesize = [MLLabel getViewSizeByString:titleString maxWidth:maxWidth font:textfont lineHeight:1.2f lines:0];
    
    CGSize contentsize = [MLLabel getViewSizeByString:first_explaintString maxWidth:maxWidth font:textfont lineHeight:1.2f lines:0];
    
    CGFloat imageiconX = (SCREENWIDTH - titlesize.width - contentsize.width - 10) / 2.0;
    CGFloat imageiconY = CGRectGetMaxY(scanButton.frame) + 20;
    CGFloat imageiconW = 15;
    CGFloat imageiconH = 15;
    
    UIImageView *imageicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_explain"]];
    imageicon.frame = CGRectMake(imageiconX, imageiconY, imageiconW, imageiconH);
    [self.view addSubview:imageicon];
    
    CGFloat titleLabelX = CGRectGetMaxX(imageicon.frame) + 5;
    CGFloat titleLabelY = imageiconY;
    CGFloat titleLabelW = titlesize.width;
    CGFloat titleLabelH = 15;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleString;
    titleLabel.font = textfont;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    CGFloat first_contentLabelX = CGRectGetMaxX(titleLabel.frame) + 5;
    CGFloat first_contentLabelY = imageiconY;
    CGFloat first_contentLabelW = contentsize.width;
    CGFloat first_contentLabelH = 15;
    
    UILabel *first_contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(first_contentLabelX, first_contentLabelY, first_contentLabelW, first_contentLabelH)];
    first_contentLabel.backgroundColor = [UIColor clearColor];
    first_contentLabel.text = first_explaintString;
    first_contentLabel.font = textfont;
    first_contentLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:first_contentLabel];
    
//    [first_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.topMargin.mas_equalTo(CGRectGetMaxY(scanButton.frame) + 20);
//    }];
    
    contentsize = [MLLabel getViewSizeByString:second_explaintString maxWidth:maxWidth font:textfont lineHeight:1.2f lines:0];
    
    CGFloat second_contentLabelX = CGRectGetMinX(first_contentLabel.frame);
    CGFloat second_contentLabelY = CGRectGetMaxY(first_contentLabel.frame) + 2;
    CGFloat second_contentLabelW = contentsize.width;
    CGFloat second_contentLabelH = 15;
    
    UILabel *second_contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(second_contentLabelX, second_contentLabelY, second_contentLabelW, second_contentLabelH)];
    second_contentLabel.backgroundColor = [UIColor clearColor];
    second_contentLabel.text = second_explaintString;
    second_contentLabel.font = textfont;
    second_contentLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:second_contentLabel];
    
//    [second_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.topMargin.mas_equalTo(CGRectGetMaxY(first_contentLabel.frame) + 2);
//    }];
    
    id ingots = userDetailDict[@"ingots"];
    if ([ingots isMemberOfClass:[NSNull class]] || ingots == nil) {
        ingots = @"";
    }
    NSString *coinValue = [NSString stringWithFormat:@"%@",ingots];
    CGSize coinsize = [MLLabel getViewSizeByString:coinValue maxWidth:maxWidth font:[UIFont systemFontOfSize:15.0] lineHeight:1.2 lines:0];
    
    coinValueLabel.text = coinValue;
    CGRect coinFrame = coinValueLabel.frame;
    coinFrame.size.width = coinsize.width;
    coinValueLabel.frame = coinFrame;
    
    coinFrame = unitLabel.frame;
    coinFrame.origin.x = CGRectGetMaxX(coinValueLabel.frame) + 2;
    unitLabel.frame = coinFrame;
    
    
}

- (void)userDataUpdate:(NSNotification *)notification
{
    CGFloat maxWidth = SCREENWIDTH / 2.0;
    
    userDetailDict = [[NSDictionary alloc] initWithDictionary:[HeSysbsModel getSysModel].userDetailDict];
    
    id ingots = userDetailDict[@"ingots"];
    if ([ingots isMemberOfClass:[NSNull class]] || ingots == nil) {
        ingots = @"";
    }
    NSString *coinValue = [NSString stringWithFormat:@"%@",ingots];
    CGSize coinsize = [MLLabel getViewSizeByString:coinValue maxWidth:maxWidth font:[UIFont systemFontOfSize:15.0] lineHeight:1.2 lines:0];
    
    coinValueLabel.text = coinValue;
    CGRect coinFrame = coinValueLabel.frame;
    coinFrame.size.width = coinsize.width;
    coinValueLabel.frame = coinFrame;
    
    coinFrame = unitLabel.frame;
    coinFrame.origin.x = CGRectGetMaxX(coinValueLabel.frame) + 2;
    unitLabel.frame = coinFrame;
}

- (IBAction)scanButtonClick:(id)sender
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QRCodeScanningVC *scanQRCodeVC = [[QRCodeScanningVC alloc] init];
                        scanQRCodeVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:scanQRCodeVC animated:YES];
                    });
                    
                    SGQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    SGQRCodeLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    SGQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"請去-> [設置 - 隱私 - 相機 - 大寶] 打開訪問開關" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"確定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"溫馨提示" message:@"未檢測到您的攝像頭" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"確定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (IBAction)scanCoinDetailButtonClick:(id)sender
{
    HeDCoinDetailVC *coinDetailVC = [[HeDCoinDetailVC alloc] init];
    coinDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coinDetailVC animated:YES];
}

- (IBAction)coinStoreButtonClick:(id)sender
{
    HeDCoinStoreVC *coinStoreVC = [[HeDCoinStoreVC alloc] init];
    coinStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coinStoreVC animated:YES];
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
