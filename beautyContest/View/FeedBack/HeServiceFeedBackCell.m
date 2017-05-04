//
//  HeServiceFeedBackCell.m
//  beautyContest
//
//  Created by Tony on 2017/5/4.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeServiceFeedBackCell.h"

@implementation HeServiceFeedBackCell
@synthesize contentlabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize withReplyDict:(NSDictionary *)dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        CGFloat titleLabelX = 10;
        CGFloat titleLabelY = 0;
        CGFloat titleLabelW = 40;
        CGFloat titleLabelH = 50;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"客服:";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:titleLabel];
        
        
        CGFloat contentLabelX = CGRectGetMaxX(titleLabel.frame) + 5;
        CGFloat contentLabelY = 0;
        CGFloat contentLabelW = cellsize.width - contentLabelX - 10;
        CGFloat contentLabelH = cellsize.height;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:contentLabel];
        
        NSString *comment_content = dict[@"comment_content"];
        if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
            comment_content = @"";
        }
        contentLabel.text = comment_content;
    }
    return self;
}

@end
