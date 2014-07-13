//
//  NXAppDelegate.m
//  NXInstagramViewer
//
//  Created by Carola Nitz on 12/07/14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

#import "NXAppDelegate.h"
#import "NXRootViewController.h"
#import <NXOAuth2Client/NXOAuth2AccountStore.h>
#import <NXOAuth2Client/NXOAuth2Account.h>
#import "NXPhotoViewController.h"

@implementation NXAppDelegate

+ (void)initialize
{
    [[NXOAuth2AccountStore sharedStore] setClientID:@"f2c4524d19ea48e89d83423ee0971142"
                                             secret:@"e239b3d2d2ef4baf9d7ada94164cbd08"
                                              scope:[NSSet setWithObjects:@"basic",@"likes", @"relationships", @"comments", nil]
                                   authorizationURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]
                                        redirectURL:[NSURL URLWithString:@"nxdevchallange://oauth"]
                                      keyChainGroup:@"NXinstagramViewer"
                                     forAccountType:@"thisisatest"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[NXOAuth2AccountStore sharedStore] accounts].count > 0) {
        NXPhotoViewController *photoViewController = [NXPhotoViewController new];
        self.window.rootViewController = photoViewController;
    } else {
        NXRootViewController *rootViewController = [NXRootViewController new];
        self.window.rootViewController = rootViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //here you need to check for the url if you have more than one type
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
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
