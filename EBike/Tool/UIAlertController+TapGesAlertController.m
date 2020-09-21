//
//  UIAlertController+TapGesAlertController.m
//  EBike
//
//  Created by 刘佳斌 on 2019/4/5.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "UIAlertController+TapGesAlertController.h"

@implementation UIAlertController (TapGesAlertController)

- (void)tapGesAlert{
    NSArray *arrayViews = [UIApplication sharedApplication].keyWindow.subviews;
    if (arrayViews.count > 0) {
        UIView *backView = arrayViews.lastObject;
        backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [backView addGestureRecognizer:tap];
    }
}

-(void)handleTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
