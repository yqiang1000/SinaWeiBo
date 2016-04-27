//
//  MainTabBarController.h
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

#define BarNumber 4

@interface MainTabBarController : UITabBarController<SinaWeiboDelegate,SinaWeiboRequestDelegate>

@end
