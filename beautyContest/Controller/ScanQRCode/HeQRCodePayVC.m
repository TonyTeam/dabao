//
//  HeQRCodePayVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/30.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeQRCodePayVC.h"
#import "HeDCoinStoreVC.h"
#import "HeOrderVC.h"
#import "HeModifyPayPasswordVC.h"

#define ALERTTAG 200

@interface HeQRCodePayVC ()<UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UIButton *payButton;
@property(strong,nonatomic)NSTimer *pollingTime;
@property(strong,nonatomic)NSDictionary *qrCodeDict;
@property(strong,nonatomic)UIView *dismissView;
@property(assign,nonatomic)NSInteger repeatTime;

@end

@implementation HeQRCodePayVC
@synthesize qrCode;
@synthesize payButton;
@synthesize pollingTime;
@synthesize qrCodeDict;
@synthesize dismissView;
@synthesize repeatTime;

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
        label.text = @"掃碼支付";
        [label sizeToFit];
        self.title = @"掃碼支付";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self qrCodeCreateWithQRCode:qrCode];
}

- (void)initializaiton
{
    [super initializaiton];
    CGFloat appScanWaitingTime = [[[HeSysbsModel getSysModel].userDetailDict objectForKey:@"appScanWaitingTime"] floatValue] / 1000.0;
    if (appScanWaitingTime < 1) {
        appScanWaitingTime = 1;
    }
    __weak HeQRCodePayVC *weakSelf = self;
    pollingTime = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer *timer){
       
        weakSelf.repeatTime = weakSelf.repeatTime + 1;
        if (weakSelf.repeatTime * 5.0 > appScanWaitingTime) {
            [self showHint:@"系統繁忙，請稍候再試"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        [weakSelf pollingQRcodeWithDict:qrCodeDict];
    }];
//    [pollingTime fire];
}

- (void)initView
{
    [super initView];
    payButton.layer.cornerRadius = 8.0;
    payButton.layer.masksToBounds = YES;
}

- (void)qrCodeCreateWithQRCode:(NSString *)myqrCode
{
    [self showHudInView:self.view hint:@"解析中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/qrcode/create",BASEURL];
    
    NSDictionary *params  = @{@"qrcode":myqrCode};
    
    __weak HeQRCodePayVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        id repondDict = [respondString objectFromJSONString];
        id error = repondDict[@"error"];
        if (!error) {
            qrCodeDict = [[NSDictionary alloc] initWithDictionary:repondDict];
            [weakSelf pollingQRcodeWithDict:repondDict];
        }
        else{
            id errorObj = error;
            NSString *errorTip = errorObj[@"qrcode"];
            if ([errorTip isMemberOfClass:[NSNull class]] || errorTip == nil) {
                [weakSelf showHint:errorTip];
                return ;
            }
        }
        
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
    }];
}

- (void)pollingQRcodeWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:@"正在識別中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/qrcode/index",BASEURL];
    NSString *qrcode = dict[@"qrcode"];
    if ([qrcode isMemberOfClass:[NSNull class]] || qrcode == nil) {
        qrcode = @"";
    }
    NSDictionary *params  = @{@"qrcode":qrcode};
    
    __weak HeQRCodePayVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        id repondDict = [respondString objectFromJSONString];
        id status = repondDict[@"status"];
        if ([status isMemberOfClass:[NSNull class]] || status == nil || [status isEqualToString:@""]) {
            //继续轮询
            if (!pollingTime.isValid) {
                //启动计时器
                [pollingTime fire];
            }
        }
        else if ([status isEqualToString:@"invalid"]){
            //二维码无效或过期
            if (pollingTime.isValid) {
                [pollingTime invalidate];
            }
        }
        else if ([status isEqualToString:@"normal"]){
            //二维码正常，进入支付
            [weakSelf hideHud];
            if (pollingTime.isValid) {
                [pollingTime invalidate];
            }
            id ingots = repondDict[@"ingots"];
            if ([ingots isMemberOfClass:[NSNull class]] || ingots == nil) {
                ingots = @"";
            }
            id twd = repondDict[@"twd"];
            if ([twd isMemberOfClass:[NSNull class]] || twd == nil) {
                twd = @"";
            }
            
            if ([ingots floatValue] < [twd floatValue] || [ingots floatValue] < 0.001) {
                //如果元宝不足，显示让用户充值元宝的按钮
                payButton.hidden = NO;
                [weakSelf showHint:@"如果元宝不足，请及时充值"];
            }
            else{
                [weakSelf inputPayPassword];
            }
            
        }
        else{
            [weakSelf showHint:ERRORREQUESTTIP];
        }
        
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
    }];
}

- (void)inputPayPassword
{
    [self.view addSubview:dismissView];
    dismissView.hidden = NO;
    
    BOOL hasPayPassword = [[[HeSysbsModel getSysModel].userDetailDict objectForKey:@"hasPayPassword"] boolValue];
    if (!hasPayPassword) {
        dismissView.hidden = YES;
        HeModifyPayPasswordVC *settingPayVC = [[HeModifyPayPasswordVC alloc] init];
        settingPayVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingPayVC animated:YES];
        return;
    }
    CGFloat viewX = 10;
    CGFloat viewY = 50;
    CGFloat viewW = SCREENWIDTH - 2 * viewX;
    CGFloat viewH = 150;
    UIView *shareAlert = [[UIView alloc] init];
    shareAlert.frame = CGRectMake(viewX, viewY, viewW, viewH);
    shareAlert.backgroundColor = [UIColor whiteColor];
    shareAlert.layer.cornerRadius = 5.0;
    shareAlert.layer.borderWidth = 0;
    shareAlert.layer.masksToBounds = YES;
    shareAlert.tag = ALERTTAG;
    shareAlert.layer.borderColor = [UIColor clearColor].CGColor;
    shareAlert.userInteractionEnabled = YES;
    
    CGFloat labelH = 40;
    CGFloat labelY = 0;
    
    UIFont *shareFont = [UIFont systemFontOfSize:15.0];
    
    UILabel *messageTitleLabel = [[UILabel alloc] init];
    messageTitleLabel.font = shareFont;
    messageTitleLabel.textColor = [UIColor blackColor];
    messageTitleLabel.textAlignment = NSTextAlignmentCenter;
    messageTitleLabel.backgroundColor = [UIColor clearColor];
    messageTitleLabel.text = @"支付密碼";
    messageTitleLabel.frame = CGRectMake(0, 0, viewW, labelH);
    [shareAlert addSubview:messageTitleLabel];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appIcon"]];
    logoImage.frame = CGRectMake(20, 5, 30, 30);
    [shareAlert addSubview:logoImage];
    
    
    labelY = labelY + labelH + 10;
    UITextField *textview = [[UITextField alloc] init];
    textview.tag = 10;
    textview.secureTextEntry = YES;
    textview.backgroundColor = [UIColor whiteColor];
    textview.tintColor= [UIColor blueColor];
    textview.placeholder = @"請輸入支付密碼";
    textview.font = shareFont;
    textview.delegate = self;
    textview.frame = CGRectMake(10, labelY, shareAlert.frame.size.width - 20, labelH);
    textview.layer.borderWidth = 1.0;
    textview.layer.cornerRadius = 5.0;
    textview.layer.masksToBounds = YES;
    textview.layer.borderColor = [UIColor colorWithWhite:0xcc / 255.0 alpha:1.0].CGColor;
    [shareAlert addSubview:textview];
    
    CGFloat buttonDis = 10;
    CGFloat buttonW = (viewW - 3 * buttonDis) / 2.0;
    CGFloat buttonH = 40;
    CGFloat buttonY = labelY = labelY + labelH + 10;
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
        
        [self showHint:@"請輸入支付密碼"];
        return;
    }
    [self showHudInView:self.view hint:@"支付中..."];
    [self performSelector:@selector(createOrderWithPassword:) withObject:password afterDelay:0.3];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)createOrderWithPassword:(NSString *)password
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/order-pay/create",BASEURL];
    NSString *myqrCode = qrCodeDict[@"qrcode"];
    if (myqrCode == nil) {
        myqrCode = @"";
    }
    //支付方式
    NSString *payment_method  = @"INGOT";
    //支付密码
    NSString *pay_password  = password;
    NSDictionary *params  = @{@"qrcode":myqrCode,@"payment_method":payment_method,@"pay_password":pay_password};
    
    __weak HeQRCodePayVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        id repondDict = [respondString objectFromJSONString];
        id error = repondDict[@"error"];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HeOrderVC *orderDetailVC = [[HeOrderVC alloc] init];
                //返回跳根目录
                orderDetailVC.popToRoot = YES;
                orderDetailVC.orderType = 0;
                orderDetailVC.hidesBottomBarWhenPushed = YES;
                orderDetailVC.orderDetailDict = [[NSDictionary alloc] initWithDictionary:repondDict];
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            });
        }
        else{
            id errorObj = [error objectFromJSONString];
            NSString *errorTip = errorObj[@"qrcode"];
            if ([errorTip isMemberOfClass:[NSNull class]] || errorTip == nil) {
                [weakSelf showHint:errorTip];
                return ;
            }
        }
        
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
    }];
}

- (IBAction)payButtonClick:(id)sender
{
    HeDCoinStoreVC *storeDCointVC = [[HeDCoinStoreVC alloc] init];
    storeDCointVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeDCointVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (pollingTime.isValid) {
        [pollingTime invalidate];
        pollingTime = nil;
    }
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
