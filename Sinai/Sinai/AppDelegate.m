//
//  AppDelegate.m
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-46503911-2"];
    
    [GAI sharedInstance].defaultTracker = tracker;

//push
    self.gameThrive = [[GameThrive alloc] initWithLaunchOptions:launchOptions handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
        UIAlertView* alertView;
        
        NSLog(@"APP LOG ADDITIONALDATA: %@", additionalData);
        
        if (additionalData) {
            // Append AdditionalData at the end of the message
            NSString* displayMessage = [NSString stringWithFormat:@"NotificationMessage:%@", message];
            
            NSString* messageTitle;
            if (additionalData[@"discount"])
                messageTitle = additionalData[@"discount"];
            else if (additionalData[@"bonusCredits"])
                messageTitle = additionalData[@"bonusCredits"];
            else if (additionalData[@"actionSelected"])
                messageTitle = [NSString stringWithFormat:@"Pressed ButtonId:%@", additionalData[@"actionSelected"]];
            
            alertView = [[UIAlertView alloc] initWithTitle:messageTitle
                                                   message:displayMessage
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"fechar", nil)
                                         otherButtonTitles:nil, nil];
        }
        
        // If a push notification is received when the app is being used it does not go to the notifiction center so display in your app.
        if (alertView == nil && isActive) {
            alertView = [[UIAlertView alloc] initWithTitle:@"AppSinai"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"fechar", nil)
                                         otherButtonTitles:nil, nil];
        }
        
        // Highly recommend adding game logic around this so the user is not interrupted during gameplay.
        if (alertView != nil)
            [alertView show];
        
    }];
    
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
