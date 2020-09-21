//
//  EBInfoThirdCell.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const EBInfoThirdCellID = @"EBInfoThirdCellID";

typedef void(^UnitClickBlock)(BOOL isClick);

@interface EBInfoThirdCell : UITableViewCell

@property(nonatomic, copy)NSString *titleValue;
@property(nonatomic, copy)NSString *detailValue;
@property(nonatomic, assign)BOOL isWhite;
@property(nonatomic, assign)BOOL isHideArrow;

@property(nonatomic, strong)UnitClickBlock clickBlock;

@property(nonatomic, assign)BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
