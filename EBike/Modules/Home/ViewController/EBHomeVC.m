//
//  EBHomeVC.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBHomeVC.h"
#import "EBInfoVC.h"
#import "XSDashboardProgressView.h"
#import "EBBlueToothVC.h"
/*
 
 问题：速度数据 & TRIP数据 & ODO数据 需要根据unit单位选择不同切换显示格式
 当uint为KM时 速度数据数据为KM/h  TRIP数据KM  ODO数据KM
 当uint为mile时  速度数据为速度数据÷1.609 单位为MPH  TRIP数据÷1.609 单位为mile  ODO数据÷1.609 单位为mile
 
 580204FF00F800FF0A00001027900B10A43232320064003200AA0000000000000000001E00FF00000000320E3200000B
 
 58F204FF00F800FF0A00001027900B10A43232320064002000000000000000000000001E00FF0000000034000000000B
 
 */


@interface EBHomeVC ()<BLE_ConnectDelegate>

@property(nonatomic, strong)UIButton    *setBtn;
@property(nonatomic, strong)UIButton    *btBtn; // 蓝牙按钮
@property(nonatomic, strong)XSDashboardProgressView *speedView;
@property(nonatomic, strong)UILabel     *kmhLabel;
@property(nonatomic, strong)UILabel     *speedLabel;
@property(nonatomic, strong)UIImageView *warnImgView;
@property(nonatomic, strong)UILabel     *warnNumLabel;
@property(nonatomic, strong)UILabel     *addNumLabel;
@property(nonatomic, strong)UIButton    *addBtn; //加
@property(nonatomic, strong)UIButton    *subBtn; //减
@property(nonatomic, strong)UILabel     *EBNameLabel;
@property(nonatomic, strong)UILabel     *TRIPLabel;
@property(nonatomic, strong)UILabel     *TRIPNumLabel;
@property(nonatomic, strong)UILabel     *ODOLabel;
@property(nonatomic, strong)UILabel     *ODONumLabel;
@property(nonatomic, strong)UIImageView *batteryImgView;//电池图片
@property(nonatomic, strong)UIView      *batteryView;   //电量 Orientation
@property(nonatomic, strong)UILabel     *batteryLabel;
@property(nonatomic, strong)UIButton    *changeOriBtn; //手动横竖屏按钮
@property(nonatomic, strong)UIImageView *lightImgView; //大灯开关状态
@property(nonatomic, strong)UISwitch    *lightSwitch;

@property(nonatomic, strong)NSMutableArray *dataList;

@property(nonatomic,copy)NSString *firstStr;
@property(nonatomic,copy)NSString *secondStr;
@property(nonatomic,copy)NSString *thirdStr;
@property(nonatomic,copy)NSString *moduleStr;
@property(nonatomic, strong)EBBTDataModel *model;
@property(nonatomic, assign)BOOL isPortrait;

@property(nonatomic, strong)EBInfoVC *infoVC;

@property(nonatomic, assign)CGFloat batteryWidth;

@property(nonatomic,strong)CBPeripheral *autoPeripheral;

@end

@implementation EBHomeVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([EBUserTool isLogin]) {
        NSData *data = [NSData data];
        [[BLEManager shareManager]sendData:data isWrite:NO];
        [BLEManager shareManager].bleConnectDelegate = self;
        [self handleHomeRequest];
        self.btBtn.selected = YES;
        self.EBNameLabel.text = [EBUserTool getBLEName];
    }else{
        self.btBtn.selected = NO;
        self.EBNameLabel.text = @"Name";
        if (![EBTool isBlank:[EBUserTool getBLEMac]]) {
            [self AutoLink];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPortrait = YES;
    [self createView];
    [self portraitConstraints];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleHomeRequest) name:kNotificationCenterHome object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disconnectBLE) name:kNotificationDisconnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlePoweroff) name:kNotificationPoweroff object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AutoLink) name:kNotiDisconnectAuto object:nil];
}

- (void)AutoLink{
    
    [SVProgressHUD show];
    [[BLEManager shareManager]scanForDevicesWithAllBlocks:^(CBPeripheral *peripheral, NSNumber *RSSI, NSString *mac) {
        
        if ([mac isEqualToString:[EBUserTool getBLEMac]]) {
            [[BLEManager shareManager] didStopScan];
            [[BLEManager shareManager]didConnecPeripheral:peripheral timer:60];
            [BLEManager shareManager].bleConnectDelegate = self;
        }
    }];
    
    
}

- (void)handlePoweroff{
    [SVProgressHUD showInfoWithStatus:@"Power off"];
    self.btBtn.selected = NO;
    [EBUserTool setLogin:NO];
    [EBUserTool clearData];
    [self clearViewData];
    self.model = [[EBBTDataModel alloc]init];
    if (self.infoVC) {
        self.infoVC.refreshBlock(self.model);
    }
}

- (void)disconnectBLE{
    self.btBtn.selected = NO;
    [EBUserTool setLogin:NO];
    [EBUserTool clearData];
    [self clearViewData];
    self.model = [[EBBTDataModel alloc]init];
    if (self.infoVC) {
        self.infoVC.refreshBlock(self.model);
    }
}

#pragma mark -- 通知方法
- (void)handleHomeRequest{

    
}

#pragma mark ble delegate
- (void)onConnectResult:(CBPeripheral *)peripheral isSuccess:(BOOL)isSuccess{
    EBWeakSelf
    if (isSuccess) {
        if ([EBUserTool getUserPassword].length > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.autoPeripheral = peripheral;
                [weakSelf delaysend];
            });
        }else{
            self.btBtn.selected = NO;
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"连接失败"];
        }
    }
}

- (void)delaysend{
    NSData *passwordData = [self setPassword:[EBUserTool getUserPassword]];
    [[BLEManager shareManager]sendData:passwordData complete:^(NSString *content) {
        NSLog(@"输入的密码结果%@",content);
        [self handlePassword:[EBUserTool getUserPassword] content:content];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -- 处理输入密码的返回数据
- (void)handlePassword:(NSString *)password content:(NSString *)content{
    NSString *result = [content substringWithRange:NSMakeRange(8, 2)];
    if ([result isEqualToString:@"00"]) {
        [SVProgressHUD showInfoWithStatus:@"password error"];
        [EBUserTool setLogin:NO];
    }else{
        [EBUserTool setLogin:YES];
        [EBUserTool setBLEName:self.autoPeripheral.name];
        self.EBNameLabel.text = [EBUserTool getBLEName];
        if ([result isEqualToString:@"01"]) {
            [EBUserTool setUserPassword:password];
            [EBUserTool setUserPasswordLevel:result];
        }
        self.btBtn.selected = YES;
        [[BLEManager shareManager] removeTimer];
    }
}

- (NSData *)setPassword:(NSString *)string{
    if (string.length == 12) {
        int length = (int)string.length;
        Byte byte[17];
        memset(byte, 0, 17 * sizeof(Byte));
        byte[0] = 0xFA;
        byte[1] = 0x55;
        byte[2] = 0x10;
        byte[3] = 0x0C;
        
        NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
        Byte *stringByte = (Byte *)[data bytes];
        memcpy(byte + 4*sizeof(Byte), stringByte , length*sizeof(Byte));
        int a = 0;
        for (int i = 2; i<16; i++) {
            a += byte[i];
        }
        byte[16] = a;
        return [NSData dataWithBytes:byte length:17];
    }
    
    int length = (int)string.length;
    Byte byte[11];
    memset(byte, 0, 11 * sizeof(Byte));
    byte[0] = 0xFA;
    byte[1] = 0x55;
    byte[2] = 0x10;
    byte[3] = 0x06;
    
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    Byte *stringByte = (Byte *)[data bytes];
    memcpy(byte + 4*sizeof(Byte), stringByte , length*sizeof(Byte));
    int a = 0;
    for (int i = 2; i<10; i++) {
        a += byte[i];
    }
    byte[10] = a;
    return [NSData dataWithBytes:byte length:11];
}


- (void)onSendResult:(NSString *)result{

    EBWeakSelf
//    NSData *data = [NSData data];
//    [[BLEManager shareManager]sendData:data complete:^(NSString *content) {
        if ([result hasPrefix:@"58"]) {
            weakSelf.firstStr = result;
        }else if([result hasSuffix:@"0b"]||[result hasSuffix:@"0B"]){
            weakSelf.thirdStr = result;
        }else{
            weakSelf.secondStr = result;
        }
        if (weakSelf.firstStr.length > 0&&weakSelf.secondStr.length>0&&weakSelf.thirdStr.length>0) {
            weakSelf.moduleStr = [[weakSelf.firstStr stringByAppendingString:weakSelf.secondStr] stringByAppendingString:weakSelf.thirdStr];
            [weakSelf handleGetData:weakSelf.moduleStr];
            weakSelf.firstStr = @"";
            weakSelf.secondStr = @"";
            weakSelf.thirdStr = @"";
        }
//    }];
}


#pragma mark -- 创建视图
- (void)createView{
    [self.view addSubview:self.setBtn];
    [self.view addSubview:self.speedView];
    [self.view addSubview:self.btBtn];
    [self.speedView addSubview:self.kmhLabel];
    [self.speedView addSubview:self.speedLabel];
    [self.speedView addSubview:self.warnImgView];
    [self.speedView addSubview:self.warnNumLabel];
    [self.view addSubview:self.addNumLabel];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.subBtn];
    [self.view addSubview:self.EBNameLabel];
    [self.view addSubview:self.TRIPLabel];
    [self.view addSubview:self.TRIPNumLabel];
    [self.view addSubview:self.ODOLabel];
    [self.view addSubview:self.ODONumLabel];
    [self.view addSubview:self.batteryView];
    [self.view addSubview:self.batteryImgView];
    [self.view addSubview:self.batteryLabel];
    [self.view addSubview:self.changeOriBtn];
//    [self.view addSubview:self.lightSwitch];
//    [self.view addSubview:self.lightImgView];
}

/**
 直立约束
 */
- (void)portraitConstraints{
    EBWeakSelf
    [self.setBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_PWIDTH(10));
        make.top.mas_equalTo(SCALE_PWIDTH(64));
        make.height.width.mas_equalTo(SCALE_PWIDTH(40));
    }];
    [self.btBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SCALE_PWIDTH(10));
        make.top.mas_equalTo(SCALE_PWIDTH(64));
        make.height.width.mas_equalTo(SCALE_PWIDTH(30));
    }];
    [self.speedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(SCALE_PWIDTH(94));
        make.height.mas_equalTo(SCALE_PWIDTH(260));
        make.width.mas_equalTo(SCALE_PWIDTH(300));
    }];
    self.speedView.outerRadius = SCALE_PWIDTH(130);
    self.speedView.innerRadius = SCALE_PWIDTH(113);
    [_speedView addLeftCurve];
    [_speedView addRightCurve];
    
    [self.speedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.speedView.mas_centerY);
    }];
    [self.kmhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.speedLabel.mas_top).mas_offset(SCALE_PWIDTH(-10));
    }];
    [self.warnImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX).mas_offset(SCALE_PWIDTH(-10));
        make.bottom.mas_equalTo(weakSelf.speedView.mas_bottom).mas_offset(SCALE_PWIDTH(-40));
//        make.bottom.mas_equalTo(weakSelf.speedView.mas_top).mas_offset(-SCALE_PWIDTH(10));
    }];
    [self.warnNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.warnImgView.mas_centerY);
        make.left.mas_equalTo(weakSelf.warnImgView.mas_right).mas_offset(SCALE_PWIDTH(7));
    }];
    [self.addNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(weakSelf.speedView.mas_bottom);
    }];
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.addNumLabel.mas_left).mas_offset(SCALE_PWIDTH(-15));
        make.centerY.mas_equalTo(weakSelf.addNumLabel.mas_centerY);
        make.width.height.mas_equalTo(SCALE_PWIDTH(50));
    }];
    [self.subBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.addNumLabel.mas_right).mas_offset(SCALE_PWIDTH(15));
        make.centerY.mas_equalTo(weakSelf.addNumLabel.mas_centerY);
        make.width.height.mas_equalTo(SCALE_PWIDTH(50));
    }];
    [self.EBNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.addNumLabel.mas_bottom).mas_offset(SCALE_PWIDTH(30));
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [self.TRIPLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.EBNameLabel.mas_bottom).mas_offset(SCALE_PWIDTH(30));
        make.right.mas_equalTo(weakSelf.view.mas_centerX).mas_offset(SCALE_PWIDTH(-20));
    }];
    [self.TRIPNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.TRIPLabel.mas_right).mas_offset(SCALE_PWIDTH(5));
        make.top.mas_equalTo(weakSelf.TRIPLabel.mas_bottom).mas_offset(SCALE_PWIDTH(10));
    }];
    [self.ODOLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_centerX).mas_offset(SCALE_PWIDTH(20));
        make.centerY.mas_equalTo(weakSelf.TRIPLabel.mas_centerY);
    }];
    [self.ODONumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.ODOLabel.mas_left).mas_offset(SCALE_PWIDTH(-5));
        make.top.mas_equalTo(weakSelf.ODOLabel.mas_bottom).mas_offset(SCALE_PWIDTH(10));
    }];
    [self.batteryImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_PWIDTH(20));
        make.bottom.mas_equalTo(SCALE_PWIDTH(-15));
        make.width.mas_equalTo(SCALE_PWIDTH(41));
        make.height.mas_equalTo(SCALE_PWIDTH(35));
    }];
//    CGFloat batteryValue = [self.model.batteryPower floatValue]/100;
//    CGFloat batteryW = 0.8 * SCALE_PWIDTH(35);
//    [self.batteryView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(batteryW);
//    }];
    [self.batteryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.batteryImgView.mas_left).mas_offset(SCALE_PWIDTH(2));
        make.centerY.mas_equalTo(weakSelf.batteryImgView.mas_centerY);
        make.height.mas_equalTo(SCALE_PWIDTH(15));
        make.width.mas_equalTo(weakSelf.batteryWidth);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.batteryImgView.mas_right).mas_offset(SCALE_PWIDTH(2));
        make.centerY.mas_equalTo(weakSelf.batteryImgView.mas_centerY);
    }];
    [self.changeOriBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.batteryImgView.mas_centerY);
        make.width.height.mas_equalTo(SCALE_PWIDTH(40));
    }];
//    [self.lightSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(SCALE_PWIDTH(-15));
//        make.centerY.mas_equalTo(weakSelf.changeOriBtn.mas_centerY);
//    }];
//    [self.lightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(weakSelf.lightSwitch.mas_left).mas_offset(SCALE_PWIDTH(10));
//        make.centerY.mas_equalTo(weakSelf.lightSwitch.mas_centerY);
//        make.width.mas_equalTo(SCALE_PWIDTH(45));
//        make.height.mas_equalTo(SCALE_PWIDTH(40));
//    }];
    
    
}

/**
 横向约束
 */
- (void)landscapeConstraints{
    EBWeakSelf
    [self.speedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_LWIDTH(20));
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY).mas_offset(SCALE_LWIDTH(20));
        make.height.mas_equalTo(SCALE_LWIDTH(260));
        make.width.mas_equalTo(SCALE_LWIDTH(300));
    }];
    self.speedView.outerRadius = SCALE_LWIDTH(130);
    self.speedView.innerRadius = SCALE_LWIDTH(113);
    [_speedView addLeftCurve];
    [_speedView addRightCurve];
    [self.speedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.speedView.mas_centerY);
    }];
    [self.kmhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.speedLabel.mas_top).mas_offset(SCALE_LWIDTH(-10));
    }];
    [self.warnImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX).mas_offset(SCALE_LWIDTH(-10));
        make.bottom.mas_equalTo(weakSelf.speedView.mas_bottom).mas_offset(SCALE_LWIDTH(-40));
//        make.bottom.mas_equalTo(weakSelf.speedView.mas_top).mas_offset(-SCALE_LWIDTH(10));
    }];
    [self.warnNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.warnImgView.mas_centerY);
        make.left.mas_equalTo(weakSelf.warnImgView.mas_right).mas_offset(SCALE_LWIDTH(7));
    }];
//    [self.btBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(weakSelf.speedView.mas_centerX);
////        make.top.mas_equalTo(weakSelf.warnNumLabel.mas_bottom).mas_equalTo(SCALE_LWIDTH(15));
//        make.bottom.mas_equalTo(weakSelf.speedView.mas_bottom).mas_offset(SCALE_LWIDTH(-40));
//        make.width.height.mas_equalTo(SCALE_LWIDTH(30));
//    }];
    [self.EBNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALE_LWIDTH(40));
        make.left.mas_equalTo(weakSelf.speedView.mas_right).mas_offset(SCALE_LWIDTH(10));
        make.width.mas_equalTo(SCALE_LWIDTH(230));
    }];
    [self.addNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.EBNameLabel.mas_centerX);
        make.top.mas_equalTo(weakSelf.EBNameLabel.mas_bottom).mas_offset(SCALE_LWIDTH(15));
    }];
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.addNumLabel.mas_left).mas_offset(SCALE_LWIDTH(-15));
        make.centerY.mas_equalTo(weakSelf.addNumLabel.mas_centerY);
        make.width.height.mas_equalTo(SCALE_LWIDTH(50));
    }];
    [self.subBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.addNumLabel.mas_right).mas_offset(SCALE_LWIDTH(15));
        make.centerY.mas_equalTo(weakSelf.addNumLabel.mas_centerY);
        make.width.height.mas_equalTo(SCALE_LWIDTH(50));
    }];
    [self.TRIPLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.addNumLabel.mas_bottom).mas_offset(SCALE_LWIDTH(15));
        make.centerX.mas_equalTo(weakSelf.addNumLabel.mas_centerX);
    }];
    [self.TRIPNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.TRIPLabel.mas_centerX);
        make.top.mas_equalTo(weakSelf.TRIPLabel.mas_bottom).mas_offset(SCALE_LWIDTH(6));
    }];
    [self.ODOLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.TRIPNumLabel.mas_bottom).mas_offset(SCALE_LWIDTH(15));
        make.centerX.mas_equalTo(weakSelf.TRIPLabel.mas_centerX);
    }];
    [self.ODONumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.ODOLabel.mas_centerX);
        make.top.mas_equalTo(weakSelf.ODOLabel.mas_bottom).mas_offset(SCALE_LWIDTH(6));
    }];
//    [self.changeOriBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(SCALE_LWIDTH(-40));
//        make.centerY.mas_equalTo(weakSelf.EBNameLabel.mas_centerY);
//        make.width.height.mas_equalTo(SCALE_LWIDTH(40));
//    }];
    [self.btBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCALE_LWIDTH(-40));
        make.centerY.mas_equalTo(weakSelf.EBNameLabel.mas_centerY);
        make.width.height.mas_equalTo(SCALE_LWIDTH(30));
    }];
    [self.batteryImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.btBtn.mas_centerX);
        make.top.mas_equalTo(weakSelf.btBtn.mas_bottom).mas_equalTo(SCALE_LWIDTH(25));
        make.width.mas_equalTo(SCALE_LWIDTH(41));
        make.height.mas_equalTo(SCALE_LWIDTH(35));
    }];
//    CGFloat batteryValue = [self.model.batteryPower floatValue]/100;
//    CGFloat batteryW = 0.8 * SCALE_LWIDTH(35);
    [self.batteryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.batteryImgView.mas_left).mas_offset(SCALE_LWIDTH(2));
        make.centerY.mas_equalTo(weakSelf.batteryImgView.mas_centerY);
        make.height.mas_equalTo(SCALE_LWIDTH(15));
        make.width.mas_equalTo(weakSelf.batteryWidth);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.batteryImgView.mas_bottom);
        make.centerX.mas_equalTo(weakSelf.batteryImgView.mas_centerX);
    }];
    
//    [self.lightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.batteryLabel.mas_bottom).mas_offset(SCALE_LWIDTH(25));
//        make.centerX.mas_equalTo(weakSelf.batteryLabel.mas_centerX);
//        make.width.mas_equalTo(SCALE_LWIDTH(45));
//        make.height.mas_equalTo(SCALE_LWIDTH(40));
//    }];
//    [self.lightSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.lightImgView.mas_bottom).mas_offset(SCALE_LWIDTH(-5));
//        make.centerX.mas_equalTo(weakSelf.lightImgView.mas_centerX);
//    }];
    [self.changeOriBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCALE_LWIDTH(-40));
        make.top.mas_equalTo(weakSelf.batteryLabel.mas_bottom).mas_offset(SCALE_LWIDTH(25));
        make.width.height.mas_equalTo(SCALE_LWIDTH(40));
    }];
    [self.setBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE_LWIDTH(15));
        make.top.mas_equalTo(SCALE_LWIDTH(40));
        make.height.width.mas_equalTo(SCALE_LWIDTH(40));
    }];
}

#pragma mark -- 设置按钮
- (UIButton *)setBtn{
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setBtn setBackgroundImage:[UIImage imageNamed:@"Home_set"] forState:UIControlStateNormal];
        [_setBtn addTarget:self action:@selector(handleSetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

- (void)handleSetAction{
    self.infoVC = [[EBInfoVC alloc]init];
    self.infoVC.model = self.model;
    self.infoVC.isPortrait = self.isPortrait;
    [self.navigationController pushViewController:self.infoVC animated:YES];
}

#pragma mark -- 蓝牙按钮
- (UIButton *)btBtn{
    if (!_btBtn) {
        _btBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btBtn setBackgroundImage:[UIImage imageNamed:@"Home_bluetoothClose"] forState:UIControlStateNormal];
        [_btBtn setBackgroundImage:[UIImage imageNamed:@"Home_bluetoothOpen"] forState:UIControlStateSelected];
        [_btBtn addTarget:self action:@selector(handleBlueToothAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btBtn;
}

- (void)handleBlueToothAction:(UIButton *)sender{
    sender.selected = NO;
    [[BLEManager shareManager]disConnect:NO];
    [EBUserTool setLogin:NO];
    [EBUserTool clearData];
    [self clearViewData];
    self.model = [[EBBTDataModel alloc]init];
    EBBlueToothVC *vc = [[EBBlueToothVC alloc]init];
    vc.isPortrait = self.isPortrait;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 速度仪表盘
- (XSDashboardProgressView *)speedView{
    if (!_speedView) {
        _speedView = [[XSDashboardProgressView alloc]init];
        _speedView.backgroundColor = [UIColor clearColor];
        _speedView.beginAngle = 90;
        _speedView.blockAngle = 13;
        _speedView.gapAngle = 2;
        _speedView.progressColor = [EBTool colorWithHexString:@"8EDEF9"];
        _speedView.trackColor = [EBTool colorWithHexString:@"797979"];
        _speedView.blockCount = 16;
        _speedView.minValue = 0;
        _speedView.maxValue = 40;
        _speedView.currentValue = 0;
        _speedView.autoAdjustAngle = YES;
        
    }
    return _speedView;
}

#pragma mark -- 千米每小时
- (UILabel *)kmhLabel{
    if (!_kmhLabel) {
        _kmhLabel = [[UILabel alloc]init];
        _kmhLabel.textColor = [UIColor whiteColor];
        _kmhLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:20]];
        _kmhLabel.text = @"km/h";
    }
    return _kmhLabel;
}

#pragma mark -- 速度label
- (UILabel *)speedLabel{
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc]init];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:50]];
        NSString *value = @"0.0";
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:value];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(value.length-1, 1)];
        _speedLabel.attributedText = att;
    }
    return _speedLabel;
}

#pragma mark -- warn Icon
- (UIImageView *)warnImgView{
    if (!_warnImgView) {
        _warnImgView = [[UIImageView alloc]init];
        _warnImgView.image = [UIImage imageNamed:@"Home_warn"];
        _warnImgView.hidden = YES;
    }
    return _warnImgView;
}

- (UILabel *)warnNumLabel{
    if (!_warnNumLabel) {
        _warnNumLabel = [[UILabel alloc]init];
        _warnNumLabel.textColor = [EBTool colorWithHexString:@"EA8825"];
        _warnNumLabel.hidden = YES;
        _warnNumLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:25]];;
    }
    return _warnNumLabel;
}


#pragma mark -- 加减
- (UILabel *)addNumLabel{
    if (!_addNumLabel) {
        _addNumLabel = [[UILabel alloc]init];
        _addNumLabel.textColor = [UIColor whiteColor];
        _addNumLabel.text = @"0";
        _addNumLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:50]];;
    }
    return _addNumLabel;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"Home_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(handleAddClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (void)handleAddClick{
    if ((int)self.model.gearPosition+1 > (int)self.model.currentGear) {
        return;
    }
    [self handleSendDataWithGearPosition:(int)self.model.gearPosition+1];
}

- (UIButton *)subBtn{
    if (!_subBtn) {
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subBtn setImage:[UIImage imageNamed:@"Home_sub"] forState:UIControlStateNormal];
        [_subBtn addTarget:self action:@selector(handleSubClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subBtn;
}

- (void)handleSubClick{
    if ((int)self.model.gearPosition-1 < 0) {
        return;
    }
    [self handleSendDataWithGearPosition:(int)self.model.gearPosition-1];
}

#pragma mark -- 用户的蓝牙名称
- (UILabel *)EBNameLabel{
    if (!_EBNameLabel) {
        _EBNameLabel = [[UILabel alloc]init];
        _EBNameLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:30]];
        _EBNameLabel.textColor = [UIColor whiteColor];
        _EBNameLabel.text = @"Name";
        _EBNameLabel.textAlignment = NSTextAlignmentCenter;
        _EBNameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleNameTap:)];
        [_EBNameLabel addGestureRecognizer:tap];
    }
    return _EBNameLabel;
}

- (void)handleNameTap:(UITapGestureRecognizer *)tap{
//    [[BLEManager shareManager]disConnect:NO];
//    [EBUserTool setLogin:NO];
//    [EBUserTool clearData];
//    [self clearViewData];
//    self.model = [[EBBTDataModel alloc]init];
//    EBBlueToothVC *vc = [[EBBlueToothVC alloc]init];
//    vc.isPortrait = self.isPortrait;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TRIP
- (UILabel *)TRIPLabel{
    if (!_TRIPLabel) {
        _TRIPLabel = [[UILabel alloc]init];
        _TRIPLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:30]];
        _TRIPLabel.textColor = [UIColor whiteColor];
        _TRIPLabel.text = @"TRIP";
    }
    return _TRIPLabel;
}

- (UILabel *)TRIPNumLabel{
    if (!_TRIPNumLabel) {
        _TRIPNumLabel = [[UILabel alloc]init];
        _TRIPNumLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:20]];
        _TRIPNumLabel.textColor = [UIColor whiteColor];
        _TRIPNumLabel.attributedText = [EBTool willBecomeColorNeedStrOfAllStr:@"0.0 km" needBecomeStr:@"km" needColor:[EBTool colorWithHexString:@"6FC7DB"] needFont:[UIFont systemFontOfSize:[EBTool handleCommonFit:15]]];
    }
    return _TRIPNumLabel;
}

#pragma mark -- ODO
- (UILabel *)ODOLabel{
    if (!_ODOLabel) {
        _ODOLabel = [[UILabel alloc]init];
        _ODOLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:30]];
        _ODOLabel.textColor = [UIColor whiteColor];
        _ODOLabel.text = @"ODO";
    }
    return _ODOLabel;
}

- (UILabel *)ODONumLabel{
    if (!_ODONumLabel) {
        _ODONumLabel = [[UILabel alloc]init];
        _ODONumLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:20]];
        _ODONumLabel.textColor = [UIColor whiteColor];
        _ODONumLabel.attributedText = [EBTool willBecomeColorNeedStrOfAllStr:@"0.0 km" needBecomeStr:@"km" needColor:[EBTool colorWithHexString:@"6FC7DB"] needFont:[UIFont systemFontOfSize:[EBTool handleCommonFit:15]]];
    }
    return _ODONumLabel;
}

#pragma mark -- 电池
- (UIImageView *)batteryImgView{
    if (!_batteryImgView) {
        _batteryImgView = [[UIImageView alloc]init];
        _batteryImgView.image = [UIImage imageNamed:@"Home_battery"];
        _batteryImgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _batteryImgView;
}

- (UIView *)batteryView{
    if (!_batteryView) {
        _batteryView = [[UIView alloc]init];
        _batteryView.backgroundColor = [EBTool colorWithHexString:@"18A2F2"];
    }
    return _batteryView;
}

- (UILabel *)batteryLabel{
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc]init];
        _batteryLabel.font = [UIFont systemFontOfSize:[EBTool handleCommonFit:18]];
        _batteryLabel.textColor = [UIColor whiteColor];
        _batteryLabel.text = @"0%";
    }
    return _batteryLabel;
}

#pragma mark -- 手动切换横竖屏按钮
- (UIButton *)changeOriBtn{
    if (!_changeOriBtn) {
        _changeOriBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeOriBtn setImage:[UIImage imageNamed:@"Home_changeOri"] forState:UIControlStateNormal];
        [_changeOriBtn addTarget:self action:@selector(handleChangeOriAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeOriBtn;
}

- (void)handleChangeOriAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (sender.selected) {
        self.isPortrait = NO;
        appDelegate.allowRotation = YES;
        [self setNewOrientation:YES];
        [self landscapeConstraints];
    }else{
        self.isPortrait = YES;
        appDelegate.allowRotation = NO;
        [self setNewOrientation:NO];
        [self portraitConstraints];
    }
}

#pragma mark -- 大灯
- (UIImageView *)lightImgView{
    if (!_lightImgView) {
        _lightImgView = [[UIImageView alloc]init];
        _lightImgView.userInteractionEnabled = YES;
        _lightImgView.image = [UIImage imageNamed:@"Home_lightOn"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleLightStatus)];
        [_lightImgView addGestureRecognizer:tap];
    }
    return _lightImgView;
}

- (void)handleLightStatus{
    NSString *lightStatus = [self.model.lightStatus isEqualToString:@"0"] ? @"1":@"0";
    [self handleSendDataWithLightStatus:lightStatus];
}

- (UISwitch *)lightSwitch{
    if (!_lightSwitch) {
        _lightSwitch = [[UISwitch alloc]init];
        _lightSwitch.on = NO;
        _lightSwitch.enabled = NO;
        _lightSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
        [_lightSwitch addTarget:self action:@selector(handleLightAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _lightSwitch;
}

- (void)handleLightAction:(UISwitch *)sender{
    NSString *lightStatus = [self.model.lightStatus isEqualToString:@"0"] ? @"1":@"0";
    [self handleSendDataWithLightStatus:lightStatus];
}

#pragma mark -- 发送加减数据
- (void)handleSendDataWithGearPosition:(int)gearPosition{
    EBWeakSelf
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = [self.model.kmMileType intValue];
    int a3 = [self.model.pushStatus intValue];
    int a4 = [self.model.lightStatus intValue];
    int a5 = gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[2] = 0x00;
    byte[3] = 0x00;
    byte[7] = 0x0b;
    
    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
        NSLog(@"加减数据");
//        [weakSelf handleHomeRequest];
    }];
//    [[BLEManager shareManager]sendData:[NSData dataWithBytes:byte length:8] complete:nil];
}
#pragma mark -- 修改大灯
- (void)handleSendDataWithLightStatus:(NSString *)lightStatus{
    EBWeakSelf
    int a1 = [self.model.batteryLockStatus intValue];
    int a2 = [self.model.kmMileType intValue];
    int a3 = [self.model.pushStatus intValue];
    int a4 = [lightStatus intValue];
    int a5 = (int)self.model.gearPosition;
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[2] = 0x00;
    byte[3] = 0x00;
    byte[7] = 0x0b;

    [[BLEManager shareManager] sendData:[NSData dataWithBytes:byte length:8] complete:^(NSString *content) {
        NSLog(@"大灯数据");
        weakSelf.model.lightStatus = lightStatus;
    }];
}

#pragma mark -- 接收48数据
- (void)handleGetData:(NSString *)data{
    NSMutableArray *list = [NSMutableArray array];
    for(int i= 0 ; i < data.length/2 ; i++){
        NSString * charString = [data substringWithRange:NSMakeRange(i*2, 2)];
        [list addObject:charString];
    }
    self.dataList = list;
    
    [self handleByte2:list[1]];
    [self handleGear:list[2]];
    [self handleSpeed:list[3] max:list[4]];
    [self handleTrip:list[5] max:list[6]];
    [self handleODO:list[7] mid:list[8] max:list[9]];
    [self handleErrorCode:list[10]];
    [self handleElectricCurrent:list[11] max:list[12]];
    [self handleBatteryTemperature:list[13] max:list[14]];
    [self handleTotalVoltage:list[15] max:list[16]];
    [self handleRelativeCap:list[17]];
    [self handleAbsoluteCap:list[18]];
    [self handleRemaingCap:list[19] max:list[20]];
    [self handleFullPower:list[21] max:list[22]];
    [self handleCycle:list[23] max:list[24]];
    [self handleBatteryPermiss:list[25]];
    [self handleChargInterval:list[28] mid:list[29] max:list[30]];
    [self handleRemainMileage:list[31] max:list[32]];
    [self handleCal:list[33] max:list[34]];
    [self handleCadence:list[35] max:list[36]];
    [self handleTorque:list[37] max:list[38]];
    [self handleTorsion:list[39] max:list[40]];
    [self handleTorqueMax:list[41]];
    [self handleBatteryPower:list[42]];
    [self handleWheel:list[43]];
    [self handleMaxSpeed:list[44]];
    
    if (self.model.gearPosition == 15) {
        self.addNumLabel.text = @"P";
    }else{
        self.addNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.gearPosition];
    }
    if ([self.model.kmMileType isEqualToString:@"0"]) {
        self.kmhLabel.text = @"km/h";
        NSString *speedValue = [NSString stringWithFormat:@"%.1f",[self.model.speed floatValue]/10];
        NSMutableAttributedString *speedAtt = [[NSMutableAttributedString alloc]initWithString:speedValue];
        [speedAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(speedValue.length-1, 1)];
        self.speedLabel.attributedText = speedAtt;
        self.TRIPNumLabel.text = [NSString stringWithFormat:@"%.1f km",[self.model.Trip floatValue]/10];
        self.ODONumLabel.text = [NSString stringWithFormat:@"%.1f km",[self.model.ODO floatValue]/10];
    }else{
        self.kmhLabel.text = @"MPH";
        NSString *speedValue = [NSString stringWithFormat:@"%.1f",[self.model.speed floatValue]/1.609/10];
        NSMutableAttributedString *speedAtt = [[NSMutableAttributedString alloc]initWithString:speedValue];
        [speedAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(speedValue.length-1, 1)];
        self.speedLabel.attributedText = speedAtt;
        float trip = [self.model.Trip floatValue]/1.609/10;
        float odo = [self.model.ODO floatValue]/1.609/10;
        self.TRIPNumLabel.text = [NSString stringWithFormat:@"%.1f mile",trip];
        self.ODONumLabel.text = [NSString stringWithFormat:@"%.1f mile",odo];
    }
    
//    self.lightSwitch.on = [self.model.lightStatus isEqualToString:@"0"] ? NO:YES;
//    if (self.lightSwitch.on) {
//        self.lightImgView.image = [UIImage imageNamed:@"Home_lightOn"];
//    }else{
//        self.lightImgView.image = [UIImage imageNamed:@"Home_lightOff"];
//    }
//    self.lightSwitch.enabled = YES;
    self.batteryLabel.text = [NSString stringWithFormat:@"%@%%",self.model.batteryPower];
    CGFloat batteryValue = [self.model.batteryPower floatValue]/100;
    CGFloat batteryW = batteryValue * [EBTool handleCommonFit:35];
    self.batteryWidth = batteryW;
    [self.batteryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(batteryW);
    }];
    self.speedView.currentValue = [self.model.speed floatValue]/10;
    if ([self.model.errorCode isEqualToString:@"00"]) {
        self.warnImgView.hidden = YES;
        self.warnNumLabel.hidden = YES;
    }else{
        self.warnNumLabel.hidden = NO;
        self.warnImgView.hidden = NO;
        self.warnNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[EBTool getDecimalByHex:self.model.errorCode]];
    }

    if (self.infoVC) {
        self.infoVC.refreshBlock(self.model);
    }
}

- (void)handleByte2:(NSString *)value{
    NSString *result = [EBTool getBinaryByHex:value];
    self.model = [[EBBTDataModel alloc]init];
    [self.model setBatteryLockStatus:[result substringWithRange:NSMakeRange(0, 1)]];
    [self.model setKmMileType:[result substringWithRange:NSMakeRange(1, 1)]];
    [self.model setPushStatus:[result substringWithRange:NSMakeRange(2, 1)]];
    [self.model setLightStatus:[result substringWithRange:NSMakeRange(3, 1)]];
    [self.model setGearPosition:[EBTool getDecimalByBinary:[result substringWithRange:NSMakeRange(4, 4)]]];
}

- (void)handleGear:(NSString *)value{
    [self.model setCurrentGear:[EBTool getDecimalByHex:value]];
}

- (void)handleSpeed:(NSString *)min max:(NSString *)max{
    NSInteger speed = [EBTool getDecimalByHex:min]+[EBTool getDecimalByHex:max]*256;
    [self.model setSpeed:[NSString stringWithFormat:@"%ld",(long)speed]];
}

- (void)handleTrip:(NSString *)min max:(NSString *)max{
    NSInteger trip = [EBTool getDecimalByHex:min]+[EBTool getDecimalByHex:max]*256;
    [self.model setTrip:[NSString stringWithFormat:@"%ld",(long)trip]];
}

- (void)handleODO:(NSString *)min mid:(NSString *)mid max:(NSString *)max{
    NSInteger ODO = [EBTool getDecimalByHex:min]+[EBTool getDecimalByHex:mid]*256+[EBTool getDecimalByHex:max]*256*256;
    [self.model setODO:[NSString stringWithFormat:@"%ld",(long)ODO]];
}

- (void)handleErrorCode:(NSString *)value{
    [self.model setErrorCode:value];
}

- (void)handleElectricCurrent:(NSString *)min max:(NSString *)max{
    NSInteger elect = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setElectricCurrent:[NSString stringWithFormat:@"%ld",elect/1000]];
}

- (void)handleBatteryTemperature:(NSString *)min max:(NSString *)max{
    
    NSInteger temper = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min] - 2731;
    [self.model setBatteryTemperature:[NSString stringWithFormat:@"%ld",temper]];
}

- (void)handleTotalVoltage:(NSString *)min max:(NSString *)max{
    NSInteger voltage = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setTotalVoltage:[NSString stringWithFormat:@"%ld",voltage/1000]];
}

- (void)handleRelativeCap:(NSString *)relativeCap{
    NSInteger cap = [EBTool getDecimalByHex:relativeCap];
    [self.model setRelativeCapacity:[NSString stringWithFormat:@"%ld",cap]];
}

- (void)handleAbsoluteCap:(NSString *)absoluteCap{
    NSInteger cap = [EBTool getDecimalByHex:absoluteCap];
    [self.model setAbsoluteCapacity:[NSString stringWithFormat:@"%ld",cap]];
}

- (void)handleRemaingCap:(NSString *)min max:(NSString *)max{
    NSInteger cap = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setRemaingCapacity:[NSString stringWithFormat:@"%ld",cap]];
}

- (void)handleFullPower:(NSString *)min max:(NSString *)max{
    NSInteger power = [EBTool getDecimalByHex:max]+256 + [EBTool getDecimalByHex:min];
    [self.model setFullPower:[NSString stringWithFormat:@"%ld",power]];
}

- (void)handleCycle:(NSString *)min max:(NSString *)max{
    NSInteger cycles = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setCycles:[NSString stringWithFormat:@"%ld",cycles]];
}

- (void)handleBatteryPermiss:(NSString *)value{
    NSString *permiss = [EBTool getDecimalByHex:value] == 170 ? @"1" : @"0";
    [self.model setBatteryInfoPermission:permiss];
}

- (void)handleChargInterval:(NSString *)min mid:(NSString *)mid max:(NSString *)max{
    NSInteger interval = [EBTool getDecimalByHex:max]*256*256 + [EBTool getDecimalByHex:mid]*256 + [EBTool getDecimalByHex:min];
    [self.model setChargInterval:[NSString stringWithFormat:@"%ld",interval]];
}

- (void)handleRemainMileage:(NSString *)min max:(NSString *)max{
    NSInteger mile = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setRemainMileage:[NSString stringWithFormat:@"%ld",mile]];
}

- (void)handleCal:(NSString *)min max:(NSString *)max{
    NSInteger cal = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setCal:[NSString stringWithFormat:@"%ld",cal]];
}

- (void)handleCadence:(NSString *)min max:(NSString *)max{
    NSInteger value = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setCadence:[NSString stringWithFormat:@"%ld",value]];
}

- (void)handleTorque:(NSString *)min max:(NSString *)max{
    double floadV = (double)([EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min])/1000*0.02*1000;
    [self.model setTorque:[NSString stringWithFormat:@"%.1f",floadV]];
}

- (NSString *)formatterNumber:(NSNumber *)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];
    return [numberFormatter stringFromNumber:number];
}

- (void)handleTorsion:(NSString *)min max:(NSString *)max{
    NSInteger value = [EBTool getDecimalByHex:max]*256 + [EBTool getDecimalByHex:min];
    [self.model setTorsion:[NSString stringWithFormat:@"%ld",value]];
}

- (void)handleTorqueMax:(NSString *)value{
    NSInteger torque = [EBTool getDecimalByHex:value];
    [self.model setTorqueMAX:[NSString stringWithFormat:@"%ld",torque]];
}

- (void)handleBatteryPower:(NSString *)value{
    NSInteger power = [EBTool getDecimalByHex:value];
    [self.model setBatteryPower:[NSString stringWithFormat:@"%ld",power]];
}

- (void)handleWheel:(NSString *)value{
    NSInteger wheel = [EBTool getDecimalByHex:value];
    [self.model setWheel:[NSString stringWithFormat:@"%ld",wheel]];
}

- (void)handleMaxSpeed:(NSString *)value{
    NSInteger speed = [EBTool getDecimalByHex:value];
    [self.model setMaxSpeed:[NSString stringWithFormat:@"%ld",speed]];
}

- (void)clearViewData{
    
    NSString *value = @"0.0";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:value];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(value.length-1, 1)];
    self.speedLabel.attributedText = att;
    self.speedView.currentValue = 0;
    self.warnImgView.hidden = YES;
    self.warnNumLabel.hidden = YES;
    self.addNumLabel.text = @"0";
    self.EBNameLabel.text = @"Name";
    self.TRIPNumLabel.attributedText = [EBTool willBecomeColorNeedStrOfAllStr:@"0.0 km" needBecomeStr:@"km" needColor:[EBTool colorWithHexString:@"6FC7DB"] needFont:[UIFont systemFontOfSize:[EBTool handleCommonFit:15]]];
    self.ODONumLabel.attributedText = [EBTool willBecomeColorNeedStrOfAllStr:@"0.0 km" needBecomeStr:@"km" needColor:[EBTool colorWithHexString:@"6FC7DB"] needFont:[UIFont systemFontOfSize:[EBTool handleCommonFit:15]]];
    [self.batteryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    self.batteryLabel.text = @"0%";
//    self.lightSwitch.on = NO;
//    self.lightSwitch.enabled = NO;
//    self.lightImgView.image = [UIImage imageNamed:@"Home_lightOff"];
    
}


@end
