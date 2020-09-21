//
//  EBInfoThirdCell.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoThirdCell.h"


@interface EBInfoThirdCell()

@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UIImageView *arrowImgView;
@property(nonatomic, strong)UIButton *clickBtn;

@end


@implementation EBInfoThirdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (void)setTitleValue:(NSString *)titleValue{
    _titleValue = titleValue;
    self.titleLab.text = titleValue;
}

- (void)setDetailValue:(NSString *)detailValue{
    self.detailLab.text = detailValue;
}

- (void)setIsWhite:(BOOL)isWhite{
    _isWhite = isWhite;
    UIColor *color = isWhite ? [UIColor whiteColor]:[UIColor blackColor];
    self.titleLab.textColor = color;
    self.detailLab.textColor = color;
    NSString *arrowImg = isWhite ? @"Info_arrowDown":@"Info_arrowBlackDown";
    _arrowImgView.image = [UIImage imageNamed:arrowImg];
}

- (void)setIsHideArrow:(BOOL)isHideArrow{
    self.arrowImgView.hidden = isHideArrow;
    if (isHideArrow) {
        [self.arrowImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SCALE_PWIDTH(20));
        }];
    }
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.clickBtn.selected = isSelect;
}

- (void)createView{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.detailLab];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.clickBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    EBWeakSelf
    CGFloat titleLabX = self.isWhite ? SCALE_PWIDTH(75):SCALE_LWIDTH(50);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCALE_PWIDTH(-20));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(weakSelf.arrowImgView.mas_left).mas_offset(SCALE_PWIDTH(-10));
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(weakSelf.detailLab.mas_left);
    }];
}

#pragma mark -- title
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor whiteColor];
        
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [[UILabel alloc]init];
        _detailLab.textColor = [UIColor whiteColor];
    }
    return _detailLab;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]init];
        _arrowImgView.image = [UIImage imageNamed:@"Info_arrowDown"];
        _arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImgView;
}

- (UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor clearColor];
        [_clickBtn addTarget:self action:@selector(handleUnitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

- (void)handleUnitClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.titleValue isEqualToString:@"Unit"]) {
        self.clickBlock(sender.selected);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
