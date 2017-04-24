//
//  HeOrderRecordVC.m
//  beautyContest
//
//  Created by Tony on 2017/4/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeOrderRecordVC.h"
#import "MLLabel+Size.h"
#import "MLLabel.h"
#import "HeOrderCell.h"

@interface HeOrderRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)IBOutlet UISegmentedControl *segmentControl;
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *datasource;

@end

@implementation HeOrderRecordVC
@synthesize segmentControl;
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
    
    CGRect frame= segmentControl.frame;
    CGFloat fNewHeight = 50.0;
    [segmentControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, fNewHeight)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    CGRect frame= segmentControl.frame;
    CGFloat fNewHeight = 40.0;
    [segmentControl setFrame:CGRectMake(frame.origin.x, 50, frame.size.width, fNewHeight)];
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
    
    CGRect frame= segmentControl.frame;
    segmentControl.layer.cornerRadius = 5.0;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.autoresizesSubviews = YES;
    
    CGFloat fNewHeight = 40.0;
    [segmentControl setFrame:CGRectMake(frame.origin.x, 50, frame.size.width, fNewHeight)];
}

- (IBAction)segmentChange:(UISegmentedControl *)sender
{
    NSLog(@"segmentChange");
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
    
    static NSString *cellIndentifier = @"HeOrderCell";
    HeOrderCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
