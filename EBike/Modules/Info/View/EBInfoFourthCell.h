//
//  EBInfoFourthCell.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const EBInfoFourthCellID = @"EBInfoFourthCellID";

@interface EBInfoFourthCell : UITableViewCell

@property(nonatomic, copy)NSString *imageValue;
@property(nonatomic, copy)NSString *titleValue;
@property(nonatomic, assign)BOOL isHideLine;

@end

NS_ASSUME_NONNULL_END
