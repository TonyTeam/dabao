//
//  HeDCoinDetailVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeDCoinDetailVC.h"
#import "HeDCoinStoreCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"

@interface HeDCoinDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex;
    NSInteger pageSize;
}
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *datasource;

@end

@implementation HeDCoinDetailVC
@synthesize datasource;
@synthesize tableview;

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
        label.text = @"D幣明細";
        [label sizeToFit];
        self.title = @"D幣明細";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadIngot];
}

- (void)initializaiton
{
    [super initializaiton];
    datasource = [[NSMutableArray alloc] initWithCapacity:0];
    pageSize = 50;
    pageIndex = 1;
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block,刷新
        pageIndex = 1;
        [self.tableview.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
        [self loadIngot];
        
    }];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        pageIndex++;
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
            
    }];
}

- (void)endRefreshing
{
    [self.tableview.footer endRefreshing];
    self.tableview.footer.hidden = YES;
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.tableview.footer.automaticallyHidden = YES;
        self.tableview.footer.hidden = NO;
        // 进入刷新状态后会自动调用这个block，加载更多
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
        [self loadIngot];
    }];
    NSLog(@"endRefreshing");
}

- (void)loadIngot
{
    [self showHudInView:tableview hint:@"加載中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/order/index",BASEURL];
    
    NSString *page = [NSString stringWithFormat:@"%ld",pageIndex];
    NSString *size = [NSString stringWithFormat:@"%ld",pageSize];
    NSString *biz = @"ingot";
    NSDictionary *params  = @{@"page":page,@"size":size,@"biz":biz};
    
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
        
        
        id orderArray = [respondString objectFromJSONString];
        if ([orderArray isKindOfClass:[NSArray class]]) {
            if (pageIndex == 1) {
                [datasource removeAllObjects];
                for (NSDictionary *dict in orderArray) {
                    [datasource addObject:dict];
                }
            }
            else{
                for (NSDictionary *dict in orderArray) {
                    [datasource addObject:dict];
                }
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableview reloadData];
            });
        }
        else{
            [self showHint:@"暫無記錄"];
        }
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
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
    static NSString *cellIndentifier = @"HeDCoinStoreCell";
    HeDCoinStoreCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeDCoinStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSString *er = dict[@"er"];
    if ([er isMemberOfClass:[NSNull class]] || er == nil) {
        er = @"";
    }
    cell.exchangeRateLabel.text = [NSString stringWithFormat:@"當天匯率: %@",er];
    
    id amountObj = dict[@"amount"];
    if ([amountObj isMemberOfClass:[NSNull class]] || amountObj == nil) {
        amountObj = @"";
    }
    cell.dcoinLabel.text = [NSString stringWithFormat:@"需支付台幣: %@",amountObj];
    
    NSString *created_at = dict[@"created_at"];
    if ([created_at isMemberOfClass:[NSNull class]]) {
        created_at = @"";
    }
    cell.timeLabel.text = created_at;
    
    NSString *pay_status_name = dict[@"status_name"];
    if ([pay_status_name isMemberOfClass:[NSNull class]]) {
        pay_status_name = @"";
    }
    cell.statusLabel.text = pay_status_name;
    
    NSString *pay_status_style = dict[@"pay_status_style"];
    if ([pay_status_style isMemberOfClass:[NSNull class]]) {
        pay_status_style = @"";
    }
    if ([pay_status_style compare:@"success" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        cell.statusLabel.textColor = [UIColor greenColor];
    }
    id biz_rmb = dict[@"biz_rmb"];
    if ([biz_rmb isMemberOfClass:[NSNull class]]) {
        biz_rmb = @"";
    }
    cell.coinLabel.text = [NSString stringWithFormat:@"+%@",biz_rmb];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    CGFloat titleLabelX = 10;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = SCREENWIDTH - 2 * titleLabelX;
    CGFloat titleLabelH = 30;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.text = @"當前D幣儲值訂單詳情";
    titleLabel.textColor = [UIColor blackColor];
    [headerview addSubview:titleLabel];
    
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"section = %ld , row = %ld",section,row);
    
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    HeOrderVC *orderDetailVC = [[HeOrderVC alloc] init];
    orderDetailVC.orderType = 1;
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    orderDetailVC.orderDetailDict = [[NSDictionary alloc] initWithDictionary:dict];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    id status = dict[@"status"];
    if ([status isMemberOfClass:[NSNull class]]) {
        status = @"";
    }
    if ([status isEqualToString:@"closed"]) {
        return NO;
    }
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
            
            __weak HeDCoinDetailVC *weakSelf = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"溫馨提示" message:@"是否確定關閉該訂單，該操作不可撤銷!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }];
            [alertController addAction:cancelaction];
            
            UIAlertAction *confirmaction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSDictionary *dict = nil;
                @try {
                    dict = datasource[row];
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
                id status = dict[@"status"];
                if ([status isMemberOfClass:[NSNull class]]) {
                    status = @"";
                }
                if ([status isEqualToString:@"closed"]) {
                    [weakSelf showHint:@"該交易已關閉，無法刪除"];
                    return ;
                }
                
                NSString *oid = dict[@"oid"];
                if ([oid isMemberOfClass:[NSNull class]] || oid == nil) {
                    oid = @"";
                }
                [weakSelf deleteOrderWithOid:oid];
            }];
            [alertController addAction:confirmaction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        
    }
    
}


- (void)deleteOrderWithOid:(NSString *)oid
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/order/close",BASEURL];
    
    NSDictionary *params  = @{@"oid":oid};
    
    __weak HeDCoinDetailVC *weakSelf = self;
    [self showHudInView:self.tableview hint:@"關閉交易中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
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
                [weakSelf showHint:errorString];
            }
        }
        [weakSelf loadIngot];
        
        
    } failure:^(NSError* err){
        
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"刪除";
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
