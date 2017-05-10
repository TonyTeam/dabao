//
//  HeNoticeVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeHistoryVC.h"
#import "HeFeedBackReplyVC.h"
#import "HeHistoryFeedBackCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"

@interface HeHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *datasource;

@end

@implementation HeHistoryVC
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
        label.text = @"歷史問題";
        [label sizeToFit];
        self.title = @"歷史問題";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadHistoryFeedBack];
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
        [self loadHistoryFeedBack];
        
    }];
}

- (void)loadHistoryFeedBack
{
    [self showHudInView:tableview hint:@"加載中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/comment/index",BASEURL];
    
    NSDictionary *params  = nil;
    
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
        
        id replyArray = [respondString objectFromJSONString];
        if ([replyArray isMemberOfClass:[NSNull class]]) {
            replyArray = [NSArray array];
        }
        [datasource removeAllObjects];
        for (NSDictionary *dict in replyArray) {
            [datasource addObject:dict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableview reloadData];
        });
        
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
    CGFloat cellH = cellsize.height;
    
    static NSString *cellIndentifier = @"HeHistoryFeedBackCell";
    HeHistoryFeedBackCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeHistoryFeedBackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    NSString *comment_id = dict[@"comment_id"];
    if ([comment_id isMemberOfClass:[NSNull class]] || comment_id == nil) {
        comment_id = @"";
    }
    cell.feedBackIDLabel.text = [NSString stringWithFormat:@"問題ID : %@",comment_id];
    
    NSString *created_at = dict[@"created_at"];
    if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
        created_at = @"";
    }
    
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
    
    cell.feedBackTimeLabel.text = [NSString stringWithFormat:@"提交時間 : %@",time];
    
    NSString *comment_content = dict[@"comment_content"];
    if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
        comment_content = @"";
    }

    cell.feedBackContentLabel.text = [NSString stringWithFormat:@"%@",comment_content];
    
    
    
    
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
    NSDictionary *replyDict = datasource[row];
    HeFeedBackReplyVC *feedBackReplyVC = [[HeFeedBackReplyVC alloc] init];
    feedBackReplyVC.comment_id = [NSString stringWithFormat:@"%@",replyDict[@"comment_id"]];
    feedBackReplyVC.lastestReplyDict = [[NSDictionary alloc] initWithDictionary:replyDict];
    feedBackReplyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedBackReplyVC animated:YES];
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
