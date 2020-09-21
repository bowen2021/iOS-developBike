//
//  EBWheelSpeedView.m
//  EBike
//
//  Created by 刘佳斌 on 2019/3/8.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBWheelSpeedView.h"

@implementation EBWheelSpeedView

- (instancetype)initWithFrame:(CGRect)frame dataList:(NSArray *)dataList{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self handleList:dataList];
    }
    return self;
}

- (void)handleList:(NSArray *)dataList{
    self.contentSize = CGSizeMake(0, dataList.count*44);
    for (int i = 0; i<dataList.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*44, CGRectGetWidth(self.frame), 44);
        [btn setTitle:dataList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)handleTap:(UIButton *)sender{
    NSString *title = [sender titleForState:UIControlStateNormal];
    if (self.block){
        self.block(title);
    }
}

@end
