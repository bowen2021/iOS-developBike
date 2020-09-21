//
//  AppDelegate.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "AppDelegate.h"
#import "EBHomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    [Bugly startWithAppId:@"671220f475"];
    [NSThread sleepForTimeInterval:2];
    [EBUserTool setLogin:NO];
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[EBHomeVC alloc]init]];
    
    return YES;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (_allowRotation == YES) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [EBUserTool clearData];
}


@end
