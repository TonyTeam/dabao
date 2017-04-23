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
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;

@end

@implementation HeOrderVC
@synthesize tableview;
@synthesize dCoinValueLabel;
@synthesize datasource;
@synthesize titleLabel;

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
    datasource = @[@"訂單狀態",@"訂單號",@"付款方式",@"收款賬號",@"付款金額",@"創建時間"];
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
    CGSize contentsize = [MLLabel getViewSizeByString:contentString maxWidth:tipLabelW font:contentFont lineHeight:1.2f lines:0];
    tipLabelH = contentsize.height;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, tipLabelH)];
    tipLabel.numberOfLines = 0;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = contentFont;
    tipLabel.textColor = [UIColor colorWithWhite:30 / 255.0 alpha:1.0];
    [footerview addSubview:tipLabel];
    
    CGFloat backButtonX = 20;
    CGFloat backButtonY = CGRectGetMaxY(tipLabel.frame) + 20;
    CGFloat backButtonW = SCREENWIDTH - 2 * backButtonX;
    CGFloat backButtonH = 40;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:backButton];
    
    [backButton setBackgroundImage:[Tool buttonImageFromColor:[UIColor colorWithRed:250.0 / 255.0 green:49.0 / 255.0 blue:43.0 / 255.0 alpha:1.0] withImageSize:backButton.frame.size] forState:UIControlStateNormal];
    
}

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    headerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    
    CGFloat titleLabelX = 10;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = SCREENWIDTH - 2 * titleLabelX;
    CGFloat titleLabelH = 30;
    
    UILabel *mytitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    mytitleLabel.backgroundColor = [UIColor clearColor];
    mytitleLabel.font = [UIFont systemFontOfSize:12.0];
    mytitleLabel.text = @"當前D幣儲值訂單詳情";
    mytitleLabel.textColor = [UIColor blackColor];
    [headerview addSubview:mytitleLabel];
    
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
