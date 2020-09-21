//
//  EBInfoFirstCell.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const EBInfoFirstCellID = @"EBInfoFirstCellID";

@interface EBInfoFirstCell : UITableViewCell

@property(nonatomic, copy)NSString *titleValue;
@property(nonatomic, copy)NSString *detailValue;
@property(nonatomic, assign)BOOL isArrow;
@property(nonatomic, assign)BOOL isWhite;

@end

NS_ASSUME_NONNULL_END
