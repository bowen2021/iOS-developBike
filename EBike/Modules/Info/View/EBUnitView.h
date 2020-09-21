//
//  EBUnitView.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/21.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EBUnitViewDelegate<NSObject>
@optional

- (void)chooseUnitOfTitle:(NSString *)title;

@end

@interface EBUnitView : UIView

@property(nonatomic, weak)id<EBUnitViewDelegate> unitDelegate;

@end

NS_ASSUME_NONNULL_END
