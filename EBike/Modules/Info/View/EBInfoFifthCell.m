//
//  EBInfoFifthCell.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/21.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoFifthCell.h"

@interface EBInfoFifthCell()

@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UIImageView *arrowImgView;

@end

@implementation EBInfoFifthCell

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
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.arrowImgView];
}

- (void)setTitleValue:(NSString *)titleValue{
    self.titleLab.text = titleValue;
}

- (void)setIsWhite:(BOOL)isWhite{
    _isWhite = isWhite;
    UIColor *color = isWhite ? [UIColor whiteColor]:[UIColor blackColor];
    self.titleLab.textColor = color;
    NSString *arrowImg = isWhite ? @"Info_arrowRight":@"Info_arrowBlackRight";
    self.arrowImgView.image = [UIImage imageNamed:arrowImg];
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
}

#pragma mark -- title
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
    }
    return _arrowImgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
