//
//  EBPasswordAlertView.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/26.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EBPasswordAlertViewDelegate <NSObject>

@optional
- (void)handleOkClickWithValue:(NSString *)value;
- (void)handleCancelClick;

@end

typedef NS_ENUM(NSInteger,AlertViewType)
{
    EBAlertPassword,
    EBAlertPush,
    EBAlertWheel,
    EBAlertMaxspeed,
    EBAlertSetName,
    EBAlertSetPassword,
};


@interface EBPasswordAlertView : UIView

@property(nonatomic,weak)id<EBPasswordAlertViewDelegate> alertDelegate;
@property(nonatomic,copy)NSString *alertTitle;
@property(nonatomic, copy)NSString *inputText;
@property(nonatomic,assign)AlertViewType alertType;

@property(nonatomic,assign)BOOL isPortrait;
@end

NS_ASSUME_NONNULL_END
