//
//  HeDCoinStoreCell.h
//  beautyContest
//
//  Created by Tony on 2017/4/20.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseTableViewCell.h"

@interface HeDCoinStoreCell : HeBaseTableViewCell
@property(strong,nonatomic)UILabel *exchangeRateLabel;
@property(strong,nonatomic)UILabel *dcoinLabel;
@property(strong,nonatomic)UILabel *statusLabel;
@property(strong,nonatomic)UILabel *coinLabel;
@property(strong,nonatomic)UILabel *timeLabel;

@end
