//
//  EBHomeVC.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol EBHomeVCDelegate <NSObject>
//
//@optional
//- (void)refreshBleData:(EBBTDataModel *)model;
//
//@end

@interface EBHomeVC : EBBaseVC

- (void)handleHomeRequest;

//@property(nonatomic, weak)id<EBHomeVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
