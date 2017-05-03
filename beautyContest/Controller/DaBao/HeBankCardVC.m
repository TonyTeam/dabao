//
//  HeBankCardVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBankCardVC.h"
#import "HeBaseTableViewCell.h"
#import "HeBankCardCell.h"
#import "YLButton.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"
#import "HeAddBandCardVC.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"

@interface HeBankCardVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)IBOutlet UILabel *numLabel;
@property(strong,nonatomic)IBOutlet YLButton *addButton;
@property(strong,nonatomic)NSMutableArray *datasource;
@property(strong,nonatomic)IBOutlet UILabel *bankCarNumLabel;

@end

@implementation HeBankCardVC
@synthesize tableview;
@synthesize numLabel;
@synthesize addButton;
@synthesize datasource;
@synthesize bankCarNumLabel;

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
        label.text = @"銀行卡";
        [label sizeToFit];
        self.title = @"銀行卡";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadBankCardData];
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
    datasource = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBankCard:) name:UPDATEUSERBANKCARD_NOTIFICATION object:nil];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    addButton.layer.cornerRadius = 8.0;
    addButton.layer.masksToBounds = YES;
    
    
    CGSize titleszie = [MLLabel getViewSizeByString:@"新增銀行卡" maxWidth:(SCREENWIDTH - 70) font:addButton.titleLabel.font lineHeight:1.2f lines:0];
    
    CGFloat titleX = (SCREENWIDTH - 40 - 30 - titleszie.width) / 2.0;
    CGFloat titleY = 0;
    CGFloat titleW = titleszie.width;
    CGFloat titleH = addButton.frame.size.height;
    
    CGFloat imageH = 20.0;
    UIImage *iconImage = [UIImage imageNamed:@"icon_gray_choose"];
    CGFloat imageW =iconImage.size.width * imageH  / iconImage.size.height;
    
    [addButton setImage:iconImage forState:UIControlStateNormal];
    addButton.titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    addButton.imageRect = CGRectMake(titleX + titleW + 10, (titleH - imageH) / 2.0, imageW, imageH);
    
    NSDictionary *userDetailDict = [HeSysbsModel getSysModel].userDetailDict;
    NSInteger bankCarNum = [userDetailDict[@"bankAccountsQty"] integerValue];
    bankCarNumLabel.text = [NSString stringWithFormat:@"%ld",bankCarNum];
    
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block,刷新
        [self.tableview.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
        [self loadBankCardData];
        
    }];
}

- (void)updateBankCard:(NSNotification *)notificaiton
{
    [self loadBankCardData];
}

- (void)loadBankCardData
{
    [self showHudInView:tableview hint:@"加載中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/account/index",BASEURL];
    
    NSDictionary *params  = nil;
    
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        id bankCardArray = [respondString objectFromJSONString];
        if ([bankCardArray isMemberOfClass:[NSNull class]]) {
            bankCardArray = [bankCardArray array];
        }
        [datasource removeAllObjects];
        for (NSDictionary *dict in bankCardArray) {
            [datasource addObject:dict];
        }
        if ([datasource count] == 0) {
            UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
            UIImage *noImage = [UIImage imageNamed:@"icon_cry"];
            CGFloat scale = noImage.size.height / noImage.size.width;
            CGFloat imageW = 120;
            CGFloat imageH = imageW * scale;
            CGFloat imageX = (SCREENWIDTH - imageW) / 2.0;
            CGFloat imageY = SCREENHEIGH - imageH - 100;
            UIImageView *imageview = [[UIImageView alloc] initWithImage:noImage];
            imageview.frame = CGRectMake(imageX, imageY, imageW, imageH);
            CGPoint center = bgView.center;
            center.y = center.y - 80;
            imageview.center = center;
            [bgView addSubview:imageview];
            tableview.backgroundView = bgView;
        }
        else{
            tableview.backgroundView = nil;
        }
        if ([datasource count] > 0) {
            bankCarNumLabel.text = [NSString stringWithFormat:@"%ld",[datasource count]];
        }
        else{
            bankCarNumLabel.text = @"0";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableview reloadData];
        });
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}
//删除银行卡
- (void)deleteCardWithNum:(NSString *)deleteCardNum
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/account/delete",BASEURL];
    
    NSDictionary *params  = @{@"id":deleteCardNum};
    
    __weak HeBankCardVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
//        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary *resultDict = [respondString objectFromJSONString];
        id error = resultDict[@"error"];
        if (error) {
            [self showHint:@"刪除失敗"];
        }
        //进行懒加载
        [weakSelf reloadBankCard];
        //更新用户的信息，包括银行卡账号信息
        [[NSNotificationCenter defaultCenter] postNotificationName:GETUSERDATA_NOTIFICATION object:nil];
        
        
    } failure:^(NSError* err){

    }];
}

- (void)reloadBankCard
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/account/index",BASEURL];
    
    NSDictionary *params  = nil;
    
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        id bankCardArray = [respondString objectFromJSONString];
        if ([bankCardArray isMemberOfClass:[NSNull class]]) {
            bankCardArray = [bankCardArray array];
        }
        [datasource removeAllObjects];
        for (NSDictionary *dict in bankCardArray) {
            [datasource addObject:dict];
        }
        if ([datasource count] == 0) {
            UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
            UIImage *noImage = [UIImage imageNamed:@"icon_cry"];
            CGFloat scale = noImage.size.height / noImage.size.width;
            CGFloat imageW = 120;
            CGFloat imageH = imageW * scale;
            CGFloat imageX = (SCREENWIDTH - imageW) / 2.0;
            CGFloat imageY = SCREENHEIGH - imageH - 100;
            UIImageView *imageview = [[UIImageView alloc] initWithImage:noImage];
            imageview.frame = CGRectMake(imageX, imageY, imageW, imageH);
            CGPoint center = bgView.center;
            center.y = center.y - 80;
            imageview.center = center;
            [bgView addSubview:imageview];
            tableview.backgroundView = bgView;
        }
        else{
            tableview.backgroundView = nil;
        }
        if ([datasource count] > 0) {
            bankCarNumLabel.text = [NSString stringWithFormat:@"%ld",[datasource count]];
        }
        else{
            bankCarNumLabel.text = @"0";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableview reloadData];
        });
        
    } failure:^(NSError* err){
        
    }];
}
- (IBAction)backItemClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)explainButtonClick:(id)sender
{
    NSLog(@"explainButtonClick");
}

- (IBAction)addBankCard:(id)sender
{
    NSLog(@"explainButtonClick");
    HeAddBandCardVC *addBankCardVC = [[HeAddBandCardVC alloc] init];
    addBankCardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addBankCardVC animated:YES];
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
    
    static NSString *cellIndentifier = @"HeBankCardCell";
    HeBankCardCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSString *acct_bank = dict[@"acct_bank"];
    if ([acct_bank isMemberOfClass:[NSNull class]] || acct_bank == nil) {
        acct_bank = @"";
    }
    cell.bankNameLabel.text = acct_bank;
    
    NSString *acct_no = dict[@"acct_no"];
    if ([acct_no isMemberOfClass:[NSNull class]] || acct_no == nil) {
        acct_no = @"";
    }
    cell.bankCardLabel.text = [NSString stringWithFormat:@"卡號末6位 : %@",acct_no];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"section = %ld , row = %ld",section,row);
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return TRUE;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        
        if (indexPath.row < [self.datasource count]) {
            
            NSDictionary *dict = nil;
            @try {
                dict = datasource[row];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            NSString *acct_id = dict[@"acct_id"];
            if ([acct_id isMemberOfClass:[NSNull class]] || acct_id == nil) {
                acct_id = @"";
            }
            [datasource removeObjectAtIndex:row];
            bankCarNumLabel.text = [NSString stringWithFormat:@"%ld",[datasource count]];
            [self deleteCardWithNum:acct_id];
            [tableView reloadData];
        }
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"刪除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATEUSERBANKCARD_NOTIFICATION object:nil];
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
