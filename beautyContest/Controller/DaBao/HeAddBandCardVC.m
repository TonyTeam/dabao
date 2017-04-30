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

#define ALERTTAG 200

@interface HeAddBandCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSInteger currentSelectIndex;
}
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)YLButton *selectButton;
@property(strong,nonatomic)UITextField *bankUserNameField;
@property(strong,nonatomic)UITextField *bankAccountField;
@property(strong,nonatomic)UIView *dismissView;
@property(strong,nonatomic)NSMutableArray *bankArray;

@end

@implementation HeAddBandCardVC
@synthesize datasource;
@synthesize tableview;
@synthesize selectButton;
@synthesize bankUserNameField;
@synthesize bankAccountField;
@synthesize dismissView;
@synthesize bankArray;

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
    
    currentSelectIndex = -1;
    
    NSString *bankJson = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankJson" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    datasource = [[bankJson objectFromJSONString] objectForKey:@"bank"];
    
    bankArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dict in datasource) {
        NSString *name = dict[@"name"];
        if ([name isMemberOfClass:[NSNull class]] || name == nil) {
            name = @"";
        }
        [bankArray addObject:name];
    }
}

- (void)initView
{
    [super initView];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height)];
    dismissView.backgroundColor = [UIColor blackColor];
    dismissView.hidden = YES;
    dismissView.alpha = 0.7;
    [self.view addSubview:dismissView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewGes:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [dismissView addGestureRecognizer:tapGes];
    
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

- (void)dismissViewGes:(UITapGestureRecognizer *)ges
{
    
    UIView *mydismissView = ges.view;
    mydismissView.hidden = YES;
    
    UIView *alertview = [self.view viewWithTag:ALERTTAG];
    
    [alertview removeFromSuperview];
}

- (void)confirmButtonClick:(UIButton *)button
{
    if (currentSelectIndex == -1) {
        [self showHint:@"請選擇銀行"];
        return;
    }
    NSLog(@"confirmButtonClick");
    NSString *requestUrl = [NSString stringWithFormat:@"%@/account/send-bank-captcha",BASEURL];
    
    NSDictionary * params  = nil;
    [self showHudInView:self.view hint:@"發送中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        [self showHint:@"驗證碼發送成功"];
        [self performSelector:@selector(inputVerifyCode) withObject:nil afterDelay:0.2];
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)selectButtonClick:(UIButton *)button
{
    button.selected = YES;
    NSLog(@"selectButtonClick");
    
    
    [FTPopOverMenu showForSender:button
                        withMenu:bankArray
                  imageNameArray:nil
                       doneBlock:^(NSInteger selectedIndex) {
                           currentSelectIndex = selectedIndex;
                           NSString *buttonTitle = bankArray[selectedIndex];
                           [button setTitle:buttonTitle forState:UIControlStateNormal];
                           button.selected = NO;
                           [tableview reloadData];
                           
                       } dismissBlock:^{
                           button.selected = NO;
                           NSLog(@"user canceled. do nothing.");
                           
                       }];
}


- (void)inputVerifyCode
{
    [self.view addSubview:dismissView];
    dismissView.hidden = NO;
 
    CGFloat viewX = 10;
    CGFloat viewY = 50;
    CGFloat viewW = SCREENWIDTH - 2 * viewX;
    CGFloat viewH = 150;
    UIView *shareAlert = [[UIView alloc] init];
    shareAlert.frame = CGRectMake(viewX, viewY, viewW, viewH);
    shareAlert.backgroundColor = [UIColor whiteColor];
    shareAlert.layer.cornerRadius = 5.0;
    shareAlert.layer.borderWidth = 0;
    shareAlert.layer.masksToBounds = YES;
    shareAlert.tag = ALERTTAG;
    shareAlert.layer.borderColor = [UIColor clearColor].CGColor;
    shareAlert.userInteractionEnabled = YES;
    
    CGFloat labelH = 40;
    CGFloat labelY = 0;
    
    UIFont *shareFont = [UIFont systemFontOfSize:15.0];
    
    UILabel *messageTitleLabel = [[UILabel alloc] init];
    messageTitleLabel.font = shareFont;
    messageTitleLabel.textColor = [UIColor blackColor];
    messageTitleLabel.textAlignment = NSTextAlignmentCenter;
    messageTitleLabel.backgroundColor = [UIColor clearColor];
    messageTitleLabel.text = @"支付密码";
    messageTitleLabel.frame = CGRectMake(0, 0, viewW, labelH);
    [shareAlert addSubview:messageTitleLabel];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logoImage"]];
    logoImage.frame = CGRectMake(20, 5, 30, 30);
    [shareAlert addSubview:logoImage];
    
    
    labelY = labelY + labelH + 10;
    UITextField *textview = [[UITextField alloc] init];
    textview.tag = 10;
    textview.secureTextEntry = YES;
    textview.backgroundColor = [UIColor whiteColor];
    textview.tintColor= [UIColor blueColor];
    textview.placeholder = @"請輸入驗證碼";
    textview.font = shareFont;
    textview.delegate = self;
    textview.frame = CGRectMake(10, labelY, shareAlert.frame.size.width - 20, labelH);
    textview.layer.borderWidth = 1.0;
    textview.layer.cornerRadius = 5.0;
    textview.layer.masksToBounds = YES;
    textview.layer.borderColor = [UIColor colorWithWhite:0xcc / 255.0 alpha:1.0].CGColor;
    [shareAlert addSubview:textview];
    
    CGFloat buttonDis = 10;
    CGFloat buttonW = (viewW - 3 * buttonDis) / 2.0;
    CGFloat buttonH = 40;
    CGFloat buttonY = labelY = labelY + labelH + 10;
    CGFloat buttonX = 10;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [shareButton setTitle:@"确定" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(alertbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag = 1;
    [shareButton.titleLabel setFont:shareFont];
    //    [shareButton setBackgroundColor:APPDEFAULTORANGE];
    //    [shareButton setBackgroundImage:[Tool buttonImageFromColor:APPDEFAULTORANGE withImageSize:shareButton.frame.size] forState:UIControlStateHighlighted];
    [shareButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    [shareAlert addSubview:shareButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX + buttonDis + buttonW, buttonY, buttonW, buttonH)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(alertbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 0;
    [cancelButton.titleLabel setFont:shareFont];
    //    [cancelButton setBackgroundColor:APPDEFAULTORANGE];
    //    [cancelButton setBackgroundImage:[Tool buttonImageFromColor:APPDEFAULTORANGE withImageSize:shareButton.frame.size] forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
    [shareAlert addSubview:cancelButton];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [shareAlert.layer addAnimation:popAnimation forKey:nil];
    [self.view addSubview:shareAlert];
}

- (void)alertbuttonClick:(UIButton *)button
{
    UIView *mydismissView = dismissView;
    mydismissView.hidden = YES;
    
    UIView *alertview = [self.view viewWithTag:ALERTTAG];
    
    UIView *subview = [alertview viewWithTag:10];
    if (button.tag == 0) {
        [alertview removeFromSuperview];
        return;
    }
    UITextField *textview = nil;
    if ([subview isMemberOfClass:[UITextField class]]) {
        textview = (UITextField *)subview;
    }
    textview.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    NSString *password = textview.text;
    [alertview removeFromSuperview];
    if (password == nil || [password isEqualToString:@""]) {
        
        [self showHint:@"請輸入驗證碼"];
        return;
    }
    [self creatBankCardWithCode:password];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}


- (void)creatBankCardWithCode:(NSString *)code
{
    [self showHudInView:tableview hint:@"添加中..."];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/account/create-bank",BASEURL];
    
    NSDictionary *dict = datasource[currentSelectIndex];
    NSString *bankId = dict[@"id"];
    NSString *bankName = dict[@"name"];
    
    NSString *acct_bank = [NSString stringWithFormat:@"%@ %@",bankId,bankName];
    NSString *acct_name = bankUserNameField.text;
    NSString *acct_no  = bankAccountField.text;
    NSString *captcha  = code;
    NSDictionary *params  = @{@"acct_bank":acct_bank,@"acct_name":acct_name,@"acct_no":acct_no,@"captcha":captcha};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        [self performSelector:@selector(backToLastView) withObject:nil afterDelay:0.2];
        [self showHint:@"添加成功"];
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}
- (void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
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
