//
//  HeSecurityVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeSecurityVC.h"
#import "HeBaseTableViewCell.h"
#import "HeForGetPasswordVC.h"
#import "HeModifyPayPasswordVC.h"

@interface HeSecurityVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;

@end

@implementation HeSecurityVC
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
        label.text = @"賬戶安全";
        [label sizeToFit];
        self.title = @"賬戶安全";
        
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
    datasource = @[@[@"綁定手機號"],@[@"登錄密碼",@"支付密碼"]];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datasource[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datasource count];
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
    titleLabel.text = datasource[section][row];
    titleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:titleLabel];
    
    if (section == 0 && row == 0) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 160, 0, 150, cellH)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.text = @"0***999";
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:contentLabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (section != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    
    
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
    switch (section) {
        case 1:
        {
            switch (row) {
                case 0:
                {
                    HeForGetPasswordVC *forgetPasswordVC = [[HeForGetPasswordVC alloc] init];
                    forgetPasswordVC.modifyType = 1; //修改密碼
                    forgetPasswordVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
                    break;
                }
                case 1:
                {
                    HeModifyPayPasswordVC *modifyPayPasswordVC = [[HeModifyPayPasswordVC alloc] init];
                    modifyPayPasswordVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:modifyPayPasswordVC animated:YES];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
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
