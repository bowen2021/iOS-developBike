//
//  EBBleCell.h
//  EBike
//
//  Created by 刘佳斌 on 2019/5/7.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const EBBleCellID = @"EBBleCellID";

@interface EBBleCell : UITableViewCell



@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *mac;
@property(nonatomic,copy)NSString *rssi;

@end

NS_ASSUME_NONNULL_END
