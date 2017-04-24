//
//  HeBankCardCell.m
//  beautyContest
//
//  Created by Tony on 2017/4/24.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBankCardCell.h"

@implementation HeBankCardCell
@synthesize bankNameLabel;
@synthesize bankCardLabel;
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
        CGFloat bankNameLabelX = 10;
        CGFloat bankNameLabelY = 0;
        CGFloat bankNameLabelW = cellsize.width - 2 * bankNameLabelX;
        CGFloat bankNameLabelH = cellsize.height / 2.0;
        
        bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(bankNameLabelX, bankNameLabelY, bankNameLabelW, bankNameLabelH)];
        bankNameLabel.backgroundColor = [UIColor clearColor];
        bankNameLabel.textColor = [UIColor colorWithWhite:30.0 / 255.0 alpha:1.0];
        bankNameLabel.text = @"農商銀行";
        bankNameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:bankNameLabel];
        
        bankNameLabelY = CGRectGetMaxY(bankNameLabel.frame);
        
        bankCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(bankNameLabelX, bankNameLabelY, bankNameLabelW, bankNameLabelH)];
        bankCardLabel.backgroundColor = [UIColor clearColor];
        bankCardLabel.textColor = [UIColor grayColor];
        bankCardLabel.text = @"卡號末6位 : 952793";
        bankCardLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:bankCardLabel];
        
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
    CGContextSetStrokeColorWithColor(context, ([UIColor colorWithWhite:237.0 / 255.0 alpha:1.0]).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

@end
