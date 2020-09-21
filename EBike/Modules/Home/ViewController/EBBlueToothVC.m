//
//  EBBlueToothVC.m
//  EBike
//
//  Created by 刘佳斌 on 2019/3/3.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBBlueToothVC.h"
#import "EBPasswordAlertView.h"
#import "EBBleCell.h"

@interface EBBlueToothVC ()<UITableViewDelegate,UITableViewDataSource,EBPasswordAlertViewDelegate,BLE_ConnectDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *peripheralList;
@property(nonatomic, strong)UIButton *scanBtn;
@property(nonatomic, strong)UIView *navBar;

@property(nonatomic, strong)CBPeripheral *currPeripheral;
@property (nonatomic,strong)CBCharacteristic *characteristic;

@property(nonatomic, copy)NSString *currentUUid;

@property(nonatomic,strong)NSMutableArray *peripherals;
@property(nonatomic,strong)NSMutableArray *storePeripherals;

@property(nonatomic, strong)EBPasswordAlertView *customAlertView;

@end

@implementation EBBlueToothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peripheralList = [NSMutableArray array];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.tableView];
    
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleTimeout) name:kNotificationTimeout object:nil];
    
}

- (void)handleTimeout{
    if (![EBUserTool isLogin]) {
        [SVProgressHUD showInfoWithStatus:@"Connection Timed Out"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handleDeviceOrientationChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:{
            NSLog(@"屏幕向左横");
            [self landscapeConstraints];
        }
            break;
        case UIDeviceOrientationLandscapeRight:{
            NSLog(@"屏幕向右横");
            [self landscapeConstraints];
        }
            break;
        case UIDeviceOrientationPortrait:{
            NSLog(@"屏幕直立");
            [self portraitConstraints];
        }
            break;
        default:
            [self handleOri];
            break;
    }
}

- (void)portraitConstraints{
    EBWeakSelf
    [self.navBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE_PWIDTH(64));
    }];
    [self.scanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.navBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE_PWIDTH(44));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.scanBtn.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];

}

- (void)landscapeConstraints{
    EBWeakSelf
    [self.navBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE_LWIDTH(64));
    }];
    [self.scanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.navBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCALE_LWIDTH(44));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.scanBtn.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)handleOri{
    if ([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIDeviceOrientationPortrait; // 竖屏
        UIDeviceOrientation duration = [[UIDevice currentDevice]orientation];
        if (UIDeviceOrientationPortrait != duration) {
            val = UIDeviceOrientationPortrait;
        }
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        [self portraitConstraints];
    }
}

- (UIView *)navBar{
    if (!_navBar) {
        _navBar = [[UIView alloc]init];
        _navBar.backgroundColor = [UIColor clearColor];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, [EBTool handleCommonFit:22],  [EBTool handleCommonFit:44],  [EBTool handleCommonFit:44]);
        [backBtn setImage:[UIImage imageNamed:@"Info_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(handleBackClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBar addSubview:backBtn];
    }
    return _navBar;
}

- (void)handleBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBtn setTitle:@"scan" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(handleScan) forControlEvents:UIControlEventTouchUpInside];
        _scanBtn.backgroundColor = [EBTool colorWithHexString:@"1DA1F3"];
        
    }
    return _scanBtn;
}

#pragma mark -- 搜索蓝牙
- (void)handleScan{
    EBWeakSelf
    [[BLEManager shareManager]scanForDevicesWithAllBlocks:^(CBPeripheral *peripheral, NSNumber *RSSI, NSString *mac) {
        [weakSelf insertTableView:peripheral RSSI:RSSI mac:mac];
        if(peripheral){
            if(![self.peripherals containsObject:peripheral]){
                [self.peripherals addObject:peripheral];
                [self.tableView reloadData];
            }
            if(![self.storePeripherals containsObject:peripheral]){
                [self.storePeripherals addObject:peripheral];
            }
        }else{
            self.peripherals = nil;
            self.storePeripherals = nil;
        }
    }];
}
-(NSMutableArray*)storePeripherals{
    if(!_storePeripherals){
        _storePeripherals = [NSMutableArray array];
    }
    return _storePeripherals;
}
-(NSMutableArray*)peripherals{
    if(!_peripherals){
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

#pragma mark -- tableview
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[EBBleCell class] forCellReuseIdentifier:EBBleCellID];
    }
    return _tableView;
}

#pragma mark -- customAlertView
- (EBPasswordAlertView *)customAlertView{
    if (!_customAlertView) {
        _customAlertView = [[EBPasswordAlertView alloc]initWithFrame:self.view.bounds];
        _customAlertView.isPortrait = self.isPortrait;
        _customAlertView.alertDelegate = self;
        _customAlertView.alertTitle = @"Please Input Password";
        _customAlertView.inputText = @"";
    }
    return _customAlertView;
}

- (void)handleOkClickWithValue:(NSString *)value{
    EBWeakSelf
    NSData *data = [self setPassword:value];
    [[BLEManager shareManager]sendData:data complete:^(NSString *content) {
        NSLog(@"输入的密码结果%@",content);
        [weakSelf handlePassword:value content:content];
    }];
}

- (void)handleCancelClick{
    [[BLEManager shareManager]disConnect:NO];
    [self.customAlertView removeFromSuperview];
    self.customAlertView.inputText = @"";
}

#pragma mark -- 处理输入密码的返回数据
- (void)handlePassword:(NSString *)password content:(NSString *)content{
    EBWeakSelf
    NSString *result = [content substringWithRange:NSMakeRange(8, 2)];
    if ([result isEqualToString:@"00"]) {
        [SVProgressHUD showInfoWithStatus:@"password error"];
        [EBUserTool setLogin:NO];
        self.customAlertView.inputText = @"";
        [self.view addSubview:self.customAlertView];
    }else{
        if ([result isEqualToString:@"02"]) {
            NSData *data = [self setPassword:@"120117"];
            [[BLEManager shareManager]sendData:data complete:^(NSString *content) {
                NSString *result = [password substringWithRange:NSMakeRange(8, 2)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        [EBUserTool setLogin:YES];
        [EBUserTool setBLEName:self.currPeripheral.name];
        if ([result isEqualToString:@"01"]) {
            [EBUserTool setUserPassword:password];
            [EBUserTool setUserPasswordLevel:result];
        }
        
        for (NSDictionary *dic in self.peripheralList) {
            if (dic[@"peripheral"] == self.currPeripheral) {
                [EBUserTool setBLEMac:dic[@"mac"]];
            }
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
        [[BLEManager shareManager] removeTimer];
    }
}

#pragma mark -- tableView代理

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBBleCell *cell = [tableView dequeueReusableCellWithIdentifier:EBBleCellID forIndexPath:indexPath];
    NSDictionary *item = self.peripheralList[indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    NSString *mac = [item objectForKey:@"mac"];
    NSString *peripheralName;
    if (!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    cell.title = peripheralName;
    cell.mac = mac;
    cell.rssi = [NSString stringWithFormat:@"%@",RSSI];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheralList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [EBTool handleCommonFit:44];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD show];
    self.tableView.userInteractionEnabled = NO;
    [[BLEManager shareManager] didStopScan];
    NSDictionary *item = self.peripheralList[indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    NSLog(@"选中 %@ %@",peripheral,RSSI);

    self.currPeripheral = peripheral;
    [[BLEManager shareManager]didConnecPeripheral:peripheral timer:60];
    [BLEManager shareManager].bleConnectDelegate = self;
}

- (void)autoConnectPeripheral:(CBPeripheral *)peripheral{
    [SVProgressHUD show];
    self.tableView.userInteractionEnabled = NO;
    [[BLEManager shareManager] didStopScan];
    
    self.currPeripheral = peripheral;
    [[BLEManager shareManager]didConnecPeripheral:peripheral timer:60];
    [BLEManager shareManager].bleConnectDelegate = self;
    
}

- (void)onSendResult:(NSString *)result{
}

- (void)onConnectResult:(CBPeripheral *)peripheral isSuccess:(BOOL)isSuccess{
    EBWeakSelf
    if (isSuccess) {
        if ([EBUserTool getUserPassword].length > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf delaysend];
                self.tableView.userInteractionEnabled = YES;
            });
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.view addSubview:weakSelf.customAlertView];
            self.tableView.userInteractionEnabled = YES;
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

- (NSData *)setPassword:(NSString *)string{
    
    //    <fa551006 31323031 313742>
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

- (NSData *)setName:(NSString *)string{
    
    
    int length = (int)string.length;
    Byte byte[10];
    memset(byte, 0, 10 * sizeof(Byte));
    byte[0] = 0xFA;
    byte[1] = 0x55;
    byte[2] = 0x06;
    byte[3] = 0x05;
    
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    Byte *stringByte = (Byte *)[data bytes];
    memcpy(byte + 4*sizeof(Byte), stringByte , length*sizeof(Byte));
    int a = 0;
    for (int i = 0; i<10; i++) {
        a += byte[i];
    }
    byte[9] = 0x88;
    return [NSData dataWithBytes:byte length:10];
}

- (NSData*)settingss{
    
    int a1 = 1;//电池电量
    int a2 = 1;//单位
    int a3 = 1;//推行使能
    int a4 = 1;//大灯
    int a5 = 1;//档位
    
    Byte byte[8];
    memset(byte, 0, 8 * sizeof(Byte));
    byte[0] = 0x58;
    byte[1] = (Byte)(a1 << 7 | a2 << 6 | a3 << 5 | a4 << 4 | a5);
    byte[2] = 0x00;
    byte[3] = 0;
    byte[7] = 0x0b;
    int a = 0;
    for (int i = 0; i<6; i++) {
        a += byte[i];
    }
    byte[5] = (Byte)(a & 0b00001111);
    byte[6] = (Byte)(a & 0b11110000);
    return [NSData dataWithBytes:byte length:8];
}

#pragma mark -- 插入tableView
- (void)insertTableView:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI mac:(NSString *)mac{
    NSArray *peripherals = [self.peripheralList valueForKey:@"peripheral"];
    if (![peripherals containsObject:peripheral]) {
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:mac forKey:@"mac"];
        [self.peripheralList addObject:item];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
