//
//  HeNoticeCell.m
//  beautyContest
//
//  Created by Tony on 2017/4/24.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeNoticeCell.h"

@implementation HeNoticeCell
@synthesize titleLabel;
@synthesize timeLabel;
@synthesize statusLabel;

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
        CGFloat bgviewY = 5;
        CGFloat bgViewW = cellsize.width - 2 * bgViewX;
        CGFloat bgviewH = cellsize.height - 2 * bgviewY;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgviewY, bgViewW, bgviewH)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 8.0;
        [self addSubview:bgView];
        
        CGFloat titleLabelX = 10;
        CGFloat titleLabelY = 0;
        CGFloat titleLabelW = bgViewW - 2 * titleLabelX;
        CGFloat titleLabelH = bgviewH / 3.0;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        titleLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:17.0];
        titleLabel.text = @"個人資料安全保障政策";
        [bgView addSubview:titleLabel];
        
        titleLabelY = CGRectGetMaxY(titleLabel.frame);
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:15.0];
        timeLabel.text = @"2017-03-24 17:30:24";
        [bgView addSubview:timeLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame), bgViewW - 20, 1)];
        line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        [bgView addSubview:line];
        
        titleLabelY = CGRectGetMaxY(line.frame);
        UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        scanLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
        scanLabel.backgroundColor = [UIColor clearColor];
        scanLabel.font = [UIFont systemFontOfSize:15.0];
        scanLabel.text = @"立即查看";
        [bgView addSubview:scanLabel];
        
       
        CGFloat arrowImageW = 20;
        CGFloat arrowImageH = 20;
        CGFloat arrowImageX = bgViewW - arrowImageW - 10;
        CGFloat arrowImageY = bgviewH - (titleLabelH - arrowImageH) / 2.0 - arrowImageH;
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(arrowImageX, arrowImageY, arrowImageW, arrowImageH)];
        arrowImage.image = [UIImage imageNamed:@"icon_gray_choose"];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        [bgView addSubview:arrowImage];
        
        titleLabelX = CGRectGetMinX(arrowImage.frame) - 5 - 100;
        titleLabelY = CGRectGetMaxY(line.frame);
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, 100, titleLabelH)];
        statusLabel.textColor = APPDEFAULTORANGE;
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:15.0];
        statusLabel.text = @"已讀";
        [bgView addSubview:statusLabel];
        
    }
    return self;
}

@end
