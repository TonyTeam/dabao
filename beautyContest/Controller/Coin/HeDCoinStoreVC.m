//
//  HeDCoinStoreVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeDCoinStoreVC.h"
#import "HeBaseTableViewCell.h"
#import "MLLabel+Size.h"
#import "MLLabel.h"
#import "HeOrderVC.h"

@interface HeDCoinStoreVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)UITextField *storeCoinField;
@property(assign,nonatomic)NSInteger selectBank; //1:郵局 2：玉山銀行 3:超商銀行
@property(strong,nonatomic)UILabel *paytitleLabel;
@property(strong,nonatomic)NSArray *bankArray;

@end

@implementation HeDCoinStoreVC
@synthesize tableview;
@synthesize datasource;
@synthesize storeCoinField;
@synthesize selectBank;
@synthesize paytitleLabel;
@synthesize bankArray;

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
        label.text = @"D幣儲值";
        [label sizeToFit];
        self.title = @"D幣儲值";
        
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
    datasource = @[@[@"金額"],@[@"選擇儲值方式"],@[@"郵局",@"玉山商銀",@"超商付款"]];
    selectBank = 1;
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    
    storeCoinField = [[UITextField alloc] init];
    storeCoinField.keyboardType = UIKeyboardTypeNumberPad;
    storeCoinField.delegate = self;
    storeCoinField.placeholder = @"請填寫儲值金額";
    storeCoinField.font = [UIFont systemFontOfSize:16.0];
    storeCoinField.textColor = [UIColor blackColor];
    
    tableview.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    tableview.tableFooterView = footerview;
    
    self.view.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
    CGFloat commitButtonX = 20;
    CGFloat commitButtonY = 10;
    CGFloat commitButtonW = SCREENWIDTH - 2 * commitButtonX;
    CGFloat commitButtonH = 40;
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(commitButtonX, commitButtonY, commitButtonW, commitButtonH)];
    [commitButton setBackgroundImage:[Tool buttonImageFromColor:[UIColor colorWithRed:250.0 / 255.0 green:49.0 / 255.0 blue:43.0 / 255.0 alpha:1.0] withImageSize:commitButton.frame.size] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton setTitle:@"確認儲值" forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.layer.masksToBounds = YES;
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [footerview addSubview:commitButton];
}

- (void)commitButtonClick:(UIButton *)sender
{
    NSLog(@"commitButtonClick");
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/order-ingot/create",BASEURL];
    
    NSString *biz_rmb = storeCoinField.text;
    if ([biz_rmb floatValue] < 1) {
        [self showHint:@"儲值金額必須大於1"];
        return;
    }
    if (selectBank == -1) {
        [self showHint:@"請選擇支付方式"];
        return;
    }
    
    NSString *payment_method = @"20";
    switch (selectBank) {
        case 1:
        {
            //郵局
            payment_method = @"20";
            break;
        }
        case 2:
        {
            //玉山銀行
            payment_method = @"19";
            break;
        }
        case 3:
        {
            //超商支付
            payment_method = @"CVS_CVS";
            break;
        }
        default:
            break;
    }
    NSDictionary *params  = @{@"biz_rmb":biz_rmb,@"payment_method":payment_method};
    [self showHudInView:tableview hint:@"系統正在處理您的訂單，請稍候"];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [respondString objectFromJSONString];
        
        NSMutableString *error = [[NSMutableString alloc] initWithCapacity:0];
        id biz_rmbObj = respondDict[@"error"][@"biz_rmb"];
        if ([biz_rmbObj isMemberOfClass:[NSNull class]] || biz_rmbObj == nil) {
            biz_rmbObj = @"";
        }
        else{
            [error appendFormat:@"%@",biz_rmbObj];
        }
        id amountObj = respondDict[@"error"][@"amount"];
        if ([amountObj isMemberOfClass:[NSNull class]] || amountObj == nil) {
            amountObj = @"";
        }
        else{
            if (error.length > 0) {
                [error appendFormat:@",%@",amountObj];
            }
            else{
                [error appendFormat:@"%@",amountObj];
            }
        }
        id payment_method = respondDict[@"error"][@"payment_method"];
        if ([payment_method isMemberOfClass:[NSNull class]] || payment_method == nil) {
            payment_method = @"";
        }
        else{
            if (error.length > 0) {
                [error appendFormat:@",%@",payment_method];
            }
            else{
                [error appendFormat:@"%@",payment_method];
            }
        }
        if (error.length > 0) {
            [self showHint:error];
            return ;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEORDER_NOTIFICATION object:nil];
        [self showHint:@"創建儲值訂單成功"];
        if (_isfromecommit) {
            HeOrderVC *orderVC = [[HeOrderVC alloc] init];
            orderVC.isfromecommit = YES;
            orderVC.orderType = 1;
            orderVC.orderDetailDict = [[NSDictionary alloc] initWithDictionary:respondDict];
            orderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderVC animated:YES];
            
            return;
        }
        [self performSelector:@selector(backToLastView) withObject:nil afterDelay:0.2];
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectButtonClick:(UIButton *)sender
{
    NSLog(@"selectButtonClick");
    sender.selected = YES;
    selectBank = sender.tag;
    [tableview reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSDictionary *dict = [HeSysbsModel getSysModel].userDetailDict;
    id er = dict[@"er"];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    
    CGFloat total = [text floatValue] * [er floatValue];
    if ([text floatValue] > 0.9) {
        paytitleLabel.text = [NSString stringWithFormat:@"需要支付: %.2f台幣",total];
    }
    else{
        paytitleLabel.text = @"";
    }

    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat cellH = [tableview rectForRowAtIndexPath:indexPath].size.height;
    
    HeBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, cellH)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textColor = [UIColor blackColor];
                    titleLabel.text = @"金額";
                    titleLabel.font = [UIFont systemFontOfSize:16.0];
                    [cell addSubview:titleLabel];
                    
                    CGFloat storeCoinFieldX = CGRectGetMaxX(titleLabel.frame) + 10;
                    storeCoinField.frame = CGRectMake(storeCoinFieldX, 0, SCREENWIDTH - 10 - storeCoinFieldX, cellH);
                    
                    [cell addSubview:storeCoinField];
                    
                                                      
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (row) {
                case 0:
                {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, cellH)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textColor = [UIColor grayColor];
                    titleLabel.text = @"選擇儲值方式";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:titleLabel];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            CGFloat selectButtonH = 20;
            CGFloat selectButtonW = 20;
            CGFloat selectButtonX = SCREENWIDTH - 10 - selectButtonW;
            CGFloat selectButtonY = (cellH - selectButtonH) / 2.0;
           
            
            UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(selectButtonX, selectButtonY, selectButtonW, selectButtonH)];
            selectButton.tag = row + 1;
            [selectButton setImage:[UIImage imageNamed:@"icon_confirm"] forState:UIControlStateSelected];
            [selectButton setImage:[UIImage imageNamed:@"icon_unconfirm"] forState:UIControlStateNormal];
            [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:selectButton];
            if (selectBank == selectButton.tag) {
                selectButton.selected = YES;
            }
            else{
                selectButton.selected = NO;
            }
            
            
            
            switch (row) {
                case 0:
                {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, cellH / 2.0)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textColor = [UIColor blackColor];
                    titleLabel.text = @"郵局";
                    titleLabel.font = [UIFont systemFontOfSize:16.0];
                    [cell addSubview:titleLabel];
                    
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), SCREENWIDTH - 20, cellH / 2.0)];
                    contentLabel.backgroundColor = [UIColor clearColor];
                    contentLabel.textColor = [UIColor grayColor];
                    contentLabel.text = @"卡號后六位:***338";
                    contentLabel.font = [UIFont systemFontOfSize:16.0];
                    [cell addSubview:contentLabel];
                    
                    
                    break;
                }
                case 1:
                {
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, cellH / 2.0)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textColor = [UIColor blackColor];
                    titleLabel.text = @"玉山銀行";
                    titleLabel.font = [UIFont systemFontOfSize:16.0];
                    [cell addSubview:titleLabel];
                    
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), SCREENWIDTH - 20, cellH / 2.0)];
                    contentLabel.backgroundColor = [UIColor clearColor];
                    contentLabel.textColor = [UIColor grayColor];
                    contentLabel.text = @"卡號后六位:***242";
                    contentLabel.font = [UIFont systemFontOfSize:16.0];
                    [cell addSubview:contentLabel];
                    
                    break;
                }
                case 2:
                {
                    CGFloat imageViewX = 10;
                    CGFloat imageViewH = 20;
                    CGFloat imageViewW = 20;
                    CGFloat imageViewY = (50 - imageViewH) / 2.0;
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bank_note"]];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
                    [cell addSubview:imageView];
                    
                    CGFloat titleLabelX = CGRectGetMaxX(imageView.frame) + 15;
                    CGFloat titleLabelY = 0;
                    CGFloat titleLabelW = SCREENWIDTH - 2 * titleLabelX;
                    CGFloat titleLabelH = 50;
                    
                    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
                    titleLabel1.font = [UIFont systemFontOfSize:16.0];
                    titleLabel1.backgroundColor = [UIColor clearColor];
                    titleLabel1.textColor = [UIColor blackColor];
                    titleLabel1.text = @"超商付款";
                    [cell addSubview:titleLabel1];
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    return 50.0;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (row) {
                case 0:
                {
                    return 50.0;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (row) {
                case 0:
                {
                    return 70.0;
                    break;
                }
                case 1:
                {
                    return 70.0;
                    break;
                }
                case 2:
                {
                    return 50.0;
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 30;
            break;
        case 2:
            return 50;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] init];
    headerview.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
    switch (section) {
        case 0:
        {
            return nil;
            break;
        }
        case 1:
        {
            
            headerview.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
            
            NSDictionary *dict = [HeSysbsModel getSysModel].userDetailDict;
            id er = dict[@"er"];
            NSString *title = [NSString stringWithFormat:@"今日匯率: %@",er];
            CGFloat titleLabelX = 10;
            CGFloat titleLabelY = 0;
            CGFloat titleLabelW = [MLLabel getViewSizeByString:title maxWidth:(SCREENWIDTH - 2 * titleLabelX) font:[UIFont systemFontOfSize:15.0] lineHeight:1.2f lines:0].width;
            CGFloat titleLabelH = 30;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont systemFontOfSize:13.0];
            titleLabel.text = [NSString stringWithFormat:@"今日匯率: %@",er];
            [headerview addSubview:titleLabel];
            
            titleLabelX = CGRectGetMaxX(titleLabel.frame) + 15;
            titleLabelW = SCREENWIDTH - 10 - titleLabelX;
            
            if (!paytitleLabel) {
                paytitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
            }
            
            paytitleLabel.font = [UIFont systemFontOfSize:13.0];
            paytitleLabel.backgroundColor = [UIColor clearColor];
            paytitleLabel.textColor = [UIColor colorWithRed:253.0 / 255.0 green:105.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
            
            NSString *text = storeCoinField.text;
            CGFloat total = [text floatValue] * [er floatValue];
            if ([text floatValue] > 0.9) {
                paytitleLabel.text = [NSString stringWithFormat:@"需要支付: %.2f台幣",total];
            }
            else{
                paytitleLabel.text = @"";
            }
            [headerview addSubview:paytitleLabel];
            
            break;
        }
        case 2:
        {
            headerview.backgroundColor = [UIColor whiteColor];
            
            CGFloat imageViewX = 10;
            CGFloat imageViewH = 20;
            CGFloat imageViewW = 20;
            CGFloat imageViewY = (50 - imageViewH) / 2.0;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_container"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
            [headerview addSubview:imageView];
            
            CGFloat titleLabelX = CGRectGetMaxX(imageView.frame) + 15;
            CGFloat titleLabelY = 0;
            CGFloat titleLabelW = SCREENWIDTH - 2 * titleLabelX;
            CGFloat titleLabelH = 50;
            
            UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
            titleLabel1.font = [UIFont systemFontOfSize:15.0];
            titleLabel1.backgroundColor = [UIColor clearColor];
            titleLabel1.textColor = [UIColor blackColor];
            titleLabel1.text = @"網絡ATM/AT,提款機";
            [headerview addSubview:titleLabel1];
            
            break;
        }
        default:
            break;
    }
    
    return headerview;
}

- (void)backItemClick:(id)sender
{
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
