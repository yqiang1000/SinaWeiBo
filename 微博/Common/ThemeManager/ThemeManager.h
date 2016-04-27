//
//  ThemeManager.h
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kThemeChange @"kThemeChange"
#define kThemeName   @"kThemeName"

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName ;          //主题名字
@property (nonatomic, strong) NSDictionary *themeConfig ;  //theme.plist的内容
@property (nonatomic, strong) NSDictionary *colorConfig ; 


+ (ThemeManager *)shareInstance ;                          //实现单例

- (UIImage *)getThemeImage:(NSString *)imageName ;         //获取图片的名字
- (UIColor *)getThemeColor:(NSString *)colorName ;         //获取主题字体颜色

@end
