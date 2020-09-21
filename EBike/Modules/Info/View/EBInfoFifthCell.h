//
//  EBInfoFifthCell.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/21.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const EBInfoFifthCellID = @"EBInfoFifthCellID";

@interface EBInfoFifthCell : UITableViewCell

@property(nonatomic, copy)NSString *titleValue;
@property(nonatomic, assign)BOOL isWhite;



@end

NS_ASSUME_NONNULL_END
