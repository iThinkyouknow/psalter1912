//
//  AppDelegate.m
//  Test2
//
//  Created by Not For You to Use on 25/03/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "AppDelegate.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIStoryboard *mainStoryboard = nil;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        NSLog(@"[[[UIDevice currentDevice] systemVersion], iPad = %@", [[UIDevice currentDevice] systemVersion]);
        
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.9")) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSLog(@"[[[UIDevice currentDevice] systemVersion], iPhone = %@", [[UIDevice currentDevice] systemVersion]);
        
    } else {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main_6.1" bundle:nil];
        NSLog(@"[[[UIDevice currentDevice] systemVersion], iPhone = %@", [[UIDevice currentDevice] systemVersion]);
    }
    
    UIViewController *initialViewController = [mainStoryboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initialViewController;
    [self.window makeKeyAndVisible];
    

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

@end
