//
//  HeHistoryFeedBackCell.m
//  beautyContest
//
//  Created by Tony on 2017/4/28.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeHistoryFeedBackCell.h"

@implementation HeHistoryFeedBackCell
@synthesize feedBackIDLabel;
@synthesize feedBackContentLabel;
@synthesize feedBackTimeLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        CGFloat bgViewX = 10;
        CGFloat bgViewY = 5;
        CGFloat bgViewW = cellsize.width - 2 * bgViewX;
        CGFloat bgViewH = cellsize.height - 2 * bgViewY;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 8.0;
        [self addSubview:bgView];
        
        CGFloat upHeight = bgViewH / 3.0 * 2.0;
        CGFloat downHeight = bgViewH / 3.0;
        
        CGFloat feedBackIDLabelX = 10;
        CGFloat feedBackIDLabelY = 5;
        CGFloat feedBackIDLabelW = (bgViewW - 2 * feedBackIDLabelX) / 2.0;
        CGFloat feedBackIDLabelH = (upHeight - 2 * feedBackIDLabelY) / 2.0;
        
        feedBackIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(feedBackIDLabelX, feedBackIDLabelY, feedBackIDLabelW, feedBackIDLabelH)];
        feedBackIDLabel.backgroundColor = [UIColor clearColor];
        feedBackIDLabel.font = [UIFont systemFontOfSize:13.0];
        feedBackIDLabel.textColor = [UIColor grayColor];
        feedBackIDLabel.text = @"問題ID：100";
        [bgView addSubview:feedBackIDLabel];
        
        feedBackTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgViewW - feedBackIDLabelW - feedBackIDLabelX - 30, feedBackIDLabelY, feedBackIDLabelW + 30, feedBackIDLabelH)];
        feedBackTimeLabel.backgroundColor = [UIColor clearColor];
        feedBackTimeLabel.font = [UIFont systemFontOfSize:13.0];
        feedBackTimeLabel.textColor = [UIColor grayColor];
        feedBackTimeLabel.textAlignment = NSTextAlignmentRight;
        feedBackTimeLabel.text = @"提交時間：2017/03/08";
        [bgView addSubview:feedBackTimeLabel];
        
        CGFloat feedBackContentLabelX = 10;
        CGFloat feedBackContentLabelY = CGRectGetMaxY(feedBackIDLabel.frame);
        CGFloat feedBackContentLabelW = bgViewW - 2 * feedBackContentLabelX;
        CGFloat feedBackContentLabelH = (upHeight - 2 * feedBackIDLabelY) / 2.0;
        
        feedBackContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(feedBackContentLabelX, feedBackContentLabelY, feedBackContentLabelW, feedBackContentLabelH)];
        feedBackContentLabel.backgroundColor = [UIColor clearColor];
        feedBackContentLabel.font = [UIFont systemFontOfSize:15.0];
        feedBackContentLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
        feedBackContentLabel.text = @"測試";
        [bgView addSubview:feedBackContentLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(feedBackContentLabel.frame), bgViewW - 20, 1)];
        line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        [bgView addSubview:line];
        
        CGFloat scanLabelX = 10;
        CGFloat scanLabelY = CGRectGetMaxY(line.frame);
        CGFloat scanLabelW = bgViewW - 2 * scanLabelX;
        CGFloat scanLabelH = downHeight;
        
        UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(scanLabelX, scanLabelY, scanLabelW, scanLabelH)];
        scanLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
        scanLabel.backgroundColor = [UIColor clearColor];
        scanLabel.font = [UIFont systemFontOfSize:16.0];
        scanLabel.text = @"立即查看";
        [bgView addSubview:scanLabel];
    }
    return self;
}

@end
