//
//  AppDelegate.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/1.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginCBSSViewController.h"
#import "MyNavViewController.h"
#import "HomeViewController.h"
#import "IQKeyboardManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface AppDelegate ()
@property(nonatomic,strong)BMKMapManager* mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [NSThread sleepForTimeInterval:3.0];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //状态栏白色
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
     [IQKeyboardManager sharedManager].enable = YES;
     [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
#pragma  百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"u6bcgyYtvIo7ErpeqCteIZNk6tH3yafo"  generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"mid"]) {
        
        [defaults setObject:@"0" forKey:@"mid"];
    }
    NSLog(@"%@",[defaults objectForKey:@"mid"]);
    if ([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"mid"]] isEqualToString:@"0"]) {
        LoginCBSSViewController *logVC = [[LoginCBSSViewController alloc] init];
        MyNavViewController * nav = [[MyNavViewController alloc]initWithRootViewController:logVC];
        [defaults setObject:@"0" forKey:@"isLogin"];
        self.window.rootViewController = nav;
   
    }else{
        HomeViewController * homeVC = [[HomeViewController alloc]init];
        MyNavViewController * homeNav = [[MyNavViewController alloc]initWithRootViewController:homeVC];
        [defaults setObject:@"1" forKey:@"isLogin"];
        self.window.rootViewController = homeNav;
    }
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
