//
//  EBInfoPorHeaderView.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoPorHeaderView.h"

@interface EBInfoPorHeaderView()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UIImageView *arrowImgView;

@end

@implementation EBInfoPorHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.arrowImgView];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setImage:(NSString *)image{
    _image = image;
    self.imgView.image = [UIImage imageNamed:image];
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    NSString *img = isSelect ? @"Info_arrowDown":@"Info_arrowRight";
    self.arrowImgView.image = [UIImage imageNamed:img];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    EBWeakSelf
    CGFloat imageX = [self.title isEqualToString:@"Battery"] ? SCALE_PWIDTH(12):[self.title isEqualToString:@"Driver data"] ? SCALE_PWIDTH(8):SCALE_PWIDTH(20);
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    CGFloat titleX = [self.title isEqualToString:@"Battery"] ? SCALE_PWIDTH(12):[self.title isEqualToString:@"Settings"] ? SCALE_PWIDTH(21):SCALE_PWIDTH(4);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgView.mas_right).mas_offset(titleX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCALE_PWIDTH(-10));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:SCALE_PWIDTH(19)];
    }
    return _titleLab;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]init];
        _arrowImgView.image = [UIImage imageNamed:@"Info_arrowRight"];
    }
    return _arrowImgView;
}

@end
