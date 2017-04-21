//
//  HeUserVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeUserVC.h"
#import "HeBaseTableViewCell.h"
#import "HeBankCardVC.h"
#import "HeNoticeVC.h"
#import "HeSecurityVC.h"
#import "HeAboutUsVC.h"
#import "HeSetUpVC.h"
#import "HeDCoinStoreVC.h"
#import "HeDCoinDetailVC.h"

@interface HeUserVC ()<UITableViewDelegate,UITableViewDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)NSArray *icon_datasource;
@property(strong,nonatomic)IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)IBOutlet UILabel *nickLabel;
@property(strong,nonatomic)IBOutlet UIImageView *userImage;
@property(strong,nonatomic)IBOutlet UIView *bgView;
@property(strong,nonatomic)IBOutlet UIButton *facebookButton;

@end

@implementation HeUserVC
@synthesize tableview;
@synthesize datasource;
@synthesize icon_datasource;
@synthesize nameLabel;
@synthesize nickLabel;
@synthesize userImage;
@synthesize bgView;
@synthesize facebookButton;

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
        label.text = @"我的大寶";
        [label sizeToFit];
        self.title = @"我的大寶";
        
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
    datasource = @[@[@"消息通知",@"賬戶安全",@"關於大寶"],@[@"設置"]];
    icon_datasource = @[@[@"icon_notice",@"icon_security",@"icon_about"],@[@"icon_setup"]];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.frame.size.width / 2.0;
    
    facebookButton.layer.masksToBounds = YES;
    facebookButton.layer.cornerRadius = 3.0;
    
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
}

- (IBAction)relateFackBook:(id)sender
{
    NSLog(@"relateFackBook");
}

//D幣儲值
- (IBAction)storeDCointDetail:(id)sender
{
    HeDCoinStoreVC *coinStoreVC = [[HeDCoinStoreVC alloc] init];
    coinStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coinStoreVC animated:YES];
}
//瀏覽儲值記錄
- (IBAction)scanStoreDCointDetail:(id)sender
{
    HeDCoinDetailVC *coinDetailVC = [[HeDCoinDetailVC alloc] init];
    coinDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coinDetailVC animated:YES];
}
//查看銀行卡
- (IBAction)scanBankCard:(id)sender
{
    HeBankCardVC *bankCardVC = [[HeBankCardVC alloc] init];
    bankCardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bankCardVC animated:YES];
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
    NSDictionary *dict = nil;
    @try {
        dict = datasource[row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    CGFloat iconImageX = 10;
    CGFloat iconImageY = 15;
    CGFloat iconImageH = cellH - 2 * iconImageY;
    CGFloat iconImageW = iconImageH;
    
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon_datasource[section][row]]];
    iconImage.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    [cell addSubview:iconImage];
    
    CGFloat titleLabelX = CGRectGetMaxX(iconImage.frame) + 8;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = SCREENWIDTH - 10 - titleLabelX;
    CGFloat titleLabelH = cellH;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
    [cell addSubview:titleLabel];
    titleLabel.text = datasource[section][row];
    
    UIImageView *icon_gray_choose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gray_choose"]];
    icon_gray_choose.contentMode = UIViewContentModeScaleAspectFit;
    icon_gray_choose.layer.masksToBounds = YES;
    icon_gray_choose.frame = CGRectMake(SCREENWIDTH - 30, (cellH - 20) / 2.0, 20, 20);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryView = icon_gray_choose;
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];

    
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"section = %ld , row = %ld",section,row);
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    HeNoticeVC *noticeVC = [[HeNoticeVC alloc] init];
                    noticeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:noticeVC animated:YES];
                    break;
                }
                case 1:
                {
                    HeSecurityVC *securityVC = [[HeSecurityVC alloc] init];
                    securityVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:securityVC animated:YES];
                    break;
                }
                case 2:
                {
                    HeAboutUsVC *aboutVC = [[HeAboutUsVC alloc] init];
                    aboutVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutVC animated:YES];
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
                    HeSetUpVC *setupVC = [[HeSetUpVC alloc] init];
                    setupVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setupVC animated:YES];
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
