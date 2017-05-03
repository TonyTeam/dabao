//
//  HeNoticeVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeNoticeVC.h"
#import "HeNoticeDetailVC.h"
#import "HeNoticeCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"

@interface HeNoticeVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *datasource;

@end

@implementation HeNoticeVC
@synthesize tableview;
@synthesize datasource;

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
        label.text = @"消息通知";
        [label sizeToFit];
        self.title = @"消息通知";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadNotice];
}

- (void)initializaiton
{
    [super initializaiton];
    datasource = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block,刷新
        [self.tableview.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
        [self loadNotice];
        
    }];
}

- (void)loadNotice
{
    [self showHudInView:tableview hint:@"加載中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/post/anncs",BASEURL];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableview reloadData];
        });
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)updateNotice
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/post/anncs",BASEURL];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableview reloadData];
        });
        
    } failure:^(NSError* err){
        
    }];
}

- (void)markNoticeReadWithNoticeId:(NSString *)noticeId
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/post/read",BASEURL];
    
    NSDictionary *params  = @{@"id":noticeId};
    __weak HeNoticeVC *weakSelf = self;
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        [weakSelf updateNotice];
        
    } failure:^(NSError* err){
        
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
    
    static NSString *cellIndentifier = @"HeBankCardCell";
    HeNoticeCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSString *post_title = dict[@"post_title"];
    if ([post_title isMemberOfClass:[NSNull class]] || post_title == nil) {
        post_title = @"";
    }
    cell.titleLabel.text = post_title;
    
    id zoneCreatetimeObj = [dict objectForKey:@"created_at"];
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
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",time];
    
    BOOL post_read = [dict[@"post_read"] boolValue];
    if (post_read) {
        cell.statusLabel.text = @"已讀";
    }
    else{
        cell.statusLabel.text = @"未讀";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    NSString *post_id = dict[@"post_id"];
    if ([post_id isMemberOfClass:[NSNull class]] || post_id == nil) {
        post_id = @"";
    }
    BOOL post_read = [dict[@"post_read"] boolValue];
    if (!post_read) {
        [self markNoticeReadWithNoticeId:post_id];
    }
    
    HeNoticeDetailVC *noticeDetailVC = [[HeNoticeDetailVC alloc] init];
    noticeDetailVC.noticeDict = [[NSDictionary alloc] initWithDictionary:dict];
    noticeDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
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
