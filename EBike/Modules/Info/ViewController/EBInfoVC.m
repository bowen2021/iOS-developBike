//
//  EBInfoVC.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBInfoVC.h"
#import "EBInfoFirstCell.h"
#import "EBInfoSecondCell.h"
#import "EBInfoThirdCell.h"
#import "EBInfoFourthCell.h"
#import "EBInfoFifthCell.h"
#import "EBInfoPorHeaderView.h"
#import "EBUnitView.h"
#import "EBPasswordAlertView.h"
#import "EBBTDataModel.h"
#import "EBHomeVC.h"
#import "EBWheelSpeedView.h"
#import "UIAlertController+TapGesAlertController.h"

@interface EBInfoVC ()<UITableViewDelegate,UITableViewDataSource,EBUnitViewDelegate,EBPasswordAlertViewDelegate>

@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UITableView *porTableView; //竖屏tableView
@property(nonatomic, strong)UITableView *landTableView; //横屏tableView
@property(nonatomic, strong)UITableView *landContentTableView; // 横屏内容tableView

@property(nonatomic, strong)UIImageView *headerViewArrow;

@property(nonatomic, assign)NSInteger batteryNum;
@property(nonatomic, assign)NSInteger runNum;
@property(nonatomic, assign)NSInteger setNum;
@property(nonatomic, assign)NSInteger contentNum;

@property(nonatomic, assign)BOOL isBatteryHeaderSelect;
@property(nonatomic, assign)BOOL isRunHeaderSelect;
@property(nonatomic, assign)BOOL isSetHeaderSelect;

@property(nonatomic, strong)NSArray *landList;

@property(nonatomic, strong)EBUnitView *unitChooseView;
//@property(nonatomic, strong)EBWheelView *wheelChooseView;
//@property(nonatomic, strong)UIScrollView *wheelScrollView;

@property(nonatomic,copy)NSString *unitValue;

@property(nonatomic, strong)EBPasswordAlertView *customAlertView;

@property(nonatomic, assign)CGFloat offsetY;

@property(nonatomic, strong)NSArray *wheelList;
@property(nonatomic, strong)NSArray *maxSpeedList;

@property(nonatomic, assign)BOOL isLoginThree;
@property(nonatomic, assign)BOOL isChooseUnit;
@property(nonatomic, strong)UIView *unitTapView;
@property(nonatomic, strong)UIView *wheelTapView;

@end

@implementation EBInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    EBWeakSelf
    self.isLoginThree = NO;
    self.isChooseUnit = NO;
    self.batteryNum = 0;
    self.runNum = 0;
    self.setNum = 0;
    self.contentNum = 6;
    self.isBatteryHeaderSelect = NO;
    self.isRunHeaderSelect = NO;
    self.isSetHeaderSelect = NO;
    self.landList = @[@{@"image":@"Info_battery",@"title":@"Battery"},@{@"image":@"Info_running",@"title":@"Driver data"},@{@"image":@"Info_set",@"title":@"Settings"}];
    self.wheelList = @[@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35"];
    self.maxSpeedList = @[@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60"];
    self.unitValue = @"km";
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!self.isPortrait) {
        appDelegate.allowRotation = YES;
        [self setNewOrientation:YES];
        [self landscapeConstraints];
    }else{
        appDelegate.allowRotation = NO;
        [self setNewOrientation:NO];
        [self portraitConstraints];
    }
    self.refreshBlock = ^(EBBTDataModel * _Nonnull dataModel) {
        weakSelf.model = dataModel;
        [weakSelf.porTableView reloadData];
        [weakSelf.landTableView reloadData];
        [weakSelf.landContentTableView reloadData];
    };
}

#pragma mark -- 竖屏约束
- (void)portraitConstraints{
    self.landTableView.hidden = YES;
    self.landContentTableView.hidden = YES;
    self.porTableView.hidden = NO;
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.porTableView];
    [self.view addSubview:self.unitTapView];
    [self.view addSubview:self.unitChooseView];
    if (!self.unitChooseView.hidden) {
        self.unitChooseView.hidden = YES;
        self.unitTapView.hidden = YES;
    }
    EBWeakSelf
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_PWIDTH(10));
        make.top.mas_equalTo(SCALE_PWIDTH(30));
        make.width.height.mas_equalTo(SCALE_PWIDTH(30));
    }];
    [self.porTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.backBtn.mas_bottom).mas_offset(SCALE_PWIDTH(10));
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.unitChooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(SCALE_PWIDTH(-5));
        make.width.mas_equalTo(SCALE_PWIDTH(120));
        make.height.mas_equalTo(SCALE_PWIDTH(80));
    }];
}

#pragma mark -- 横屏约束
- (void)landscapeConstraints{
    self.porTableView.hidden = YES;
    self.landTableView.hidden = NO;
    self.landContentTableView.hidden = NO;
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.landTableView];
    [self.view addSubview:self.landContentTableView];
    [self.view addSubview:self.unitTapView];
    [self.view addSubview:self.unitChooseView];
    if (!self.unitChooseView.hidden) {
        self.unitChooseView.hidden = YES;
        self.unitTapView.hidden = YES;
    }
    
    EBWeakSelf
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_LWIDTH(20));
        make.top.mas_equalTo(SCALE_LWIDTH(30));
        make.width.height.mas_equalTo(SCALE_LWIDTH(30));
    }];
    [self.landTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_LWIDTH(10));
        make.top.mas_equalTo(weakSelf.backBtn.mas_bottom).mas_offset(SCALE_LWIDTH(10));
        make.width.mas_equalTo(SCALE_LWIDTH(250));
        make.height.mas_equalTo(SCALE_LWIDTH(150));
    }];
    [self.landContentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.landTableView.mas_right).mas_offset(0);
        make.top.mas_equalTo(SCALE_LWIDTH(22));
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE_LWIDTH(264));
    }];
    [self.unitChooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(SCALE_LWIDTH(-5));
        make.width.mas_equalTo(SCALE_LWIDTH(120));
        make.height.mas_equalTo(SCALE_LWIDTH(80));
    }];
}

#pragma mark -- unitTapView
- (UIView *)unitTapView{
    if (!_unitTapView) {
        _unitTapView = [[UIView alloc]initWithFrame:self.view.bounds];
        _unitTapView.backgroundColor = [UIColor whiteColor];
        _unitTapView.userInteractionEnabled = YES;
        _unitTapView.alpha = 0.05;
        _unitTapView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapViewClick)];
        [_unitTapView addGestureRecognizer:tap];
    }
    return _unitTapView;
}

- (void)handleTapViewClick{
    if (!self.unitChooseView.hidden) {
        EBInfoThirdCell *cell;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            cell = [self.landContentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }else{
            cell = [self.porTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        }
        cell.isSelect = NO;
        self.isChooseUnit = NO;
        self.unitChooseView.hidden = YES;
        self.unitTapView.hidden = YES;
    }
}

#pragma mark -- wheelTapView
- (UIView *)wheelTapView{
    if (!_wheelTapView) {
        _wheelTapView = [[UIView alloc]initWithFrame:self.view.bounds];
        _wheelTapView.backgroundColor = [UIColor whiteColor];
        _wheelTapView.userInteractionEnabled = YES;
        _wheelTapView.alpha = 0.05;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleWheelTapViewClick)];
        [_wheelTapView addGestureRecognizer:tap];
    }
    return _wheelTapView;
}

- (void)handleWheelTapViewClick{
    [self removeWheelView];
    [self.wheelTapView removeFromSuperview];
}

#pragma mark -- 返回按钮
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"Info_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)handleBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 竖屏tableView
- (UITableView *)porTableView{
    if (!_porTableView) {
        _porTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _porTableView.delegate = self;
        _porTableView.dataSource = self;
        _porTableView.backgroundColor = [UIColor clearColor];
        _porTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_porTableView registerClass:[EBInfoFirstCell class] forCellReuseIdentifier:EBInfoFirstCellID];
        [_porTableView registerClass:[EBInfoSecondCell class] forCellReuseIdentifier:EBInfoSecondCellID];
        [_porTableView registerClass:[EBInfoThirdCell class] forCellReuseIdentifier:EBInfoThirdCellID];
        [_porTableView registerClass:[EBInfoFifthCell class] forCellReuseIdentifier:EBInfoFifthCellID];
    }
    return _porTableView;
}

#pragma mark -- 横屏tableView
- (UITableView *)landTableView{
    if (!_landTableView) {
        _landTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _landTableView.delegate = self;
        _landTableView.dataSource = self;
        _landTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _landTableView.backgroundColor = [UIColor clearColor];
        [_landTableView registerClass:[EBInfoFourthCell class] forCellReuseIdentifier:EBInfoFourthCellID];
    }
    return _landTableView;
}

#pragma mark -- 横屏内容tableView
- (UITableView *)landContentTableView{
    if (!_landContentTableView) {
        _landContentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _landContentTableView.delegate = self;
        _landContentTableView.dataSource = self;
        _landContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _landContentTableView.backgroundColor = [UIColor whiteColor];
        [_landContentTableView registerClass:[EBInfoFirstCell class] forCellReuseIdentifier:EBInfoFirstCellID];
        [_landContentTableView registerClass:[EBInfoSecondCell class] forCellReuseIdentifier:EBInfoSecondCellID];
        [_landContentTableView registerClass:[EBInfoThirdCell class] forCellReuseIdentifier:EBInfoThirdCellID];
        [_landContentTableView registerClass:[EBInfoFifthCell class] forCellReuseIdentifier:EBInfoFifthCellID];
    }
    return _landContentTableView;
}

#pragma mark -- customAlertView
- (EBPasswordAlertView *)customAlertView{
    if (!_customAlertView) {
        _customAlertView = [[EBPasswordAlertView alloc]initWithFrame:self.view.bounds];
        _customAlertView.isPortrait = self.isPortrait;
        _customAlertView.alertDelegate = self;
        _customAlertView.inputText = @"";
//        _customAlertView.alertTitle = @"Name";
    }
    return _customAlertView;
}

- (void)handleOkClickWithValue:(NSString *)value{
    switch (self.customAlertView.alertType) {
        case EBAlertPush:
        {
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                [self signinPassword:value tableView:self.landContentTableView indexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            }else{
                [self signinPassword:value tableView:self.porTableView indexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
            }
        }
            break;
        case EBAlertWheel:
        {
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                [self signinPassword:value tableView:self.landContentTableView indexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            }else{
                [self signinPassword:value tableView:self.porTableView indexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
            }
        }
            break;
        case EBAlertMaxspeed:
        {
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                [self signinPassword:value tableView:self.landContentTableView indexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            }else{
                [self signinPassword:value tableView:self.porTableView indexPath:[NSIndexPath indexPathForRow:3 inSection:2]];
            }
        }
            break;
        case EBAlertSetName:
        {
            [self setModuleName:value];
        }
            break;
        case EBAlertSetPassword:
        {
            [self setModulePassword:value];
        }
            break;
        default:
            break;
    }
}

- (void)handleCancelClick{
    [self.customAlertView removeFromSuperview];
    [self.porTableView reloadData];
    [self.landTableView reloadData];
    [self.landContentTableView reloadData];
}

- (NSString *)isBlank:(NSString *)value{
    if (value == nil || value == NULL || [value isEqualToString:@""] || value.length == 0) {
        return @"0";
    }
    return value;
}

#pragma mark -- tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.porTableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"SOC" detail:[self configPerOrivalue:@"0%" value:[NSString stringWithFormat:@"%@%%",[self isBlank:self.model.absoluteCapacity]]] isArrow:NO isWhite:YES];
            }else if (indexPath.row == 1){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"SOH" detail:[self configPerOrivalue:@"0%" value:[NSString stringWithFormat:@"%@%%",[self isBlank:self.model.relativeCapacity]]] isArrow:NO isWhite:YES];
            }else if (indexPath.row == 2){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Temperature" detail:[self configPerOrivalue:@"0.0℃" value:[NSString stringWithFormat:@"%.1f℃",[[self isBlank:self.model.batteryTemperature] floatValue]/10]] isArrow:NO isWhite:YES];
            }else if (indexPath.row == 3){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Cycle count" detail:[self configPerOrivalue:@"0" value:[self isBlank:self.model.cycles]] isArrow:NO isWhite:YES];
            }else if (indexPath.row == 4){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Remain capacity" detail:[self configPerOrivalue:@"0maH" value:[NSString stringWithFormat:@"%@maH",[self isBlank:self.model.remaingCapacity]]] isArrow:NO isWhite:YES];
            }else{
                EBWeakSelf
//                BOOL isLock = [self.model.batteryInfoPermission isEqualToString:@"0"] ? NO :[self.model.batteryLockStatus isEqualToString:@"0"] ? NO:YES;
                BOOL isLock = [self.model.batteryLockStatus isEqualToString:@"0"] ? NO:YES;
                return [self createSecondCellOfTableView:tableView indexPath:indexPath title:@"Lock" isWhite:YES isOn:isLock infoBlock:^{
                    int lock = [self.model.batteryLockStatus isEqualToString:@"0"] ? 1 : 0;
                    [weakSelf handleSendLockData:lock];
                }];
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                return [self createFirstCellOfTableView:self.porTableView indexPath:indexPath title:@"Torque" detail:[NSString stringWithFormat:@"%@N/m",[self isBlank:self.model.torque]] isArrow:NO isWhite:YES];
            }else if (indexPath.row == 1){
                float value = [self.model.electricCurrent floatValue] * [self.model.totalVoltage floatValue] * 0.8;
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Power" detail:[NSString stringWithFormat:@"%.1fW",value] isArrow:NO isWhite:YES];
            }else {
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Cadence" detail:[NSString stringWithFormat:@"%.1fRPM",[self.model.cadence floatValue]] isArrow:NO isWhite:YES];
            }
        }else{
            if (indexPath.row == 0) {
                NSString *value = [self.model.kmMileType isEqualToString:@"0"] ? @"km":@"mile";
                return [self createThirdCellOfTableView:tableView indexPath:indexPath title:@"Unit" detail:value isWhite:YES isHide:NO];
            }else if (indexPath.row == 1) {
                EBWeakSelf
                BOOL isPush = [self.model.pushStatus isEqualToString:@"0"] ? NO:YES;
                return [self createSecondCellOfTableView:tableView indexPath:indexPath title:@"PUSH" isWhite:YES isOn:isPush infoBlock:^{
                    [weakSelf configPushData];
                }];
            }else if (indexPath.row == 2){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Wheel" detail:[self isBlank:self.model.wheel] isArrow:YES isWhite:YES];
            }else if (indexPath.row == 3){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Max speed" detail:[NSString stringWithFormat:@"%@km/h",[self isBlank:self.model.maxSpeed]] isArrow:YES isWhite:YES];
            }else if (indexPath.row == 4){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Name" detail:[EBUserTool getBLEName] isArrow:NO isWhite:YES];
//                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"AppVersion" detail:@"1.0" isArrow:NO isWhite:YES];
            }else if (indexPath.row == 5){
                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"Set Password" isWhite:YES];
//                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Software version" detail:@"0.0" isArrow:NO isWhite:YES];
            }else if (indexPath.row == 6){
                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"clear TRIP" isWhite:YES];
//                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Name" detail:[EBUserTool getBLEName] isArrow:NO isWhite:YES];
            }else if (indexPath.row == 7){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"AppVersion" detail:@"1.0" isArrow:NO isWhite:YES];
//                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"Set Password" isWhite:YES];
            }else{
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Software version" detail:@"0.0" isArrow:NO isWhite:YES];
//                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"clean TRIP" isWhite:YES];
            }
        }
    }else if (tableView == self.landTableView){
        return [self createFourthCellOfIndexPath:indexPath image:self.landList[indexPath.row][@"image"] title:self.landList[indexPath.row][@"title"]];
    }else{
        if (self.contentNum == 6) {
            if (indexPath.row == 0) {
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"SOC" detail:[self configPerOrivalue:@"0%" value:[NSString stringWithFormat:@"%@%%",[self isBlank:self.model.absoluteCapacity]]] isArrow:NO isWhite:NO];
            }else if (indexPath.row == 1){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"SOH" detail:[self configPerOrivalue:@"0%" value:[NSString stringWithFormat:@"%@%%",[self isBlank:self.model.relativeCapacity]]] isArrow:NO isWhite:NO];
            }else if (indexPath.row == 2){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Temperature" detail:[self configPerOrivalue:@"0.0℃" value:[NSString stringWithFormat:@"%.1f℃",[self.model.batteryTemperature floatValue]/10]] isArrow:NO isWhite:NO];
            }else if (indexPath.row == 3){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Cycle count" detail:[self configPerOrivalue:@"0" value:[self isBlank:self.model.cycles]] isArrow:NO isWhite:NO];
            }else if (indexPath.row == 4){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Remain capacity" detail:[self configPerOrivalue:@"0maH" value:[NSString stringWithFormat:@"%@maH",[self isBlank:self.model.remaingCapacity]]] isArrow:NO isWhite:NO];
            }else{
                EBWeakSelf
//                BOOL isLock = [self.model.batteryInfoPermission isEqualToString:@"0"] ? NO :[self.model.batteryLockStatus isEqualToString:@"0"] ? NO:YES;
                BOOL isLock = [self.model.batteryLockStatus isEqualToString:@"0"] ? NO:YES;
                return [self createSecondCellOfTableView:tableView indexPath:indexPath title:@"Lock" isWhite:NO isOn:isLock infoBlock:^{
                    int lock = [self.model.batteryLockStatus isEqualToString:@"0"] ? 1 : 0;
                    [weakSelf handleSendLockData:lock];
                }];
            }
        }else if (self.contentNum == 3){
            if (indexPath.row == 0) {
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Torque" detail:[NSString stringWithFormat:@"%@N/m",[self isBlank:self.model.torque]] isArrow:NO isWhite:NO];
            }else if (indexPath.row == 1){
                // 实时电流*电压总电压*0.8
                float value = [self.model.electricCurrent floatValue] * [self.model.totalVoltage floatValue] * 0.8;
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Power" detail:[NSString stringWithFormat:@"%.1fW",value] isArrow:NO isWhite:NO];
            }else {
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Cadence" detail:[NSString stringWithFormat:@"%.1fRPM",[self.model.cadence floatValue]] isArrow:NO isWhite:NO];
            }
        }else{
            if (indexPath.row == 0) {
                NSString *value = [self.model.kmMileType isEqualToString:@"0"] ? @"km":@"mile";
                return [self createThirdCellOfTableView:tableView indexPath:indexPath title:@"Unit" detail:value isWhite:NO isHide:NO];
            }else if (indexPath.row == 1) {
                EBWeakSelf
                BOOL isPush = [self.model.pushStatus isEqualToString:@"0"] ? NO:YES;
                return [self createSecondCellOfTableView:tableView indexPath:indexPath title:@"PUSH" isWhite:NO isOn:isPush infoBlock:^{
                    [weakSelf configPushData];
                }];
            }else if (indexPath.row == 2){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Wheel" detail:[self isBlank:self.model.wheel] isArrow:YES isWhite:NO];
            }else if (indexPath.row == 3){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Max speed" detail:[NSString stringWithFormat:@"%@km/h",[self isBlank:self.model.maxSpeed]] isArrow:YES isWhite:NO];
            }else if (indexPath.row == 4){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Name" detail:[EBUserTool getBLEName] isArrow:NO isWhite:NO];
//                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"AppVersion" detail:@"1.0" isArrow:NO isWhite:NO];
            }else if (indexPath.row == 5){
                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"Set Password" isWhite:NO];
//                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Software version" detail:@"0.0" isArrow:NO isWhite:NO];
            }else if (indexPath.row == 6){
                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"clear TRIP" isWhite:NO];
//                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Name" detail:[EBUserTool getBLEName] isArrow:NO isWhite:NO];
            }else if (indexPath.row == 7){
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"AppVersion" detail:@"1.0" isArrow:NO isWhite:NO];
//                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"Set Password" isWhite:NO];
            }else{
                return [self createFirstCellOfTableView:tableView indexPath:indexPath title:@"Software version" detail:@"0.0" isArrow:NO isWhite:NO];
//                return [self createFifthCellOfTableView:tableView indexPath:indexPath title:@"clean TRIP" isWhite:NO];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.landTableView) {
        CGFloat landContentH;
        if (indexPath.row == 0) {
//            if ([self.model.batteryInfoPermission isEqualToString:@"1"]) {
                self.contentNum = 6;
                landContentH = SCALE_LWIDTH(264);
//            }else{
//                self.contentNum = 0;
//                landContentH = SCALE_LWIDTH(0);
//            }
        }else if (indexPath.row == 1){
            self.contentNum = 3;
            landContentH = SCALE_LWIDTH(132);
        }else{
            self.contentNum = 9;
            landContentH = SCALE_LWIDTH(308);
        }
        [self.landContentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(landContentH);
        }];
        [self.landContentTableView reloadData];
    }
    if (tableView == self.porTableView) {
        if (![EBUserTool isLogin]) {
            return;
        }
        if (indexPath.section == 0&&indexPath.row == 5) {
            int lock = [self.model.batteryLockStatus isEqualToString:@"0"] ? 1 : 0;
            [self handleSendLockData:lock];
        }
        if (indexPath.section == 2&&indexPath.row == 0) {
            self.isChooseUnit = !self.isChooseUnit;
            [self handleCreateUnitView:self.isChooseUnit];
        }
        if (indexPath.section == 2&&indexPath.row == 1) {
            [self configPushData];
        }
        if (indexPath.section == 2&&indexPath.row == 2){
//            if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
            if (!self.isLoginThree) {
                [self.view addSubview:self.customAlertView];
                self.customAlertView.alertTitle = @"Please Input Password";
                self.customAlertView.inputText = @"";
                self.customAlertView.alertType = EBAlertWheel;
            }else{
                EBWeakSelf
                [self removeWheelView];
                [self.view addSubview:self.wheelTapView];
                CGFloat wheelY = [self getRectOfTableViewCellRect:[self.porTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]]]+[EBTool handleCommonFit:75]-ABS(self.offsetY);
                __block EBWheelSpeedView *view = [self createWheelViewOfDataList:self.wheelList offY:wheelY];
                __weak EBWheelSpeedView *weakView = view;
                view.block = ^(NSString * _Nonnull title) {
                    [weakSelf configWheelData:title view:weakView];
                };
                [self.view addSubview:view];
            }
        }else if (indexPath.section == 2&&indexPath.row == 3){
            if (![EBUserTool isLogin]) {
                return;
            }
//            if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
            if (!self.isLoginThree) {
                [self.view addSubview:self.customAlertView];
                self.customAlertView.inputText = @"";
                self.customAlertView.alertTitle = @"Please Input Password";
                self.customAlertView.alertType = EBAlertMaxspeed;
            }else{
                EBWeakSelf
                [self removeWheelView];
                [self.view addSubview:self.wheelTapView];
                CGFloat wheelY = [self getRectOfTableViewCellRect:[self.porTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]]]+[EBTool handleCommonFit:75]-ABS(self.offsetY);
                __block EBWheelSpeedView *view = [self createWheelViewOfDataList:self.maxSpeedList offY:wheelY];
                __weak EBWheelSpeedView *weakView = view;
                view.block = ^(NSString * _Nonnull title) {
                    [weakSelf configMaxSpeedData:title view:weakView];
                };
                [self.view addSubview:view];
            }
        }else if (indexPath.section == 2&&indexPath.row == 4) {
            if ([EBUserTool isLogin]) {
                [self.view addSubview:self.customAlertView];
                self.customAlertView.inputText = @"";
                self.customAlertView.alertTitle = @"Name";
                self.customAlertView.alertType = EBAlertSetName;
            }
        }else if (indexPath.section == 2&&indexPath.row == 5){
            if ([EBUserTool isLogin]&&[[EBUserTool getUserPasswordLevel]isEqualToString:@"01"]) {
                [self.view addSubview:self.customAlertView];
                self.customAlertView.inputText = @"";
                self.customAlertView.alertTitle = @"Set Password";
                self.customAlertView.alertType = EBAlertSetPassword;
            }
        }else if (indexPath.section == 2&&indexPath.row == 6){
            if ([EBUserTool isLogin]) {
                [self alertSendCleanTripData];
            }
        }
    }
    if (tableView == self.landContentTableView&&self.contentNum == 6) {
        if (indexPath.row == 5) {
            int lock = [self.model.batteryLockStatus isEqualToString:@"0"] ? 1 : 0;
            [self handleSendLockData:lock];
        }
    }
    if (tableView == self.landContentTableView&&self.contentNum == 9) {
        if(indexPath.row == 0){
            self.isChooseUnit = !self.isChooseUnit;
            [self handleCreateUnitView:self.isChooseUnit];
        }else if (indexPath.row == 1) {
            [self configPushData];
        }else if (indexPath.row == 2) {
//            if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
            if (!self.isLoginThree) {
                [self.view addSubview:self.customAlertView];
                self.customAlertView.inputText = @"";
                self.customAlertView.alertTitle = @"Please Input Password";
                self.customAlertView.alertType = EBAlertWheel;
            }else{
                EBWeakSelf
                [self removeWheelView];
                [self.view addSubview:self.wheelTapView];
                CGFloat wheelY = [self.landContentTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].origin.y;
                __block EBWheelSpeedView *view = [self createWheelViewOfDataList:self.wheelList offY:wheelY];
                __weak EBWheelSpeedView *weakView = view;
                view.block = ^(NSString * _Nonnull title) {
                    [weakSelf configWheelData:title view:weakView];
                };
                [self.view addSubview:view];
            }
        }else if (indexPath.row == 3){
            if (![EBUserTool isLogin]) {
                return;
            }
//            if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
            if (!self.isLoginThree) {
                [self.view addSubview:self.customAlertView];
                self.customAlertView.inputText = @"";
                self.customAlertView.alertTitle = @"Please Input Password";
                self.customAlertView.alertType = EBAlertMaxspeed;
            }else{
                EBWeakSelf
                [self removeWheelView];
                [self.view addSubview:self.wheelTapView];
                CGFloat wheelY = [self.landContentTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].origin.y;
                __block EBWheelSpeedView *view = [self createWheelViewOfDataList:self.maxSpeedList offY:wheelY];
                __weak EBWheelSpeedView *weakView = view;
                view.block = ^(NSString * _Nonnull title) {
                    [weakSelf configMaxSpeedData:title view:weakView];
                };
                [self.view addSubview:view];
            }
        }else if (indexPath.row == 4) {
            if (![EBUserTool isLogin]) {
                return;
            }
            [self.view addSubview:self.customAlertView];
            self.customAlertView.inputText = @"";
            self.customAlertView.alertTitle = @"Name";
            self.customAlertView.alertType = EBAlertSetName;
        }else if (indexPath.row == 5){
            if (![EBUserTool isLogin]) {
                return;
            }
            [self.view addSubview:self.customAlertView];
            self.customAlertView.inputText = @"";
            self.customAlertView.alertTitle = @"Set Password";
            self.customAlertView.alertType = EBAlertSetPassword;
        }else if (indexPath.row == 6){
            if ([EBUserTool isLogin]) {
                [self alertSendCleanTripData];
            }
        }
    }
}

#pragma mark -- 创建 EBWheelSpeedView
- (EBWheelSpeedView *)createWheelViewOfDataList:(NSArray *)dataList offY:(CGFloat)offY{
    EBWheelSpeedView *view = [[EBWheelSpeedView alloc]initWithFrame:CGRectMake(kScreenWidth-120, offY, 110, kScreenHeight-offY) dataList:dataList];
    view.backgroundColor = [EBTool colorWithHexString:@"eeeeee"];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    return view;
}

- (void)removeWheelView{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[EBWheelSpeedView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.porTableView) {
        return 3;
    }else if(tableView == self.landTableView){
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.porTableView) {
        if (section == 0) {
            return self.batteryNum;
        }else if (section == 1){
            return self.runNum;
        }else{
            return self.setNum;
        }
    }else if (tableView == self.landTableView){
        return 3;
    }else{
        return self.contentNum;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.landContentTableView) {
        return SCALE_LWIDTH(44);
    }
    return [EBTool handleCommonFit:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.porTableView) {
        return [EBTool handleCommonFit:44];
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.porTableView) {
        if (section == 0) {
            return [self createHeaderViewOfTitle:@"Battery" image:@"Info_battery" tag:1516 isSelect:self.isBatteryHeaderSelect];
        }else if(section == 1){
            return [self createHeaderViewOfTitle:@"Driver data" image:@"Info_running" tag:1517 isSelect:self.isRunHeaderSelect];
        }else{
            return [self createHeaderViewOfTitle:@"Settings" image:@"Info_set" tag:1518 isSelect:self.isSetHeaderSelect];
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self removeWheelView];
    self.offsetY = scrollView.contentOffset.y;
    if (!self.unitChooseView.hidden) {
        self.unitChooseView.hidden = YES;
        self.unitTapView.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat unitY = [self getRectOfTableViewCellRect:[self.porTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]];
    [self.unitChooseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unitY);
    }];
}

- (CGFloat)getRectOfTableViewCellRect:(CGRect)rect{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        return CGRectGetMaxY(self.landContentTableView.frame);
    }else{
        return CGRectGetMaxY(rect);
    }
}


#pragma mark -- 竖屏表头
- (UIView *)createHeaderViewOfTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag isSelect:(BOOL)isSelect{
    
    EBInfoPorHeaderView *headerView = [[EBInfoPorHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, SCALE_PWIDTH(44))];
    headerView.tag = tag;
    headerView.title = title;
    headerView.image = image;
    headerView.isSelect = isSelect;
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag-1516;
    if (tag == 0) {
        if ([EBUserTool isLogin]) {
//            if ([self.model.batteryInfoPermission isEqualToString:@"1"]) {
                self.batteryNum = self.batteryNum == 6 ? 0 : 6;
                self.isBatteryHeaderSelect = self.batteryNum == 6 ? YES : NO;
//            }
        }else{
            self.batteryNum = self.batteryNum == 6 ? 0 : 6;
            self.isBatteryHeaderSelect = self.batteryNum == 6 ? YES : NO;
        }
    }else if (tag == 1){
        self.runNum = self.runNum == 3 ? 0 : 3;
        self.isRunHeaderSelect = self.runNum == 3 ? YES : NO;
    }else{
        self.setNum = self.setNum == 9 ? 0 : 9;
        self.isSetHeaderSelect = self.setNum == 9 ? YES : NO;
    }
    [self.porTableView reloadData];
}

#pragma mark -- 电池权限信息调整
/**
 电池权限信息调整
 */
- (NSString *)configPerOrivalue:(NSString *)oriValue value:(NSString *)value{
    if ([self.model.batteryInfoPermission isEqualToString:@"1"]) {
        return value;
    }
    return oriValue;
}

#pragma mark -- firstCell
- (EBInfoFirstCell *)createFirstCellOfTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath title:(NSString *)title detail:(NSString *)detail isArrow:(BOOL)isArrow isWhite:(BOOL)isWhite{
    EBInfoFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:EBInfoFirstCellID forIndexPath:indexPath];
    cell.titleValue = title;
    cell.detailValue = detail;
    cell.isArrow = isArrow;
    cell.isWhite = isWhite;
    return cell;
}

#pragma mark -- secondCell
- (EBInfoSecondCell *)createSecondCellOfTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath title:(NSString *)title isWhite:(BOOL)isWhite isOn:(BOOL)isOn infoBlock:(InfoSecondBlock)infoBlock{
    EBInfoSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:EBInfoSecondCellID forIndexPath:indexPath];
    cell.titleValue = title;
    cell.isWhite = isWhite;
    cell.isSwitchOn = isOn;
    cell.infoBlock = infoBlock;
    return cell;
}

#pragma mark -- thirdCell
- (EBInfoThirdCell *)createThirdCellOfTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath title:(NSString *)title detail:(NSString *)detail isWhite:(BOOL)isWhite isHide:(BOOL)isHideArrow{
    EBWeakSelf
    EBInfoThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:EBInfoThirdCellID forIndexPath:indexPath];
    cell.titleValue = title;
    cell.detailValue = detail;
    cell.isWhite = isWhite;
    cell.isHideArrow = isHideArrow;
    cell.clickBlock = ^(BOOL isClick) {
        [weakSelf handleCreateUnitView:isClick];
    };
    return cell;
}

- (void)handleCreateUnitView:(BOOL)isClick{
    CGRect unitRect = [self.porTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    CGFloat unitY;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        unitY = CGRectGetMinY(self.landContentTableView.frame)+SCALE_LWIDTH(44);
    }else{
        unitY = CGRectGetMaxY(unitRect)+[EBTool handleCommonFit:88]-ABS(self.offsetY);
    }
    [self.unitChooseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unitY);
    }];
    self.unitChooseView.hidden = !isClick;
    self.unitTapView.hidden = !isClick;
}


#pragma mark -- fourthCell
- (EBInfoFourthCell *)createFourthCellOfIndexPath:(NSIndexPath *)indexPath image:(NSString *)image title:(NSString *)title{
    EBInfoFourthCell *cell = [self.landTableView dequeueReusableCellWithIdentifier:EBInfoFourthCellID forIndexPath:indexPath];
    cell.imageValue = image;
    cell.titleValue = title;
    return cell;
}

#pragma mark -- fifthCell
- (EBInfoFifthCell *)createFifthCellOfTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath title:(NSString *)title isWhite:(BOOL)isWhite{
    EBInfoFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:EBInfoFifthCellID forIndexPath:indexPath];
    cell.titleValue = title;
    cell.isWhite = isWhite;
    return cell;
}

#pragma mark -- unitChooseView
- (EBUnitView *)unitChooseView{
    if (!_unitChooseView) {
        _unitChooseView = [[EBUnitView alloc]init];
        _unitChooseView.userInteractionEnabled = YES;
        _unitChooseView.layer.cornerRadius = 3;
        _unitChooseView.layer.masksToBounds = YES;
        _unitChooseView.hidden = YES;
        _unitChooseView.backgroundColor = [EBTool colorWithHexString:@"eeeeee"];
        _unitChooseView.unitDelegate = self;
    }
    return _unitChooseView;
}

- (void)chooseUnitOfTitle:(NSString *)title{
    EBInfoThirdCell *cell;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        cell = [self.landContentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.unitValue = title;
        [self.landContentTableView reloadData];
    }else{
        cell = [self.porTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        self.unitValue = title;
        [self.porTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self handleCreateUnitView:NO];
    cell.isSelect = NO;
    if ([title isEqualToString:@"km"]) {
        [self handleSendKmMileData:0];
    }else{
        [self handleSendKmMileData:1];
    }
}

#pragma mark -- 发送修改名字
- (void)setModuleName:(NSString *)name{
    int length = (int)name.length;
    if (length>7) {
        [SVProgressHUD showInfoWithStatus:@"length limit 7"];
        [self.view addSubview:self.customAlertView];
        return;
    }
    Byte byte[5+length];
    memset(byte, 0, 5+length * sizeof(Byte));
    byte[0] = 0xFA;
    byte[1] = 0x55;
    byte[2] = 0x06;
    NSString *binary = [EBTool getBinaryByDecimal:name.length];
    if (binary.length == 4) {
        binary = [NSString stringWithFormat:@"0000%@",binary];
    }
    byte[3] = (Byte)([self getByteOfStr:binary index:0]<<7 | [self getByteOfStr:binary index:1]<<6 |[self getByteOfStr:binary index:2]<<5 |[self getByteOfStr:binary index:3]<<4 |[self getByteOfStr:binary index:4]<<3 |[self getByteOfStr:binary index:5]<<2 |[self getByteOfStr:binary index:6]<<1 |[self getByteOfStr:binary index:7]<<0);
    NSData *data = [name dataUsingEncoding:NSASCIIStringEncoding];
    Byte *stringByte = (Byte *)[data bytes];
    memcpy(byte + 4*sizeof(Byte), stringByte , length*sizeof(Byte));
    int a = 0;
    for (int i = 2; i<4+length; i++) {
        a += byte[i];
    }
    byte[4+length] = a;
    NSLog(@"data abc abc=%@",data);
    
    NSData *sendData = [NSData dataWithBytes:byte length:5+length];
    EBWeakSelf
    [[BLEManager shareManager]sendData:sendData complete:^(NSString *content) {
        NSLog(@"修改名字%@",content);//修改名字fa55060006
        if ([content isEqualToString:@"fa55060006"]) {
            [EBUserTool setBLEName:name];
            [weakSelf.porTableView reloadData];
            [weakSelf.landContentTableView reloadData];
        }
    }];
}

#pragma mark -- 发送修改密码
- (void)setModulePassword:(NSString *)password{
    EBWeakSelf
    int length = (int)password.length;
    if (length != 6) {
        [SVProgressHUD showInfoWithStatus:@"Length Limit 6"];
        return;
    }
    Byte byte[11];
    memset(byte, 0, 11 * sizeof(Byte));
    byte[0] = 0xFA;
    byte[1] = 0x55;
    byte[2] = 0x11;
    byte[3] = 0x06;
    NSData *data = [password dataUsingEncoding:NSASCIIStringEncoding];
    Byte *stringByte = (Byte *)[data bytes];
    memcpy(byte + 4*sizeof(Byte), stringByte , length*sizeof(Byte));
    int a = 0;
    for (int i = 2; i<10; i++) {
        a += byte[i];
    }
    byte[10] = a;
    NSData *sendData = [NSData dataWithBytes:byte length:11];
    [[BLEManager shareManager]sendData:sendData complete:^(NSString *content) {
        NSLog(@"修改密码%@",content);//
        [weakSelf handlePassword:password content:content];
    }];
}

#pragma mark -- 处理修改密码的返回数据
- (void)handlePassword:(NSString *)password content:(NSString *)content{
    NSString *result = [content substringWithRange:NSMakeRange(8, 2)];
    if ([result isEqualToString:@"00"]) {
        [SVProgressHUD showInfoWithStatus:@"set password success"];
        [EBUserTool setUserPassword:@""];
    }else{
        [SVProgressHUD showInfoWithStatus:@"set password fail"];
    }
}

#pragma mark -- 登陆二三级密码
- (void)signinPassword:(NSString *)password tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    int length = (int)password.length;
    Byte byte[17];
    memset(byte, 0, 5+length * sizeof(Byte));
    byte[0] = 0xFA;
    byte[1] = 0x55;
    byte[2] = 0x10;
    byte[3] = 0x0C;

    NSData *data = [password dataUsingEncoding:NSASCIIStringEncoding];
    Byte *stringByte = (Byte *)[data bytes];
    memcpy(byte + 4*sizeof(Byte), stringByte , length*sizeof(Byte));
    int a = 0;
    for (int i = 2; i<16; i++) {
        a += byte[i];
    }
    byte[16] = a;
    EBWeakSelf
    [[BLEManager shareManager]sendData:[NSData dataWithBytes:byte length:17] complete:^(NSString *content) {
        NSLog(@"登陆二三级密码结果%@",content);
        [weakSelf handlePassword:content tableView:tableView indexPath:indexPath];
    }];
}

#pragma mark -- 处理输入二三级密码的返回数据
- (void)handlePassword:(NSString *)password tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *result = [password substringWithRange:NSMakeRange(8, 2)];
    if ([result isEqualToString:@"00"]) {
        [SVProgressHUD showInfoWithStatus:@"password error"];
        self.isLoginThree = NO;
    }else if ([result isEqualToString:@"03"]){
        self.isLoginThree = YES;
    }else{
        self.isLoginThree = NO;
    }
}

/**
 修改lock数据
 */
- (void)handleSendLockData:(int)lock{
    EBWeakSelf
    int a1 = lock;
    int a2 = [self.model.kmMileType intValue];
    int a3 = [self.model.pushStatus intValue];
    int a4 = [self.model.lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[7] = 0x0b;
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
        NSLog(@"修改Lock数据%@",content);
        [weakSelf configNotiRefresh];
    }];

//    [[BLEManager shareManager]sendData:[NSData dataWithBytes:byte length:8] complete:nil];
}

/**
 修改km mile
 */
- (void)handleSendKmMileData:(int)kmMile{
    EBWeakSelf
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = kmMile;
    int a3 = [self.model.pushStatus intValue];
    int a4 = [self.model.lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[7] = 0x0b;
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
        NSLog(@"修改kmmile%@",content);
        [weakSelf configNotiRefresh];
    }];
//    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:nil];
}

#pragma mark -- 弹出cleantrip
- (void)alertSendCleanTripData{
    EBWeakSelf
    UIAlertController *tripAlertC = [UIAlertController alertControllerWithTitle:@"clean trip ?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleSendCleanTripData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [tripAlertC addAction:okAction];
    [tripAlertC addAction:cancelAction];
    [self presentViewController:tripAlertC animated:YES completion:^{
        [tripAlertC tapGesAlert];
    }];
}

- (void)handleSendCleanTripData{
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = [self.model.kmMileType intValue];
    int a3 = [self.model.pushStatus intValue];
    int a4 = [self.model.lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[2] = 0x03;
    byte[3] = 0xaa;
    byte[7] = 0x0b;
//    EBWeakSelf
//    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
//        NSLog(@"cleantrip数据%@",content);
//        [weakSelf configNotiRefresh];
//    }];
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:nil];
}

- (void)configWheelData:(NSString *)value view:(EBWheelSpeedView *)view{
//    if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
    if (!self.isLoginThree) {
        [self.view addSubview:self.customAlertView];
        self.customAlertView.inputText = @"";
        self.customAlertView.alertTitle = @"Please Input Password";
        self.customAlertView.alertType = EBAlertWheel;
    }else{
        [view removeFromSuperview];
        [self.wheelTapView removeFromSuperview];
        [self handleSendWheelData:value];
    }
}
/**
 修改wheel 轮径值
 */
- (void)handleSendWheelData:(NSString *)value{
    EBWeakSelf
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = [self.model.kmMileType intValue];
    int a3 = [self.model.pushStatus intValue];
    int a4 = [self.model.lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[2] = 0x01;
    NSString *binary = [EBTool getBinaryByDecimal:[value integerValue]];
    if (binary.length == 4) {
        binary = [NSString stringWithFormat:@"0000%@",binary];
    }
    byte[3] = (Byte)([self getByteOfStr:binary index:0]<<7 | [self getByteOfStr:binary index:1]<<6 |[self getByteOfStr:binary index:2]<<5 |[self getByteOfStr:binary index:3]<<4 |[self getByteOfStr:binary index:4]<<3 |[self getByteOfStr:binary index:5]<<2 |[self getByteOfStr:binary index:6]<<1 |[self getByteOfStr:binary index:7]<<0);
    byte[7] = 0x0b;
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
        NSLog(@"修改wheel数据%@",content);
        [weakSelf configNotiRefresh];
    }];
//    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:nil];
}

- (void)configMaxSpeedData:(NSString *)value view:(EBWheelSpeedView *)view{
//    if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
    if (!self.isLoginThree) {
        [self.view addSubview:self.customAlertView];
        self.customAlertView.inputText = @"";
        self.customAlertView.alertTitle = @"Please Input Password";
        self.customAlertView.alertType = EBAlertWheel;
    }else{
        [view removeFromSuperview];
        [self.wheelTapView removeFromSuperview];
        [self handleSendMaxSpeedData:value];
    }
}
/**
 修改maxSpeed
 */
- (void)handleSendMaxSpeedData:(NSString *)value{
    EBWeakSelf
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = [self.model.kmMileType intValue];
    int a3 = [self.model.pushStatus intValue];
    int a4 = [self.model.lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[2] = 0x02;
    NSString *binary = [EBTool getBinaryByDecimal:[value integerValue]];
    if (binary.length == 4) {
        binary = [NSString stringWithFormat:@"0000%@",binary];
    }
    byte[3] = (Byte)([self getByteOfStr:binary index:0]<<7 | [self getByteOfStr:binary index:1]<<6 |[self getByteOfStr:binary index:2]<<5 |[self getByteOfStr:binary index:3]<<4 |[self getByteOfStr:binary index:4]<<3 |[self getByteOfStr:binary index:5]<<2 |[self getByteOfStr:binary index:6]<<1 |[self getByteOfStr:binary index:7]<<0);
    byte[7] = 0x0b;
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
        NSLog(@"修改maxSpeed数据%@",content);
        [weakSelf configNotiRefresh];
    }];
//    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:nil];
}

- (int)getByteOfStr:(NSString *)str index:(NSInteger)index{
    
    NSString *value = [str substringWithRange:NSMakeRange(index, 1)];
    return [value intValue];
}


- (void)configPushData{
    if ([EBUserTool isLogin]) {
//        if (![[EBUserTool getUserPasswordLevel]isEqualToString:@"03"]) {
        if (!self.isLoginThree) {
            [self.view addSubview:self.customAlertView];
            self.customAlertView.inputText = @"";
            self.customAlertView.alertTitle = @"Please Input Password";
            self.customAlertView.alertType = EBAlertWheel;
        }else{
            [self handleSendPushData];
        }
    }
}

/**
 修改推行数据
 */
- (void)handleSendPushData{
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = [self.model.kmMileType intValue];
    int pushData = [self.model.pushStatus isEqualToString:@"0"] ? 1 : 0;
    int a3 = pushData;
    int a4 = [self.model.lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[7] = 0x0b;
//    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
//        NSLog(@"修改推行数据%@",content);
//        [weakSelf configNotiRefresh];
//    }];
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:nil];
    [self handleCancelClick];
}

// 刷新数据
- (void)configNotiRefresh{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCenterHome object:nil];
}

@end
