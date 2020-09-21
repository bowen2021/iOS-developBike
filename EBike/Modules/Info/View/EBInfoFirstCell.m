//
//  EBInfoFirstCell.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoFirstCell.h"

@interface EBInfoFirstCell()

@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UIImageView *arrowImgView;

@end


@implementation EBInfoFirstCell

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
    self.titleLab.text = titleValue;
    NSString *imgStr = [titleValue isEqualToString:@"Unit"] ? @"Info_arrowDown":[titleValue isEqualToString:@"Set Password"] ? @"Info_arrowRight":@"";
    _arrowImgView.image = [UIImage imageNamed:imgStr];
}

- (void)setDetailValue:(NSString *)detailValue{
    self.detailLab.text = detailValue;
}

- (void)setIsArrow:(BOOL)isArrow{
    _isArrow = isArrow;
    self.arrowImgView.hidden = !isArrow;
}

- (void)setIsWhite:(BOOL)isWhite{
    _isWhite = isWhite;
    UIColor *color = isWhite ? [UIColor whiteColor]:[UIColor blackColor];
    self.titleLab.textColor = color;
    self.detailLab.textColor = color;
    NSString *arrowImg = isWhite ? @"Info_arrowRight":@"Info_arrowBlackRight";
    self.arrowImgView.image = [UIImage imageNamed:arrowImg];
}

- (void)createView{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.detailLab];
    [self.contentView addSubview:self.arrowImgView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    EBWeakSelf
    CGFloat titleLabX = self.isWhite ? SCALE_PWIDTH(75):SCALE_LWIDTH(50);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    if (self.isArrow) {
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SCALE_PWIDTH(-20));
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.right.mas_equalTo(weakSelf.arrowImgView.mas_left).mas_offset(SCALE_PWIDTH(-10));
        }];
    }else{
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.right.mas_equalTo(SCALE_PWIDTH(-20));
        }];
    }
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
    }
    return _arrowImgView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



