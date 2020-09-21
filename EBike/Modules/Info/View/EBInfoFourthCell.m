//
//  EBInfoFourthCell.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoFourthCell.h"

@interface EBInfoFourthCell()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel     *titleLab;
@property(nonatomic, strong)UIImageView *arrowImgView;
@property(nonatomic, strong)UIView      *lineView;

@end


@implementation EBInfoFourthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (void)setImageValue:(NSString *)imageValue{
    _imageValue = imageValue;
    self.imgView.image = [UIImage imageNamed:imageValue];
}

- (void)setTitleValue:(NSString *)titleValue{
    _titleValue = titleValue;
    self.titleLab.text = titleValue;
}

- (void)setIsHideLine:(BOOL)isHideLine{
    _isHideLine = isHideLine;
    self.lineView.hidden = isHideLine;
}

- (void)createView{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.lineView];
    
}

- (void)layoutSubviews{
    EBWeakSelf
    
    CGFloat imgX = [self.titleValue isEqualToString:@"Battery"] ? SCALE_LWIDTH(1): [self.titleValue isEqualToString:@"Driver data"] ? SCALE_LWIDTH(-4):SCALE_LWIDTH(10);
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    CGFloat titleX = [self.titleValue isEqualToString:@"Battery"] ? SCALE_LWIDTH(10): [self.titleValue isEqualToString:@"Driver data"] ? SCALE_LWIDTH(2):SCALE_LWIDTH(20);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imgView.mas_right).mas_offset(titleX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCALE_PWIDTH(-10));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(SCALE_PWIDTH(10));
        make.right.mas_equalTo(SCALE_PWIDTH(-10));
    }];
}

#pragma mark -- 控件
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor whiteColor];
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

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
