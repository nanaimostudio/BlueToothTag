//
//  AppDelegate.m
//  BLEKeyfob
//
//  Created by zeng on 10/29/12.
//  Copyright (c) 2012 zeng. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
//#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    
//    self.viewController.progressBarValue = 1.0f;
//    self.viewController.IsSoundAlert = NO;
//    
//    self.window.rootViewController = self.viewController;
    TableViewController *tableViewController = [[TableViewController alloc] init];
    self.window.rootViewController = tableViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
