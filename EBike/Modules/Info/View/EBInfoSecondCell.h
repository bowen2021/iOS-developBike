//
//  EBInfoSecondCell.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const EBInfoSecondCellID = @"EBInfoSecondCellID";

typedef void(^InfoSecondBlock)(void);

@interface EBInfoSecondCell : UITableViewCell

@property(nonatomic, copy)NSString *titleValue;
@property(nonatomic, assign)BOOL isWhite;
@property(nonatomic, assign)BOOL isSwitchOn;
@property(nonatomic, strong)InfoSecondBlock infoBlock;


@end

NS_ASSUME_NONNULL_END
