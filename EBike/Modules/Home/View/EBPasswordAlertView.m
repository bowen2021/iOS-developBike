//
//  EBPasswordAlertView.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/26.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBPasswordAlertView.h"

@interface EBPasswordAlertView()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIView *tapView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *inputTF;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *okBtn;
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)UIView *lineView2;

@end

@implementation EBPasswordAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
        [self.inputTF becomeFirstResponder];
        self.inputTF.text = @"";
    }
    return self;
}

- (void)createView{
    [self addSubview:self.tapView];
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.titleLabel];
    [self.baseView addSubview:self.inputTF];
    [self.baseView addSubview:self.cancelBtn];
    [self.baseView addSubview:self.okBtn];
    [self.baseView addSubview:self.lineView1];
    [self.baseView addSubview:self.lineView2];
}

- (void)setAlertTitle:(NSString *)alertTitle{
    _alertTitle = alertTitle;
    self.titleLabel.text = alertTitle;
}

- (void)setInputText:(NSString *)inputText{
    _inputText = inputText;
    self.inputTF.text = inputText;
}

- (void)setIsPortrait:(BOOL)isPortrait{
    _isPortrait = isPortrait;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    EBWeakSelf
    [self.tapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
    [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).mas_offset(-SCALE_PWIDTH(30));
        make.width.mas_equalTo([EBTool handleCommonFit:325]);
        make.height.mas_equalTo([EBTool handleCommonFit:160]);
    }];
    self.baseView.layer.cornerRadius = 5;
    self.baseView.layer.masksToBounds = YES;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.baseView.mas_top).mas_offset([EBTool handleCommonFit:20]);
        make.left.mas_equalTo(weakSelf.baseView.mas_left);
        make.right.mas_equalTo(weakSelf.baseView.mas_right);
        make.height.mas_equalTo([EBTool handleCommonFit:30]);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).mas_offset([EBTool handleCommonFit:10]);
        make.left.mas_equalTo(weakSelf.baseView.mas_left);
        make.right.mas_equalTo(weakSelf.baseView.mas_right);
        make.height.mas_equalTo([EBTool handleCommonFit:40]);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.inputTF.mas_bottom).mas_offset([EBTool handleCommonFit:10]);
        make.height.mas_equalTo(0.5);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo([EBTool handleCommonFit:325]/2);
        make.top.mas_equalTo(weakSelf.lineView1.mas_bottom);
    }];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.cancelBtn.mas_right);
        make.bottom.mas_equalTo(0);
//        make.width.mas_equalTo(SCALE_PWIDTH(325)/2);
        make.width.mas_equalTo([EBTool handleCommonFit:325]/2);
        make.top.mas_equalTo(weakSelf.lineView1.mas_bottom);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.cancelBtn.mas_right);
        make.top.mas_equalTo(weakSelf.lineView1.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.baseView.mas_bottom);
        make.width.mas_equalTo(0.5);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc]init];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [[UIView alloc]init];
        _tapView.backgroundColor = [UIColor blackColor];
        _tapView.alpha = 0.05;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleViewTap)];
        [_tapView addGestureRecognizer:tap];
    }
    return _tapView;
}

- (void)handleViewTap{
    [self removeFromSuperview];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"Please Input Password";
        _titleLabel.font = [UIFont boldSystemFontOfSize:[EBTool handleCommonFit:17]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextField *)inputTF{
    if (!_inputTF) {
        _inputTF = [[UITextField alloc]init];
        _inputTF.delegate = self;
        _inputTF.textAlignment = NSTextAlignmentCenter;
    }
    return _inputTF;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)handleCancel{
    if ([self.alertDelegate respondsToSelector:@selector(handleCancelClick)]) {
        [self.alertDelegate handleCancelClick];
    }    
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"ok" forState:UIControlStateNormal];
        _okBtn.backgroundColor = [UIColor clearColor];
        [_okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(handleOKClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (void)handleOKClick{
    [self.inputTF resignFirstResponder];
    [self.alertDelegate handleOkClickWithValue:self.inputTF.text];
    [self removeFromSuperview];
}

- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView1;
}

- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView2;
}










@end
