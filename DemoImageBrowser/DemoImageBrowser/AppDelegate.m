//
//  AppDelegate.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ImageAutonRunloopVC.h"
#import "ImageNormalVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self rootController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)rootController
{
//    ViewController *rootVC = [[ViewController alloc] init];
//    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
//    self.window.rootViewController = rootNav;
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //
    ViewController *firstVC = [ViewController new];
    firstVC.title = @"首页";
    firstVC.tabBarItem.image = nil;
    firstVC.tabBarItem.selectedImage = nil;
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
    [array addObject:firstNav];
    //
    ImageAutonRunloopVC *loopVC = [ImageAutonRunloopVC new];
    loopVC.title = @"循环";
    loopVC.tabBarItem.image = nil;
    loopVC.tabBarItem.selectedImage = nil;
    UINavigationController *loopNav = [[UINavigationController alloc] initWithRootViewController:loopVC];
    [array addObject:loopNav];
    //
    ImageNormalVC *normalVC = [ImageNormalVC new];
    normalVC.title = @"非循环";
    normalVC.tabBarItem.image = nil;
    normalVC.tabBarItem.selectedImage = nil;
    UINavigationController *normalNav = [[UINavigationController alloc] initWithRootViewController:normalVC];
    [array addObject:normalNav];
    //
    UITabBarController *controller = [[UITabBarController alloc] init];
    controller.viewControllers = array;
    //
    self.window.rootViewController = controller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

@end
