//
//  EBInfoVC.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBBaseVC.h"
#import "EBBTDataModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshDataBlock)(EBBTDataModel *dataModel);

@interface EBInfoVC : EBBaseVC


@property(nonatomic, strong)EBBTDataModel *model;
@property(nonatomic, assign)BOOL isPortrait;

@property(nonatomic, strong)RefreshDataBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
