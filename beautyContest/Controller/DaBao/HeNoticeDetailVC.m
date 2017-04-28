//
//  HeNoticeDetailVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/24.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeNoticeDetailVC.h"

@interface HeNoticeDetailVC ()<UIWebViewDelegate>
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)IBOutlet UILabel *timeLabel;
@property(strong,nonatomic)IBOutlet UIWebView *contentWebView;


@end

@implementation HeNoticeDetailVC
@synthesize noticeDict;
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize contentWebView;

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
        label.text = @"消息詳情";
        [label sizeToFit];
        self.title = @"消息詳情";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadNoticeDetail];
}

- (void)initializaiton
{
    [super initializaiton];
}

- (void)initView
{
    [super initView];
    
    NSString *post_title = noticeDict[@"post_title"];
    if ([post_title isMemberOfClass:[NSNull class]] || post_title == nil) {
        post_title = @"";
    }
    titleLabel.text = post_title;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = APPDEFAULTTITLETEXTFONT;
    label.textColor = APPDEFAULTTITLECOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = post_title;
    [label sizeToFit];
    self.title = post_title;
    
    
    
    id zoneCreatetimeObj = [noticeDict objectForKey:@"created_at"];
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
    timeLabel.text = time;

    
}

- (void)loadNoticeDetail
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/post/view",BASEURL];
    NSString *noticeId = noticeDict[@"post_id"];
    if ([noticeId isMemberOfClass:[NSNull class]] || noticeId == nil) {
        noticeId = @"";
    }
    NSDictionary *params  = @{@"id":noticeId};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [respondString objectFromJSONString];
        NSString *error = dict[@"error"];
        if (error) {
            [self showHint:error];
            return ;
        }
        noticeDict = [[NSDictionary alloc] initWithDictionary:dict];
        NSString *post_content = noticeDict[@"post_content"];
        if ([post_content isMemberOfClass:[NSNull class]] || post_content == nil) {
            post_content = @"";
        }
        [contentWebView loadHTMLString:post_content baseURL:nil];
        
    } failure:^(NSError* err){
        
    }];
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
