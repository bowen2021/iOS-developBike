//
//  EBBleCell.m
//  EBike
//
//  Created by 刘佳斌 on 2019/5/7.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBBleCell.h"

@interface EBBleCell ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *macLabel;
@property(nonatomic,strong)UILabel *rssiLabel;

@end


@implementation EBBleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.macLabel];
    [self.contentView addSubview:self.rssiLabel];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setMac:(NSString *)mac{
    _mac = mac;
    self.macLabel.text = mac;
}

- (void)setRssi:(NSString *)rssi{
    _rssi = rssi;
    self.rssiLabel.text = rssi;
}

- (void)layoutSubviews{
    EBWeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALE_PWIDTH(5));
        make.left.mas_equalTo(SCALE_PWIDTH(15));
    }];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom);
        make.left.mas_equalTo(SCALE_PWIDTH(15));
    }];
    [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-SCALE_PWIDTH(15));
    }];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:SCALE_PWIDTH(17)];
    }
    return _titleLabel;
}

- (UILabel *)macLabel{
    if (!_macLabel) {
        _macLabel = [[UILabel alloc]init];
        _macLabel.textColor = [UIColor whiteColor];
        _macLabel.font = [UIFont systemFontOfSize:SCALE_PWIDTH(14)];
    }
    return _macLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc]init];
        _rssiLabel.textColor = [UIColor whiteColor];
        _rssiLabel.font = [UIFont systemFontOfSize:SCALE_PWIDTH(14)];
    }
    return _rssiLabel;
}

@end
