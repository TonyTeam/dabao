//
//  HeAddBandCardVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/24.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeAddBandCardVC.h"
#import "FTPopOverMenu.h"
#import "HeBaseTableViewCell.h"
#import "MLLabel+Size.h"
#import "MLLabel.h"
#import "YLButton.h"

@interface HeAddBandCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)YLButton *selectButton;
@property(strong,nonatomic)UITextField *bankUserNameField;
@property(strong,nonatomic)UITextField *bankAccountField;

@end

@implementation HeAddBandCardVC
@synthesize datasource;
@synthesize tableview;
@synthesize selectButton;
@synthesize bankUserNameField;
@synthesize bankAccountField;

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
        label.text = @"添加銀行卡";
        [label sizeToFit];
        self.title = @"添加銀行卡";
        
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
    datasource = @[@"銀行名稱",@"開戶戶名",@"銀行賬號后六位"];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    UIImage *buttonImage = [UIImage imageNamed:@"icon_pill_down"];
    
    CGFloat cellH = 50;
    CGFloat selectButtonX = 72;
    CGFloat selectButtonY = 0;
    CGFloat selectButtonW = SCREENWIDTH - selectButtonX;
    CGFloat selectButtonH = cellH;
    
    CGFloat imageW = 20;
    CGFloat imageH = imageW * buttonImage.size.height / buttonImage.size.width;
    CGFloat imageX = selectButtonW - 10 - imageW;
    CGFloat imageY = (cellH - imageH) / 2.0;
    
    UIFont *buttonFont = [UIFont systemFontOfSize:15.0];
    NSString *buttonTitle = @"請選擇銀行名稱";
    CGFloat titleWidth = [MLLabel getViewSizeByString:buttonTitle maxWidth:imageX - 5 - 10 font:buttonFont lineHeight:1.2f lines:0].width;
    
    selectButton = [[YLButton alloc] initWithFrame:CGRectMake(selectButtonX, selectButtonY, selectButtonW, selectButtonH)];
    [selectButton setTitle:buttonTitle forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectButton setTitleColor:[UIColor colorWithWhite:30.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [selectButton setImage:buttonImage forState:UIControlStateNormal];
    selectButton.titleLabel.font = buttonFont;
    [selectButton setImage:[UIImage imageNamed:@"icon_pull"] forState:UIControlStateSelected];
    selectButton.titleRect = CGRectMake(10, 0, titleWidth, selectButtonH);
    selectButton.imageRect = CGRectMake(imageX, imageY, imageW, imageH);
    
    bankUserNameField = [[UITextField alloc] init];
    bankUserNameField.delegate = self;
    bankUserNameField.font = [UIFont systemFontOfSize:15.0];
    bankUserNameField.placeholder = @"請輸入開戶戶名";
    
    bankAccountField = [[UITextField alloc] init];
    bankAccountField.delegate = self;
    bankAccountField.font = [UIFont systemFontOfSize:15.0];
    bankAccountField.placeholder = @"請輸入銀行賬號后六位";
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    tableview.tableFooterView = footerview;
    
    CGFloat confirmButtonX = 20;
    CGFloat confirmButtonY = 20;
    CGFloat confirmButtonW = SCREENWIDTH - 2 * confirmButtonX;
    CGFloat confirmButtonH = 40;
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmButtonX, confirmButtonY, confirmButtonW, confirmButtonH)];
    [confirmButton setTitle:@"確認綁定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[Tool buttonImageFromColor:[UIColor colorWithRed:254.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] withImageSize:confirmButton.frame.size] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 8.0;
    confirmButton.layer.masksToBounds = YES;
    [footerview addSubview:confirmButton];
}

- (void)confirmButtonClick:(UIButton *)button
{
    NSLog(@"confirmButtonClick");
}

- (void)selectButtonClick:(UIButton *)button
{
    button.selected = YES;
    NSLog(@"selectButtonClick");
    
    NSArray *bankArray = @[@"農業銀行",@"工商銀行",@"建設銀行",@"農業銀行",@"工商銀行",@"建設銀行"];
    [FTPopOverMenu showForSender:button
                        withMenu:bankArray
                  imageNameArray:nil
                       doneBlock:^(NSInteger selectedIndex) {
                           NSString *buttonTitle = bankArray[selectedIndex];
                           [button setTitle:buttonTitle forState:UIControlStateNormal];
                           button.selected = NO;
                           [tableview reloadData];
                           
                       } dismissBlock:^{
                           button.selected = NO;
                           NSLog(@"user canceled. do nothing.");
                           
                       }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    CGSize titleszie = [MLLabel getViewSizeByString:datasource[row] maxWidth:(SCREENWIDTH - 20) / 2.0 font:[UIFont systemFontOfSize:15.0] lineHeight:1.2f lines:0];
    
    switch (row) {
        case 0:
        {
            [cell addSubview:selectButton];
            break;
        }
        case 1:
        {
            bankUserNameField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
            [cell addSubview:bankUserNameField];
            
            break;
        }
        case 2:
        {
            bankAccountField.frame = CGRectMake(titleszie.width + 20, 0, (SCREENWIDTH - titleszie.width - 30), cellH);
            [cell addSubview:bankAccountField];
            
            break;
        }
            
        default:
            break;
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
