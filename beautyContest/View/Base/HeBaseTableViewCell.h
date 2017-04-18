//
//  HeBaseTableViewCell.h
//  huayoutong
//
//  Created by Tony on 16/3/31.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeBaseTableViewCell : UITableViewCell
@property(strong,nonatomic)UIButton *selectButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize;

@end
