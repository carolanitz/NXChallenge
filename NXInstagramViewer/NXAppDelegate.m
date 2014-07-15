//
//  NXAppDelegate.m
//  NXInstagramViewer
//
//  Created by Carola Nitz on 12/07/14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

#import "NXAppDelegate.h"
#import "NXRootViewController.h"
#import "NXPhotoViewController.h"
#import "NXApi.h"

@implementation NXAppDelegate

+ (void)initialize
{
    [[NXApi sharedAPI] initialize];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[NXApi sharedAPI] userIsLoggedIn]) {
        NXRootViewController *rootViewController = [NXRootViewController new];
        UINavigationController *navController = [UINavigationController new];
        NXPhotoViewController *photoViewController = [NXPhotoViewController new];
        navController.viewControllers = @[rootViewController, photoViewController];
        self.window.rootViewController = navController;
    } else {
        NXRootViewController *rootViewController = [NXRootViewController new];
        UINavigationController *navController = [UINavigationController new];
        navController.viewControllers = @[rootViewController];
        self.window.rootViewController = navController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:48.0/255.0 green:93.0/255.0 blue:139.0/255.0 alpha:1.0]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //here you need to check for the url if you have more than one type
    [[NXApi sharedAPI] handleURL:url];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
