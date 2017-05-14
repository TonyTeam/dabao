//
//  HeOrderCommitVC.m
//  beautyContest
//
//  Created by Tony on 2017/5/10.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeOrderCommitVC.h"
#import "HeBaseTableViewCell.h"
#import "HeDCoinStoreVC.h"
#import "HeModifyPayPasswordVC.h"

#define ALERTTAG 200

@interface HeOrderCommitVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)IBOutlet UILabel *dCoinValueLabel;
@property(strong,nonatomic)IBOutlet UILabel *dCoinTitleLabel;
@property(strong,nonatomic)IBOutlet UILabel *orderTitleLabel;
@property(assign,nonatomic)BOOL isSuperPay; //是否超商付款
@property(assign,nonatomic)BOOL isTradeFinsh; //是否交易成功

@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;

@property(strong,nonatomic)UIView *dismissView;

@end

@implementation HeOrderCommitVC
@synthesize tableview;
@synthesize dCoinValueLabel;
@synthesize datasource;
@synthesize titleLabel;
@synthesize dCoinTitleLabel;
@synthesize orderTitleLabel;
@synthesize isSuperPay;
@synthesize isTradeFinsh;
@synthesize orderDetailDict;

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
        label.text = @"訂單提交";
        [label sizeToFit];
        self.title = @"訂單提交";
        
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
    datasource = @[@"訂單狀態",@"商品說明",@"創建時間",@"失效時間"];
}

- (void)initView
{
    [super initView];
    
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height)];
    dismissView.backgroundColor = [UIColor blackColor];
    dismissView.hidden = YES;
    dismissView.alpha = 0.7;
    [self.view addSubview:dismissView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewGes:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [dismissView addGestureRecognizer:tapGes];
    
    [Tool setExtraCellLineHidden:tableview];
    
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    footerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    tableview.tableFooterView = footerview;
    
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 6.0;
    
    titleLabel.text = @"進行中的訂單";
    orderTitleLabel.text = @"進行中的訂單";
    dCoinTitleLabel.text = [NSString stringWithFormat:@"%@",orderDetailDict[@"product"]];
    
    dCoinValueLabel.text = [NSString stringWithFormat:@"%@",orderDetailDict[@"rmb"]];
    CGFloat backButtonX = 20;
    CGFloat backButtonY = 10;
    CGFloat backButtonW = SCREENWIDTH - 2 * backButtonX;
    CGFloat backButtonH = 40;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH)];
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 8.0;
    [backButton setTitle:@"確認付款" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(confirmPay:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:backButton];
    
    [backButton setBackgroundImage:[Tool buttonImageFromColor:DEFAULTREDCOLOR withImageSize:backButton.frame.size] forState:UIControlStateNormal];
}

- (void)dismissViewGes:(UITapGestureRecognizer *)ges
{
    
    UIView *mydismissView = ges.view;
    mydismissView.hidden = YES;
    
    UIView *alertview = [self.view viewWithTag:ALERTTAG];
    
    [alertview removeFromSuperview];
}

- (void)confirmPay:(UIButton *)button
{
    NSLog(@"confirmPay");
    id ingots = orderDetailDict[@"ingots"];
    if ([ingots isMemberOfClass:[NSNull class]] || ingots == nil) {
        ingots = @"";
    }
    id twd = orderDetailDict[@"twd"];
    if ([twd isMemberOfClass:[NSNull class]] || twd == nil) {
        twd = @"";
    }
    
    if ([ingots floatValue] < [twd floatValue] || [ingots floatValue] < 0.001) {
        //如果元宝不足，显示让用户充值元宝的按钮
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的餘額不足" message:@"是否去充值頁面充值D幣!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alertController addAction:cancelaction];
        
        UIAlertAction *confirmaction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            dispatch_async(dispatch_get_main_queue(), ^{
                //进行充值
                HeDCoinStoreVC *storeVC = [[HeDCoinStoreVC alloc] init];
                storeVC.isfromecommit = YES;
                storeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:storeVC animated:YES];
            });
        }];
        [alertController addAction:confirmaction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    BOOL hasPayPassword = [[[HeSysbsModel getSysModel].userDetailDict objectForKey:@"hasPayPassword"] boolValue];
    if (!hasPayPassword) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未設置支付密碼" message:@"是否去設置支付密碼!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alertController addAction:cancelaction];
        
        UIAlertAction *confirmaction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            dispatch_async(dispatch_get_main_queue(), ^{
                //进行充值
                HeModifyPayPasswordVC *settingPayVC = [[HeModifyPayPasswordVC alloc] init];
                settingPayVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:settingPayVC animated:YES];
            });
        }];
        [alertController addAction:confirmaction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        return;
    }
    [self inputPayPassword];
}

- (void)inputPayPassword
{
    [self.view addSubview:dismissView];
    dismissView.hidden = NO;

    CGFloat viewX = 10;
    CGFloat viewY = 150;
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
    messageTitleLabel.font = [UIFont systemFontOfSize:17.0];
    messageTitleLabel.textColor = [UIColor blackColor];
    messageTitleLabel.textAlignment = NSTextAlignmentCenter;
    messageTitleLabel.backgroundColor = [UIColor clearColor];
    messageTitleLabel.text = @"支付密碼";
    messageTitleLabel.frame = CGRectMake(0, 0, viewW, labelH);
    [shareAlert addSubview:messageTitleLabel];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appIcon"]];
    logoImage.frame = CGRectMake(20, 5, 30, 30);
//    [shareAlert addSubview:logoImage];
    
    
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
    [shareButton setTitle:@"取消" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(alertbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag = 0;
    [shareButton.titleLabel setFont:shareFont];
    [shareButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    [shareAlert addSubview:shareButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX + buttonDis + buttonW, buttonY, buttonW, buttonH)];
    [cancelButton setTitle:@"確認" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(alertbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1;
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
    [self showHudInView:self.view hint:@"正在支付，請稍候..."];
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/order-qrpay/create",BASEURL];
    NSString *myqrCode = orderDetailDict[@"qrcode"];
    if (myqrCode == nil) {
        myqrCode = @"";
    }
    //支付方式
    NSString *payment_method  = @"INGOT";
    //支付密码
    NSString *pay_password  = password;
    NSDictionary *params  = @{@"qrcode":myqrCode,@"payment_method":payment_method,@"pay_password":pay_password};
    
    __weak HeOrderCommitVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        id repondDict = [respondString objectFromJSONString];
        id error = repondDict[@"error"];
        if (!error) {
            [self showHint:@"訂單創建成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:GETUSERDATA_NOTIFICATION object:nil];
            NSArray *array = self.navigationController.viewControllers;
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:[HomePageVC class]]) {
                    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                HeOrderVC *orderDetailVC = [[HeOrderVC alloc] init];
//                //返回跳根目录
//                orderDetailVC.isfromecommit = YES;
//                orderDetailVC.orderType = 0;
//                orderDetailVC.hidesBottomBarWhenPushed = YES;
//                orderDetailVC.orderDetailDict = [[NSDictionary alloc] initWithDictionary:repondDict];
//                [self.navigationController pushViewController:orderDetailVC animated:YES];
//            });
        }
        else{
            NSDictionary *resultDict = [respondString objectFromJSONString];
            if ([resultDict isKindOfClass:[NSDictionary class]]) {
                NSDictionary *error = resultDict[@"error"];
                if (error) {
                    NSArray *allkey = error.allKeys;
                    NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:0];
                    for (NSInteger index = 0; index < [allkey count]; index++) {
                        NSString *key = allkey[index];
                        NSString *value = error[key];
                        [errorString appendFormat:@"%@",value];
                    }
                    if ([allkey count] == 0) {
                        errorString = [[NSMutableString alloc] initWithString:ERRORREQUESTTIP];
                    }
                    [weakSelf showHint:errorString];
                }
            }
        }
        
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGSize cellsize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat cellH = cellsize.height;
    
    static NSString *cellIndentifier = @"HeDCoinStoreCell";
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    
    CGFloat titleLabelX = 10;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = SCREENWIDTH - 2 * titleLabelX;
    CGFloat titleLabelH = cellH;
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = [UIFont systemFontOfSize:15.0];
    subtitleLabel.text = datasource[row];
    subtitleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:subtitleLabel];
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:14.0];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:contentLabel];
    switch (row) {
        case 0:
        {
            NSString *status_name = orderDetailDict[@"status"];
            if ([status_name isMemberOfClass:[NSNull class]] || status_name == nil) {
                status_name = @"";
            }
            if ([status_name isEqualToString:@"normal"]) {
                status_name = @"等待確認付款";
            }
            contentLabel.text = status_name;
            contentLabel.textColor = APPDEFAULTORANGE;
            break;
        }
        case 1:{
            NSString *brief = orderDetailDict[@"brief"];
            if ([brief isMemberOfClass:[NSNull class]] || brief == nil) {
                brief = @"";
            }
            contentLabel.text = brief;
            break;
        }
        case 2:{
            
            id zoneCreatetimeObj = [orderDetailDict objectForKey:@"trade_created_at"];
            zoneCreatetimeObj = [NSString stringWithFormat:@"%@000",zoneCreatetimeObj];
            if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
                NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
                zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
            }
            long long timestamp = [zoneCreatetimeObj longLongValue];
            NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
            if ([zoneCreatetime length] > 3) {
                //时间戳
                zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
            }
            
            NSString *time = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"yyyy-MM-dd hh:mm:ss"];
            
            NSString *created_at = time;
            contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
            
            break;
        }
        case 3:{
            
            id zoneCreatetimeObj = [orderDetailDict objectForKey:@"trade_closed_at"];
            zoneCreatetimeObj = [NSString stringWithFormat:@"%@000",zoneCreatetimeObj];
            if ([zoneCreatetimeObj isMemberOfClass:[NSNull class]] || zoneCreatetimeObj == nil) {
                NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
                zoneCreatetimeObj = [NSString stringWithFormat:@"%.0f000",timeInterval];
            }
            long long timestamp = [zoneCreatetimeObj longLongValue];
            NSString *zoneCreatetime = [NSString stringWithFormat:@"%lld",timestamp];
            if ([zoneCreatetime length] > 3) {
                //时间戳
                zoneCreatetime = [zoneCreatetime substringToIndex:[zoneCreatetime length] - 3];
            }
            
            NSString *time = [Tool convertTimespToString:[zoneCreatetime longLongValue] dateFormate:@"yyyy-MM-dd hh:mm:ss"];
            
            NSString *trade_closed_at = time;
        
            contentLabel.text = [NSString stringWithFormat:@"%@",trade_closed_at];
            contentLabel.textColor = DEFAULTREDCOLOR;
            
            break;
        }
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)backItemClick:(id)sender
{
    NSArray *array = self.navigationController.viewControllers;
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:[HomePageVC class]]) {
            [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
