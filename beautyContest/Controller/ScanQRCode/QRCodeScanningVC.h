//
//  QRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGQRCode.h"

@protocol QRCodeProtocol <NSObject>

- (void)scanQRCodeWithString:(NSString *)qrCode;

@end

@interface QRCodeScanningVC : SGQRCodeScanningVC
@property(assign,nonatomic)id<QRCodeProtocol>qrcodeDelegate;

@end
