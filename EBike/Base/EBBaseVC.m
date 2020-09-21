//
//  EBBaseVC.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBBaseVC.h"

@interface EBBaseVC ()

@end

@implementation EBBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [EBTool colorWithHexString:@"2A3032"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}

- (void)setNewOrientation:(BOOL)fullscreen{
    if (fullscreen) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }else{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
