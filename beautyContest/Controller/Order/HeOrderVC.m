//
//  HeOrderVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeOrderVC.h"
#import "HeBaseTableViewCell.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"

@interface HeOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)IBOutlet UILabel *dCoinValueLabel;
@property(strong,nonatomic)IBOutlet UILabel *dCoinTitleLabel;
@property(strong,nonatomic)IBOutlet UILabel *orderTitleLabel;
@property(assign,nonatomic)BOOL isSuperPay; //是否超商付款
@property(assign,nonatomic)BOOL isTradeFinsh; //是否交易成功

@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;

@end

@implementation HeOrderVC
@synthesize tableview;
@synthesize dCoinValueLabel;
@synthesize datasource;
@synthesize titleLabel;
@synthesize orderDetailDict;
@synthesize dCoinTitleLabel;
@synthesize orderTitleLabel;
@synthesize isSuperPay;
@synthesize isTradeFinsh;

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
        label.text = @"訂單記錄";
        [label sizeToFit];
        self.title = @"訂單記錄";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadOrderDetail];
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
    NSString *pay_status_name = orderDetailDict[@"status_name"];
    if ([pay_status_name isMemberOfClass:[NSNull class]]) {
        pay_status_name = @"";
    }
    if ([pay_status_name isEqualToString:@"交易成功"]) {
        isTradeFinsh = YES;
        datasource = @[@"訂單狀態",@"訂單號",@"付款方式",@"收款賬號",@"付款金額",@"創建時間",@"交易成功時間"];
        id allpay_request = orderDetailDict[@"allpay_request"];
        if ([allpay_request isMemberOfClass:[NSNull class]]) {
            allpay_request = nil;
        }
        id ChoosePayment = allpay_request[@"ChoosePayment"];
        if ([ChoosePayment isMemberOfClass:[NSNull class]] || ChoosePayment == nil) {
            ChoosePayment = nil;
        }
        isSuperPay = NO;
        if ([ChoosePayment isEqualToString:@"CVS"]) {
            isSuperPay = YES;
            datasource = @[@"訂單狀態",@"訂單號",@"付款方式",@"付款金額",@"創建時間",@"交易成功時間"];
        }
        
        
        if (_orderType == 0) {
            datasource = @[@"訂單狀態",@"訂單號",@"創建時間",@"交易成功時間"];
        }
    }
    else{
        isTradeFinsh = NO;
        datasource = @[@"訂單狀態",@"訂單號",@"付款方式",@"收款賬號",@"付款金額",@"創建時間"];
        id allpay_request = orderDetailDict[@"allpay_request"];
        if ([allpay_request isMemberOfClass:[NSNull class]]) {
            allpay_request = nil;
        }
        id ChoosePayment = allpay_request[@"ChoosePayment"];
        if ([ChoosePayment isMemberOfClass:[NSNull class]] || ChoosePayment == nil) {
            ChoosePayment = nil;
        }
        isSuperPay = NO;
        if ([ChoosePayment isEqualToString:@"CVS"]) {
            isSuperPay = YES;
            datasource = @[@"訂單狀態",@"訂單號",@"付款方式",@"付款金額",@"創建時間"];
        }
        
        
        if (_orderType == 0) {
            datasource = @[@"訂單狀態",@"訂單號",@"創建時間"];
        }
    }
    
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    footerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    tableview.tableFooterView = footerview;
    
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 6.0;
    
    CGFloat tipLabelX = 10;
    CGFloat tipLabelY = 10;
    CGFloat tipLabelW = SCREENWIDTH - 2 * tipLabelX;
    CGFloat tipLabelH = 40;
    
    UIFont *contentFont = [UIFont systemFontOfSize:13.0];
    NSString *contentString = @"請將費用通過ATM或用網銀轉入上方\"收款賬戶\"內，即可完成儲值";
    if (isSuperPay) {
        contentString = @"";
        tipLabelH = 0;
    }
    CGSize contentsize = [MLLabel getViewSizeByString:contentString maxWidth:tipLabelW font:contentFont lineHeight:1.2f lines:0];
    tipLabelH = contentsize.height;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, tipLabelH)];
    tipLabel.text = contentString;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = contentFont;
    tipLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [footerview addSubview:tipLabel];
    if (_orderType == 0) {
        tipLabel.hidden = YES;
        orderTitleLabel.text = @"掃碼訂單";
    }
    
    CGFloat backButtonX = 20;
    CGFloat backButtonY = CGRectGetMaxY(tipLabel.frame) + 10;
    CGFloat backButtonW = SCREENWIDTH - 2 * backButtonX;
    CGFloat backButtonH = 40;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH)];
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 8.0;
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:backButton];
    
    [backButton setBackgroundImage:[Tool buttonImageFromColor:DEFAULTREDCOLOR withImageSize:backButton.frame.size] forState:UIControlStateNormal];
    
}

- (void)loadOrderDetail
{
    [self showHudInView:tableview hint:@"加載中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/order/view",BASEURL];
    
    NSString *oid = orderDetailDict[@"oid"];
    NSDictionary *params  = @{@"oid":oid};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
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
                [self showHint:errorString];
            }
        }
        
        id orderdict = [respondString objectFromJSONString];
        if (orderdict) {
            orderDetailDict = [[NSDictionary alloc] initWithDictionary:orderdict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *biz_rmb = orderDetailDict[@"biz_rmb"];
            if ([biz_rmb isMemberOfClass:[NSNull class]] || biz_rmb == nil) {
                biz_rmb = @"";
            }
            dCoinValueLabel.text = [NSString stringWithFormat:@"%@ D幣",biz_rmb];
            
            NSString *ItemName = orderDetailDict[@"biz_name"];
            if (_orderType == 0) {
                ItemName = orderDetailDict[@"qr_brief"];
            }
            if ([ItemName isMemberOfClass:[NSNull class]] || ItemName == nil) {
                ItemName = @"";
            }
            dCoinTitleLabel.text = ItemName;
            
            [tableview reloadData];
        });
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)backButtonClick:(UIButton *)sender
{
    if (_isfromecommit) {
        NSArray *array = self.navigationController.viewControllers;
        for (UIViewController *vc in array) {
            if ([vc isKindOfClass:[HomePageVC class]]) {
                [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        
    }
    
    if (self.popToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
            NSString *status_name = orderDetailDict[@"status_name"];
            if ([status_name isMemberOfClass:[NSNull class]] || status_name == nil) {
                status_name = @"";
            }
            contentLabel.text = status_name;
            if (isTradeFinsh) {
                contentLabel.textColor = [UIColor greenColor];
            }
            else{
                contentLabel.textColor = DEFAULTREDCOLOR;
            }
            if (_orderType == 0) {
                contentLabel.textColor = APPDEFAULTORANGE;
            }
            break;
        }
        case 1:{
            NSString *oid = orderDetailDict[@"oid"];
            if ([oid isMemberOfClass:[NSNull class]] || oid == nil) {
                oid = @"";
            }
            contentLabel.text = oid;
            break;
        }
        case 2:{
            if (_orderType == 0) {
                NSString *created_at = orderDetailDict[@"created_at"];
                if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                    created_at = @"";
                }
                contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
            }
            else{
                id allpay_request = orderDetailDict[@"allpay_request"];
                if ([allpay_request isMemberOfClass:[NSNull class]]) {
                    allpay_request = nil;
                }
                id ChoosePayment = allpay_request[@"ChoosePayment"];
                if ([ChoosePayment isMemberOfClass:[NSNull class]] || ChoosePayment == nil) {
                    ChoosePayment = nil;
                }
                if ([ChoosePayment isEqualToString:@"CVS"]) {
                    contentLabel.text = @"超商付款";
                }
                else{
                    contentLabel.text = @"銀行賬戶付款";
                }
            }
            
            break;
        }
        case 3:{
            if (_orderType == 0 && isTradeFinsh) {
                //掃碼交易完成訂單顯示完成時間
                NSString *created_at = orderDetailDict[@"updated_at"];
                if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                    created_at = @"";
                }
                contentLabel.textColor = DEFAULTREDCOLOR;
                contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
            }
            else{
                if (isSuperPay) {
                    NSString *pay_amount = orderDetailDict[@"pay_amount"];
                    if ([pay_amount isMemberOfClass:[NSNull class]] || pay_amount == nil) {
                        pay_amount = @"";
                    }
                    contentLabel.text = [NSString stringWithFormat:@"%@台幣",pay_amount];
                }
                else{
                    NSString *pm_payee_acct_no = orderDetailDict[@"pm_payee_acct_no"];
                    if ([pm_payee_acct_no isMemberOfClass:[NSNull class]] || pm_payee_acct_no == nil) {
                        pm_payee_acct_no = @"";
                    }
                    contentLabel.text = pm_payee_acct_no;
                }
            }
            
            
            break;
        }
        case 4:{
            if (isSuperPay) {
                NSString *created_at = orderDetailDict[@"created_at"];
                if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                    created_at = @"";
                }
                contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
            }
            else{
                NSString *pay_amount = orderDetailDict[@"pay_amount"];
                if ([pay_amount isMemberOfClass:[NSNull class]] || pay_amount == nil) {
                    pay_amount = @"";
                }
                contentLabel.text = [NSString stringWithFormat:@"%@台幣",pay_amount];
            }
            break;
        }
        case 5:{
            if (isSuperPay) {
                NSString *created_at = orderDetailDict[@"updated_at"];
                if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                    created_at = @"";
                }
                contentLabel.textColor = DEFAULTREDCOLOR;
                contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
            }
            else{
                NSString *created_at = orderDetailDict[@"created_at"];
                if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                    created_at = @"";
                }
                contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
            }
            
            break;
        }
        case 6:{
            NSString *created_at = orderDetailDict[@"updated_at"];
            contentLabel.textColor = DEFAULTREDCOLOR;
            if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                created_at = @"";
            }
            contentLabel.text = [NSString stringWithFormat:@"%@",created_at];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"section = %ld , row = %ld",section,row);
    
}

- (void)backItemClick:(id)sender
{
    if (_isfromecommit) {
        NSArray *array = self.navigationController.viewControllers;
        for (UIViewController *vc in array) {
            if ([vc isKindOfClass:[HomePageVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
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
