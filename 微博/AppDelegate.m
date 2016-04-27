//
//  AppDelegate.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerVisualState.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //左边视图控制器
    LeftViewController *leftSideDrawViewController = [[LeftViewController alloc] init];
//    leftSideDrawViewController.view.backgroundColor = [UIColor redColor];
    //右边视图控制器
    RightViewController *rightSideDrawViewController = [[RightViewController alloc] init];
//    rightSideDrawViewController.view.backgroundColor = [UIColor yellowColor];
    
    //中间
    MainTabBarController *mainTabBarController = [[MainTabBarController alloc] init];
    
    //容器控制器，管理左中右三个视图控制器
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:mainTabBarController leftDrawerViewController:leftSideDrawViewController rightDrawerViewController:rightSideDrawViewController];
    
    //设置左右宽度
    [drawerController setMaximumLeftDrawerWidth:150.0];
    [drawerController setMaximumRightDrawerWidth:60.0];
    
    //设置手势控制区域
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置动画效果
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState swingingDoorVisualStateBlock];
    [drawerController setDrawerVisualStateBlock:block];
    
    
    
    
    //创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
//    MainTabBarController *mainTabBarController = [[MainTabBarController alloc] init];
    
    self.window.rootViewController = drawerController;

    
    
    //设置sinaWeibo
    self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    
    
    
    //登录后保存文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *sinaWeiboInfo = [userDefaults objectForKey:@"SinaWeiboAuthData"];
    
    
    if ([sinaWeiboInfo objectForKey:@"AccessTokenKey"] && [sinaWeiboInfo objectForKey:@"ExpirationDateKey"] && [sinaWeiboInfo objectForKey:@"UserIDKey"]) {
        
        self.sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaWeibo.userID = [sinaWeiboInfo objectForKey:@"UserIDKey"];
        
        
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

//存登录成功plist
- (void)storeAuthData
{
    SinaWeibo *sinaweibo = self.sinaWeibo;
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//删除登录成功的plist
-(void)removeAuthData {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    
    
}


//登陆成功
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    NSLog(@"登陆成功");
    NSLog(@"%@,%@,%@",self.sinaWeibo.accessToken,self.sinaWeibo.userID,self.sinaWeibo.expirationDate);
    [self storeAuthData];
    
}
//登出成功
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"登出成功");
    self.sinaWeibo.accessToken = nil;
    self.sinaWeibo.expirationDate = nil;
    self.sinaWeibo.userID = nil;
    
    
    

}
//登陆取消
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo{
    NSLog(@"取消登录");
}
//登陆失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"登录失败:%@",error);
    
}


//令牌过期
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error{
    
}


@end
