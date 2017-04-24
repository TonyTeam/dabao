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

@interface HeBankCardVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)IBOutlet UILabel *numLabel;
@property(strong,nonatomic)IBOutlet YLButton *addButton;

@end

@implementation HeBankCardVC
@synthesize tableview;
@synthesize numLabel;
@synthesize addButton;

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
    return 10;
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
