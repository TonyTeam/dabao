//
//  HeBaseTableViewCell.m
//  huayoutong
//
//  Created by Tony on 16/3/31.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import "HeBaseTableViewCell.h"

@implementation HeBaseTableViewCell
@synthesize selectButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat selectW = 20;
        CGFloat selectH = 20;
        CGFloat selectY = (cellsize.height - selectH) / 2.0;
        CGFloat selectX = cellsize.width - 10 - selectW;
        selectButton = [[UIButton alloc] init];
        selectButton.frame = CGRectMake(selectX, selectY, selectW, selectH);
        [self addSubview:selectButton];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
