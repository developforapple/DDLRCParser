//
//  AppDelegate.m
//  LRCParserDemo
//
//  Created by Normal on 16/2/25.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString * test = @"[00:53.00][01:43.88][02:1]虽然无所谓写在脸上";
    NSString * regex = @"(\\[\\d{0,2}:\\d{0,2}([.|:]\\d{0,2})?\\])";

    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString * modefiy = [re stringByReplacingMatchesInString:test options:0 range:NSMakeRange(0, test.length) withTemplate:@""];
    
    
    if (re) {
        NSArray * results = [re matchesInString:test options:0 range:NSMakeRange(0, test.length)];
        
        for (NSTextCheckingResult * res in results) {
            
            NSString * substr = [test substringWithRange: res.range];
            NSLog(@"findstring is %@",substr);
        }
    }
    
    
    
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
