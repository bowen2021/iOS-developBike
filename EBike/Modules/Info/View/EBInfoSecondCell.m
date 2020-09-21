//
//  EBInfoSecondCell.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoSecondCell.h"

@interface EBInfoSecondCell()

@property(nonatomic, strong)UILabel  *titleLab;
@property(nonatomic, strong)UISwitch *switchItem;

@end

@implementation EBInfoSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
        self.switchItem.enabled = [EBUserTool isLogin] ? YES:NO;
    }
    return self;
}

- (void)createView{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.switchItem];
}

- (void)setTitleValue:(NSString *)titleValue{
    self.titleLab.text = titleValue;
}

- (void)setIsWhite:(BOOL)isWhite{
    _isWhite = isWhite;
    UIColor *color = isWhite ? [UIColor whiteColor]:[UIColor blackColor];
    self.titleLab.textColor = color;
}

- (void)setIsSwitchOn:(BOOL)isSwitchOn{
    _isSwitchOn = isSwitchOn;
    self.switchItem.on = isSwitchOn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    EBWeakSelf
    CGFloat titleLabX = self.isWhite ? SCALE_PWIDTH(75):SCALE_LWIDTH(50);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.switchItem mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UISwitch *)switchItem{
    if (!_switchItem) {
        _switchItem = [[UISwitch alloc]init];
        _switchItem.on = NO;
        _switchItem.enabled = [EBUserTool isLogin] ? YES:NO;
        _switchItem.transform = CGAffineTransformMakeScale(0.7, 0.7);
//        [_switchItem addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
        [_switchItem addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchItem;
}

- (void)handleSwitch:(UISwitch *)sender{
    sender.on = _isSwitchOn;
    self.infoBlock();
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
