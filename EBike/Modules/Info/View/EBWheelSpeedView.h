//
//  EBWheelSpeedView.h
//  EBike
//
//  Created by 刘佳斌 on 2019/3/8.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ChooseTitleBlock)(NSString *title);

@interface EBWheelSpeedView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame dataList:(NSArray *)dataList;

@property(nonatomic, strong)ChooseTitleBlock block;

@end

NS_ASSUME_NONNULL_END
