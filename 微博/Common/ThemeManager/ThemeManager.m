//
//  ThemeManager.m
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ThemeManager.h"




@implementation ThemeManager


//实现单例
+ (ThemeManager *)shareInstance {
    
    static ThemeManager *instance = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        instance = [[[self class] alloc] init];
        
        
    });
    
    return instance;
    
}

//初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        //设置默认主题
        
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (_themeName.length == 0) {
            _themeName = @"Cat";
        }

        //读取theme.plist 中的文件，保存到_themeConfig
        NSString *path = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:path];
        
        // 02 读取字体颜色的config.plist文件 , 路径： 主题路径＋config.plist
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
    }
    return self;
}

//更改主题
-(void)setThemeName:(NSString *)themeName {
    
    if (![_themeName isEqualToString:themeName]) {
        
        _themeName = [themeName copy];

        // 01 把主题名保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
   
        // 02 读取字体颜色的config.plist文件 , 路径： 主题路径＋config.plist
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
      
        // 03 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChange object:nil];
 
    }
}



//获取图片名字   路径＋给的图片名   把获取路径方法单独封装
- (UIImage *)getThemeImage:(NSString *)imageName {
    //01 获取主题完整的路径
    NSString *path = [self themePath];
    //02 拼接完整的图片路径
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    //03 获取图片并返回
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
    
}

- (UIColor *)getThemeColor:(NSString *)colorName {
    
    if (colorName.length == 0) {
        return nil;
    }
    
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    
    //获取配置文件中的RGB值
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    
    CGFloat alpha = [rgbDic[@"alpha"] floatValue];
    
    if (_colorConfig[@"alpha"] == nil) {
        
        alpha = 1;
    }
    //创建UIColor对象
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    
    return color;

}


//获取路径方法  boundle路径 ＋ skins/cat
-(NSString *)themePath {
    //01 boundle路径
    NSString *boundlePath = [[NSBundle mainBundle] resourcePath];
    //02 主题路径
    NSString *themePath = [_themeConfig valueForKey:_themeName];
    //03 完整的路径
    NSString *path = [boundlePath stringByAppendingPathComponent:themePath];
    return path;
    
}






@end
