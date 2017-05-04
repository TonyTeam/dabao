//
//  HeServiceFeedBackCell.h
//  beautyContest
//
//  Created by Tony on 2017/5/4.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseTableViewCell.h"

@interface HeServiceFeedBackCell : HeBaseTableViewCell
@property(strong,nonatomic)UILabel *contentlabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize withReplyDict:(NSDictionary *)dict;


@end
