//
//  HeOrderCell.m
//  beautyContest
//
//  Created by Tony on 2017/4/24.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeOrderCell.h"

@implementation HeOrderCell
@synthesize exchangeRateLabel;
@synthesize dcoinLabel;
@synthesize statusLabel;
@synthesize coinLabel;
@synthesize timeLabel;

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
        CGFloat exchangeRateLabelX = 10;
        CGFloat exchangeRateLabelH = 25;
        CGFloat exchangeRateLabelY = (cellsize.height - 2 * exchangeRateLabelH) / 2.0;
        CGFloat exchangeRateLabelW = (SCREENWIDTH - 2 * exchangeRateLabelX) / 2.0;
        
        UIFont *bigFont = [UIFont systemFontOfSize:15.0];
        
        exchangeRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(exchangeRateLabelX, exchangeRateLabelY, exchangeRateLabelW, exchangeRateLabelH)];
        exchangeRateLabel.backgroundColor = [UIColor clearColor];
        exchangeRateLabel.textColor = [UIColor blackColor];
        exchangeRateLabel.font = bigFont;
        exchangeRateLabel.text = @"當天匯率: 4.873";
        [self addSubview:exchangeRateLabel];
        
        exchangeRateLabelY = CGRectGetMaxY(exchangeRateLabel.frame);
        dcoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(exchangeRateLabelX, exchangeRateLabelY, exchangeRateLabelW, exchangeRateLabelH)];
        dcoinLabel.backgroundColor = [UIColor clearColor];
        dcoinLabel.textColor = [UIColor colorWithRed:253.0 / 255.0 green:105.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
        dcoinLabel.font = bigFont;
        dcoinLabel.text = @"需支付台幣: 4873";
        [self addSubview:dcoinLabel];
        
        UIFont *smallFont = [UIFont systemFontOfSize:13.0];
        exchangeRateLabelY = 10;
        exchangeRateLabelX = CGRectGetMaxX(exchangeRateLabel.frame);
        exchangeRateLabelH = (cellsize.height - 2 * exchangeRateLabelY) / 3.0;
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(exchangeRateLabelX, exchangeRateLabelY, exchangeRateLabelW, exchangeRateLabelH)];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = [UIColor colorWithRed:253.0 / 255.0 green:105.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
        statusLabel.font = smallFont;
        statusLabel.text = @"待處理";
        [self addSubview:statusLabel];
        
        exchangeRateLabelY = CGRectGetMaxY(statusLabel.frame);
        coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(exchangeRateLabelX, exchangeRateLabelY, exchangeRateLabelW, exchangeRateLabelH)];
        coinLabel.textAlignment = NSTextAlignmentRight;
        coinLabel.backgroundColor = [UIColor clearColor];
        coinLabel.textColor =[UIColor colorWithRed:147.0 / 255.0 green:198.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
        coinLabel.font = smallFont;
        coinLabel.text = @"+1000";
        [self addSubview:coinLabel];
        
        exchangeRateLabelY = CGRectGetMaxY(coinLabel.frame);
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(exchangeRateLabelX, exchangeRateLabelY, exchangeRateLabelW, exchangeRateLabelH)];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor =[UIColor grayColor];
        timeLabel.font = smallFont;
        timeLabel.text = @"2017/04/07 15:30:35";
        [self addSubview:timeLabel];
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
