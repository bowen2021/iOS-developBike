//
//  EBUnitView.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/21.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBUnitView.h"

@interface EBUnitView ()

@property(nonatomic, strong)UIButton *kmBtn;
@property(nonatomic, strong)UIButton *mileBtn;

@end

@implementation EBUnitView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    
    [self addSubview:self.kmBtn];
    [self addSubview:self.mileBtn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    EBWeakSelf
    [self.kmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(CGRectGetHeight(weakSelf.frame)/2);
    }];
    [self.mileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(weakSelf.kmBtn.mas_height);
    }];
}

- (UIButton *)kmBtn{
    if (!_kmBtn) {
        _kmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_kmBtn setTitle:@"km" forState:UIControlStateNormal];
        [_kmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_kmBtn addTarget:self action:@selector(handleClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kmBtn;
}

- (UIButton *)mileBtn{
    if (!_mileBtn) {
        _mileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mileBtn setTitle:@"mile" forState:UIControlStateNormal];
        [_mileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mileBtn addTarget:self action:@selector(handleClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mileBtn;
}

- (void)handleClickBtn:(UIButton *)sender{
    NSString *title = [sender titleForState:UIControlStateNormal];
    [self.unitDelegate chooseUnitOfTitle:title];
}

@end
