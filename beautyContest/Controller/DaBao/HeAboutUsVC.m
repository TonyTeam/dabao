//
//  HeAboutUsVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeAboutUsVC.h"
#import "HeBaseTableViewCell.h"

@interface HeAboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;

@end

@implementation HeAboutUsVC
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
        label.text = @"關於大寶";
        [label sizeToFit];
        self.title = @"關於大寶";
        
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
    datasource = @[@"版本信息號",@"客服電話"];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    CGFloat headerViewX = 0;
    CGFloat headerViewY = 0;
    CGFloat headerViewW = SCREENWIDTH;
    CGFloat headerViewH = 150;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(headerViewX, headerViewY, headerViewW, headerViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableview.tableHeaderView = headerView;
    
    CGFloat imageIconW = 50;
    CGFloat imageIconH = 50;
    CGFloat imageIconX = (headerViewW - imageIconW) / 2.0;
    CGFloat imageIconY = (headerViewH - imageIconH) / 2.0 - 20;
    
    
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(imageIconX, imageIconY, imageIconW, imageIconH)];
    imageIcon.image = [UIImage imageNamed:@"appIcon"];
    imageIcon.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:imageIcon];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageIcon.frame) + 20, headerViewW, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"大寶";
    nameLabel.font = [UIFont systemFontOfSize:17.0];
    nameLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [headerView addSubview:nameLabel];
    
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
    
    static NSString *cellIndentifier = @"HeBaseTableViewCell";
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (SCREENWIDTH - 20) / 2.0, cellH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = datasource[row];
    titleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:titleLabel];
    
    if (row == 1) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 160, 0, 150, cellH)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.text = [Tool getAppVersion];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.textColor = [UIColor grayColor];
        [cell addSubview:contentLabel];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    return headerview;
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
