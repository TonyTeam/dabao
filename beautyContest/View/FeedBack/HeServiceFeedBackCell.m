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
        CGFloat contentLabelW = (cellsize.width - contentLabelX - 10) / 2.0;
        CGFloat contentLabelH = cellsize.height;
        
        NSString *user_id = dict[@"user_id"];
        if ([user_id isMemberOfClass:[NSNull class]]) {
            user_id = @"";
        }
        NSString *myuserid = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
        if ([myuserid isEqualToString:user_id]) {
            //用户自己
            contentLabelX = contentLabelX + contentLabelW;
            titleLabel.text = @"";
        }
        
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:contentLabel];
        
      
        if ([myuserid isEqualToString:user_id]) {
            //用户自己
            contentLabel.textAlignment = NSTextAlignmentRight;
        }
        else{
            //客服
            contentLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        NSString *comment_content = dict[@"comment_content"];
        if ([comment_content isMemberOfClass:[NSNull class]] || comment_content == nil) {
            comment_content = @"";
        }
        contentLabel.text = comment_content;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, ([UIColor clearColor]).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, ([UIColor clearColor]).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

@end
