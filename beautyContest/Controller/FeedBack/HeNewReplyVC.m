//
//  HeNewReplyVC.m
//  beautyContest
//
//  Created by Tony on 2017/5/4.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeNewReplyVC.h"
#import "SAMTextView.h"
#import "HeBaseTableViewCell.h"
#import "HeServiceFeedBackCell.h"
#import "MLLabel.h"
#import "MLLabel+Size.h"

@interface HeNewReplyVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *datasource;
@property(strong,nonatomic)IBOutlet UILabel *titleLabel;
@property(strong,nonatomic)SAMTextView *textView;
@property(strong,nonatomic)NSArray *replyArray; //客服回復的問題
@property(strong,nonatomic)NSDictionary *userReplyDict; //用戶的提問

@end

@implementation HeNewReplyVC
@synthesize tableview;
@synthesize datasource;
@synthesize titleLabel;
@synthesize textView;
@synthesize replyArray;
@synthesize userReplyDict;
@synthesize lastestReplyDict;

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
        label.text = @"最新回復";
        [label sizeToFit];
        self.title = @"最新回復";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self loadReplyContent];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
//    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initializaiton
{
    [super initializaiton];
    datasource = [[NSMutableArray alloc] initWithCapacity:0];
    userReplyDict = [[NSDictionary alloc] initWithDictionary:lastestReplyDict];
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
    CGFloat footerviewH = 180;
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(footerviewX, footerviewY, footerviewW, footerviewH)];
    footerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    tableview.tableFooterView = footerview;
    
    CGFloat textViewX = 10;
    CGFloat textViewY = 15;
    CGFloat textViewW = SCREENWIDTH - 2 * textViewX;
    CGFloat textViewH = 100;
    
    textView = [[SAMTextView alloc] initWithFrame:CGRectMake(textViewX, textViewY, textViewW, textViewH)];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8.0;
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.placeholder = @"留言...";
    textView.delegate = self;
    [footerview addSubview:textView];
    
    CGFloat historyButtonX = textViewX;
    CGFloat historyButtonY = CGRectGetMaxY(textView.frame) + 10;
    CGFloat historyButtonW = 80;
    CGFloat historyButtonH = 30;
    
    UIFont *buttonFont = [UIFont systemFontOfSize:14.0];
    
    
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
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
    NSString *content = textView.text;
    if (content == nil || [content isEqualToString:@""] || [content isEqualToString:@"留言..."]) {
        [self showHint:@"請輸入留言內容"];
        return;
    }
    NSString *comment_id  = userReplyDict[@"comment_id"];
    if ([comment_id isMemberOfClass:[NSNull class]] || comment_id == nil) {
        comment_id = @"";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/comment/reply",BASEURL];
    NSDictionary * params  = @{@"id":comment_id  ,@"content":content};
    __weak HeNewReplyVC *weakSelf = self;
    [self showHudInView:self.tableview hint:@"留言中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [respondString objectFromJSONString];
        if ([resultDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *error = resultDict[@"error"];
            if (error) {
                NSArray *allkey = error.allKeys;
                NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:0];
                for (NSInteger index = 0; index < [allkey count]; index++) {
                    NSString *key = allkey[index];
                    NSString *value = error[key];
                    [errorString appendFormat:@"%@",value];
                }
                if ([allkey count] == 0) {
                    errorString = [[NSMutableString alloc] initWithString:ERRORREQUESTTIP];
                }
                [self showHint:errorString];
                return;
            }
        }
        
        NSLog(@"resultDict = %@",resultDict);
        [weakSelf showHint:@"留言成功"];
        button.enabled = NO;
        [weakSelf.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEUSERREPLYNOTIFICATION object:nil];
        
        
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
    }];
}

- (void)loadReplyContent
{
    NSString *comment_id = lastestReplyDict[@"comment_id"];
    if ([comment_id isMemberOfClass:[NSNull class]] || comment_id == nil) {
         comment_id = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@/comment/view",BASEURL];
    NSDictionary * params  = @{@"id":comment_id};
    __weak HeNewReplyVC *weakSelf = self;
    
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [respondString objectFromJSONString];
        
        if ([resultDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *error = resultDict[@"error"];
            if (error) {
                NSArray *allkey = error.allKeys;
                NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:0];
                for (NSInteger index = 0; index < [allkey count]; index++) {
                    NSString *key = allkey[index];
                    NSString *value = error[key];
                    [errorString appendFormat:@"%@",value];
                }
                if ([allkey count] == 0) {
                    errorString = [[NSMutableString alloc] initWithString:ERRORREQUESTTIP];
                }
                [self showHint:errorString];
                return ;
            }
        }
        
        NSArray *allKey = resultDict.allKeys;
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        for (NSString *key in allKey) {
            id obj = resultDict[key];
            if ([key isEqualToString:@"replies"]) {
                //客服回復
                if ([obj isKindOfClass:[NSArray class]]) {
                    replyArray = [[NSArray alloc] initWithArray:obj];
                }
            }
            else{
                [tempDict setObject:obj forKey:key];
            }
        }
        userReplyDict = [[NSDictionary alloc] initWithDictionary:tempDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableview reloadData];
        });
        
    } failure:^(NSError* err){
        NSLog(@"err = %@",err);
    }];
}

- (void)commentButtonClick:(UIButton *)button
{
    NSLog(@"commentButtonClick");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交評價" message:@"感謝您的評價" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    __weak HeNewReplyVC *weakSelf = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"提交評價");
        NSString *comment_id = lastestReplyDict[@"comment_id"];
        if ([comment_id isMemberOfClass:[NSNull class]] || comment_id == nil) {
            comment_id = @"";
        }
        NSInteger rate = 0;
        switch (button.tag) {
            case 0:
            {
                rate = 2;
                break;
            }
            case 1:
            {
                rate = 1;
                break;
            }
            case 2:
            {
                rate = -2;
                break;
            }
            default:
                break;
        }
        [weakSelf commentReplyWithCommentId:comment_id rate:rate];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)commentReplyWithCommentId:(NSString *)comment_id rate:(NSInteger)rate
{
    if ([comment_id isMemberOfClass:[NSNull class]] || comment_id == nil) {
        comment_id = @"";
    }
    NSString *rateStr = [NSString stringWithFormat:@"%ld",rate];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/comment/update-rate ",BASEURL];
    NSDictionary * params  = @{@"id":comment_id  ,@"rate":rateStr};
    __weak HeNewReplyVC *weakSelf = self;
    [self showHint:@"評價中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:requestUrl params:params success:^(AFHTTPRequestOperation* operation,id response){
        [weakSelf hideHud];
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary *resultDict = [respondString objectFromJSONString];
        if ([resultDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *error = resultDict[@"error"];
            if (error) {
                NSArray *allkey = error.allKeys;
                NSMutableString *errorString = [[NSMutableString alloc] initWithCapacity:0];
                for (NSInteger index = 0; index < [allkey count]; index++) {
                    NSString *key = allkey[index];
                    NSString *value = error[key];
                    [errorString appendFormat:@"%@",value];
                }
                if ([allkey count] == 0) {
                    errorString = [[NSMutableString alloc] initWithString:ERRORREQUESTTIP];
                }
                [self showHint:errorString];
                return;
            }
        }
        
        [weakSelf showHint:@"評價成功"];
        [weakSelf.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEUSERREPLYNOTIFICATION object:nil];
        
        
        
    } failure:^(NSError* err){
        [weakSelf hideHud];
        [weakSelf showHint:ERRORREQUESTTIP];
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
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [replyArray count];
        case 2:
            return 1;
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGSize cellsize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat cellH = cellsize.height;
    
    static NSString *cellIndentifier = @"HeDCoinStoreCell";
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (section == 1) {
        NSDictionary *replyDict = nil;
        @try {
            replyDict = replyArray[row];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        if (!cell) {
            //客服回复
            cell = [[HeServiceFeedBackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize withReplyDict:replyDict];
            
        }
    }
    else{
        if (!cell) {
            cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellsize];
        }
    }
    
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    CGFloat contentLabelX = 10;
                    CGFloat contentLabelY = 0;
                    CGFloat contentLabelW = (cellsize.width - 2 * contentLabelX) / 2.0;
                    CGFloat contentLabelH = cellH;
                    
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
                    contentLabel.backgroundColor = [UIColor clearColor];
                    contentLabel.textColor = [UIColor grayColor];
                    contentLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:contentLabel];
                    
                    NSString *comment_content = userReplyDict[@"comment_content"];
                    if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
                        comment_content = @"";
                    }
                    contentLabel.text = comment_content;
                    
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - contentLabelW - 10, contentLabelY, contentLabelW, contentLabelH)];
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    timeLabel.backgroundColor = [UIColor clearColor];
                    timeLabel.textColor = [UIColor grayColor];
                    timeLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:timeLabel];
                    NSString *created_at = userReplyDict[@"created_at"];
                    if ([created_at isMemberOfClass:[NSNull class]] || created_at == nil) {
                        created_at = @"";
                    }
                    timeLabel.text = created_at;
                    break;
                }
                case 1:{
                    CGFloat contentLabelX = 10;
                    CGFloat contentLabelY = 0;
                    CGFloat contentLabelW = (cellsize.width - 2 * contentLabelX) / 2.0;
                    CGFloat contentLabelH = cellH;
                    
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
                    contentLabel.backgroundColor = [UIColor clearColor];
                    contentLabel.numberOfLines = 0;
                    contentLabel.textColor = APPDEFAULTORANGE;
                    contentLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:contentLabel];
                    
                    NSString *comment_content = userReplyDict[@"comment_content"];
                    if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
                        comment_content = @"";
                    }
                    contentLabel.text = comment_content;
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
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (row) {
                case 0:
                {
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREENWIDTH - 20, 25)];
                    contentlabel.backgroundColor = [UIColor clearColor];
                    contentlabel.textColor = [UIColor grayColor];
                    contentlabel.font = [UIFont systemFontOfSize:13.0];
                    contentlabel.text = @"如果您的問題已經解決，輕微本次服務評價";
                    [cell addSubview:contentlabel];
                    
                    NSArray *iconArray = @[@"icon_good",@"icon_normal",@"icon_bad"];
                    
                    CGFloat commentButtonX = 10;
                    CGFloat commentButtonY = CGRectGetMaxY(contentlabel.frame) + 5;
                    CGFloat commentButtonW = 50;
                    CGFloat commentButtonH = 25;
                    
                    for (NSInteger index = 0; index < [iconArray count]; index++) {
                        NSString *icon = iconArray[index];
                        UIButton *commentButton = [[UIButton alloc] initWithFrame:CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH)];
                        [commentButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
                        commentButton.tag = index;
                        
                        [commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:commentButton];
                        
                        commentButtonX = commentButtonX + commentButtonW + 15;
                    }
                    
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 1:
                {
                    NSString *comment_content = userReplyDict[@"comment_content"];
                    if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
                        comment_content = @"";
                    }
                    CGFloat contentLabelX = 10;
                    CGFloat contentLabelW = (SCREENWIDTH - 2 * contentLabelX) / 2.0;
                    UIFont *textfont = [UIFont systemFontOfSize:15.0];
                    
                    CGSize commentsize = [MLLabel getViewSizeByString:comment_content maxWidth:contentLabelW font:textfont lineHeight:1.2f lines:0];
                    if (commentsize.height < 40) {
                        commentsize.height = 40;
                    }
                    return commentsize.height + 10;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            NSDictionary *replyDict = nil;
            @try {
                replyDict = replyArray[row];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            NSString *comment_content = replyDict[@"comment_content"];
            if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
                comment_content = @"";
            }
            CGFloat contentLabelX = 55;
            CGFloat contentLabelW = (SCREENWIDTH - contentLabelX - 10) / 2.0;
            UIFont *textfont = [UIFont systemFontOfSize:15.0];
            
            CGSize commentsize = [MLLabel getViewSizeByString:comment_content maxWidth:contentLabelW font:textfont lineHeight:1.2f lines:0];
            if (commentsize.height < 40) {
                commentsize.height = 40;
            }
            return commentsize.height + 10;
            break;
        }
        case 2:{
            return 70;
            break;
        }
        default:
            break;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if (section == 1){
        return 30.0;
    }
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else if (section == 1){
        UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        headerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, 30)];
        contentlabel.backgroundColor = [UIColor clearColor];
        contentlabel.textColor = [UIColor grayColor];
        contentlabel.font = [UIFont systemFontOfSize:11.0];
        contentlabel.text = @"聊天內容";
        [headerview addSubview:contentlabel];
    
        return headerview;
    }
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerview.backgroundColor = [UIColor colorWithWhite:247.0 / 255.0 alpha:1.0];
    
    
    return headerview;
    return nil;
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
