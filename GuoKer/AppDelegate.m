//
//  AppDelegate.m
//  GuoKer
//
//  Created by Lumo on 16/8/5.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "AppDelegate.h"
#import "LMYSideDeckViewController.h"
#import "LMYAdView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSNumber *theme = [[NSUserDefaults standardUserDefaults] objectForKey:ThemeModeKey];
    if (!theme) {
        [[LMYThemeManager sharedManager] changeModeWithTheme:ThemeDay];
    }else {
        [[LMYThemeManager sharedManager] changeModeWithTheme:[theme intValue]];
    }

    application.statusBarStyle = UIStatusBarStyleLightContent;

    self.window = [[UIWindow alloc] initWithFrame:SREEN_BOUNDS];
    LMYSideDeckViewController *deckVc = [[LMYSideDeckViewController alloc] init];
    self.window.rootViewController = deckVc ;
    [self.window makeKeyAndVisible];
    
    UIView *adView = [[LMYAdView alloc] initWithFrame:self.window.bounds];
    [self.window addSubview:adView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [adView removeFromSuperview];
    });
    return YES;
}

- (void)loadAdData
{
    NSString *baseUrl = [NSString stringWithFormat:@""];
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

@end
