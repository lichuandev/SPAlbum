//
//  AppDelegate.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "SetPasswordViewController.h"
#import "LoginViewController.h"
#import "UIColor+FlatUI.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 判断是否第一次
    [self judgementIsTheFirstTimeLogin];
    
    // 设置View
    [self setView];
    return YES;
}
-(void)setView{
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorFromHexCode:@"ff2d39"]];
    [[UITextField appearance]setTintColor:[UIColor colorFromHexCode:@"ff2d39"]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}
-(void)judgementIsTheFirstTimeLogin{
    BOOL isTheFirstTimeLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isTheFirstTimeLogin"];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *rootViewController;
    if (isTheFirstTimeLogin) {
        rootViewController = [main instantiateViewControllerWithIdentifier:@"loginC"];
    }else{
        rootViewController = [main instantiateViewControllerWithIdentifier:@"setPasswordC"];
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 判断是否第一次
    [self judgementIsTheFirstTimeLogin];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
