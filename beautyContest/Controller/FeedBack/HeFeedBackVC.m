//
//  HeFeedBackVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/15.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeFeedBackVC.h"
#import "HeBaseTableViewCell.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"
#import "FTPopOverMenu.h"
#import "SAMTextView.h"
#import "YLButton.h"

@interface HeFeedBackVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *datasource;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)SAMTextView *textView;

@end

@implementation HeFeedBackVC
@synthesize tableview;
@synthesize datasource;
@synthesize titleLabel;
@synthesize textView;

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
        label.text = @"問題反饋";
        [label sizeToFit];
        self.title = @"問題反饋";
        
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
    
    NSArray *menuArray = @[@"由中华环保基金会、中国扶贫基金会主办",@"清华大学环境学院协办",@"一汽-大众出资的第二届“迈向生态文明  向环保先锋致敬”环保公益资助计划"];
    datasource = [[NSMutableArray alloc] initWithArray:menuArray];
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 6.0;
    
    CGFloat footerviewX = 0;
    CGFloat footerviewY = 0;
    CGFloat footerviewW = SCREENWIDTH;
    CGFloat footerviewH = 300;
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(footerviewX, footerviewY, footerviewW, footerviewH)];
    footerview.backgroundColor = [UIColor whiteColor];
    tableview.tableFooterView = footerview;
    
    CGFloat tipLabelX = 15;
    CGFloat tipLabelY = 10;
    CGFloat tipLabelW = SCREENWIDTH - 2 * tipLabelX;
    CGFloat tipLabelH = 30;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, tipLabelH)];
    tipLabel.text = @"請簡短且清晰的告訴我們問題是怎樣發生的?";
    tipLabel.font = [UIFont systemFontOfSize:15.0];
    [tipLabel sizeToFit];
    tipLabel.textColor = [UIColor blackColor];
    [footerview addSubview:tipLabel];
    
    CGFloat textViewX = 10;
    CGFloat textViewY = CGRectGetMaxY(tipLabel.frame) + 15;
    CGFloat textViewW = SCREENWIDTH - 2 * textViewX;
    CGFloat textViewH = 180;
    
    textView = [[SAMTextView alloc] initWithFrame:CGRectMake(textViewX, textViewY, textViewW, textViewH)];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8.0;
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.placeholder = @"請輸入超過十個字以上的內容，我們會在查明後盡快修正，并協助您解決問題";
    textView.delegate = self;
    [footerview addSubview:textView];
    
    CGFloat historyButtonX = textViewX;
    CGFloat historyButtonY = CGRectGetMaxY(textView.frame) + 10;
    CGFloat historyButtonW = 80;
    CGFloat historyButtonH = 30;
    
    UIFont *buttonFont = [UIFont systemFontOfSize:14.0];
    
    UIButton *historyButton = [[UIButton alloc] initWithFrame:CGRectMake(historyButtonX, historyButtonY, historyButtonW, historyButtonH)];
    [historyButton setTitle:@"歷史問題" forState:UIControlStateNormal];
    [historyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    historyButton.titleLabel.font = buttonFont;
    [historyButton addTarget:self action:@selector(feedBackButtClick:) forControlEvents:UIControlEventTouchUpInside];
    historyButton.tag = 1;
    historyButton.layer.cornerRadius = 5.0;
    historyButton.layer.borderWidth = 1.0;
    historyButton.layer.borderColor = [UIColor grayColor].CGColor;
    historyButton.layer.masksToBounds = YES;
    
    [footerview addSubview:historyButton];
    
    UIButton *feedBackButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - historyButtonX - historyButtonW, historyButtonY, historyButtonW, historyButtonH)];
    [feedBackButton setTitle:@"回報問題" forState:UIControlStateNormal];
    [feedBackButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    feedBackButton.tag = 2;
    feedBackButton.layer.cornerRadius = 5.0;
    feedBackButton.layer.borderWidth = 1.0;
    feedBackButton.layer.borderColor = [UIColor grayColor].CGColor;
    feedBackButton.layer.masksToBounds = YES;
    
    feedBackButton.titleLabel.font = buttonFont;
    [feedBackButton addTarget:self action:@selector(feedBackButtClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:feedBackButton];
}

- (void)feedBackButtClick:(UIButton *)button
{
    NSLog(@"feedBackButtClick");
    if (button.tag == 1) {
        NSLog(@"歷史問題");
    }
    else{
        NSLog(@"回報問題");
    }
}

- (void)selectButtonClick:(UIButton *)button
{
    button.selected = YES;
    NSLog(@"selectButtonClick");
    
    [FTPopOverMenu showForSender:button
                        withMenu:datasource
                  imageNameArray:nil
                       doneBlock:^(NSInteger selectedIndex) {
                           NSString *buttonTitle = datasource[selectedIndex];
                           [button setTitle:buttonTitle forState:UIControlStateNormal];
                           button.selected = NO;
                           [tableview reloadData];
                           
                       } dismissBlock:^{
                           button.selected = NO;
                           NSLog(@"user canceled. do nothing.");
                           
                       }];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)mytextView
{
    if ([mytextView isFirstResponder]) {
        [mytextView resignFirstResponder];
    }
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    
    static NSString *cellIndentifier = @"HeDCoinStoreCell";
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    
    
    if (row == 0) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"icon_pill_down"];
        
        CGFloat selectButtonX = 0;
        CGFloat selectButtonY = 0;
        CGFloat selectButtonW = SCREENWIDTH;
        CGFloat selectButtonH = cellH;
        
        CGFloat imageW = 20;
        CGFloat imageH = imageW * buttonImage.size.height / buttonImage.size.width;
        CGFloat imageX = selectButtonW - 10 - imageW;
        CGFloat imageY = (cellH - imageH) / 2.0;
        
        UIFont *buttonFont = [UIFont systemFontOfSize:15.0];
        NSString *buttonTitle = datasource[section];
        CGFloat titleWidth = [MLLabel getViewSizeByString:buttonTitle maxWidth:imageX - 5 - 10 font:buttonFont lineHeight:1.2f lines:0].width;
        
        YLButton *selectButton = [[YLButton alloc] initWithFrame:CGRectMake(selectButtonX, selectButtonY, selectButtonW, selectButtonH)];
        [selectButton setTitle:buttonTitle forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton setTitleColor:[UIColor colorWithWhite:30.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [selectButton setImage:buttonImage forState:UIControlStateNormal];
        selectButton.titleLabel.font = buttonFont;
        [selectButton setImage:[UIImage imageNamed:@"icon_pull"] forState:UIControlStateSelected];
        selectButton.titleRect = CGRectMake(10, 0, titleWidth, selectButtonH);
        selectButton.imageRect = CGRectMake(imageX, imageY, imageW, imageH);
        
        
        [cell addSubview:selectButton];
    }
    else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, cellH)];
        bgView.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        [cell addSubview:bgView];
        CGFloat contentLabelX = 10;
        CGFloat contentLabelY = 10;
        CGFloat contentLabelW = SCREENWIDTH - 2 * contentLabelX;
        CGFloat contentLabelH = 0;
        
        NSString *content = @"【别人家的食堂！不但有“鸟笼”式包间，还能点歌演唱】近日，位于郑州市的华北水利水电大学二区食堂二楼装修完毕，清新的鸟笼式装修风格引来众多高校大学生围观。除了鸟笼式造型的包间，在这个另类餐厅里还有一个小型舞台，同学们可以在舞台点歌、演唱。L秒拍视频 （中国青年报） ​​​​";
        UIFont *contentFont = [UIFont systemFontOfSize:14.0];
        CGFloat maxWidth = contentLabelW;
        
        CGSize contentsize = [MLLabel getViewSizeByString:content maxWidth:maxWidth font:contentFont lineHeight:1.2f lines:0];
        contentLabelH = contentsize.height;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = contentFont;
        contentLabel.numberOfLines = 0;
        contentLabel.text = content;
        contentLabel.textColor = APPDEFAULTORANGE;
        [cell addSubview:contentLabel];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (row == 0) {
        return 50;
    }
    CGFloat contentLabelX = 10;
    CGFloat contentLabelY = 10;
    CGFloat contentLabelW = SCREENWIDTH - 2 * contentLabelX;
    CGFloat contentLabelH = 0;
    
    NSString *content = @"【别人家的食堂！不但有“鸟笼”式包间，还能点歌演唱】近日，位于郑州市的华北水利水电大学二区食堂二楼装修完毕，清新的鸟笼式装修风格引来众多高校大学生围观。除了鸟笼式造型的包间，在这个另类餐厅里还有一个小型舞台，同学们可以在舞台点歌、演唱。L秒拍视频 （中国青年报） ​​​​";
    UIFont *contentFont = [UIFont systemFontOfSize:14.0];
    CGFloat maxWidth = contentLabelW;
    
    CGSize contentsize = [MLLabel getViewSizeByString:content maxWidth:maxWidth font:contentFont lineHeight:1.2f lines:0];
    contentLabelH = contentsize.height;
    
    return contentLabelH + 2 * contentLabelY;
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
