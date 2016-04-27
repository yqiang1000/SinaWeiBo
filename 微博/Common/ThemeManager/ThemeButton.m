//
//  ThemeButton.m
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

-(void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//初始化
-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeChange object:nil];
    }
    return self;
}

//接收主题改变通知后做的事。改变按钮图片
-(void)themeChange:(NSNotification *)notification {
    
    [self loadImage];
    
}
-(void)loadImage {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *normalImage = [manager getThemeImage:_normalImageName];
    UIImage *highlightedImage = [manager getThemeImage:_highlightedImageName];
    
    if (normalImage != nil) {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage != nil) {
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
}



//set 两个状态的图片路径
-(void)setNormalImageName:(NSString *)normalImageName {
    
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = [normalImageName copy];
        [self loadImage];
    }

}
-(void)setHighlightedImageName:(NSString *)highlightedImageName {
    if (![_highlightedImageName isEqualToString:highlightedImageName]) {
        _highlightedImageName = [highlightedImageName copy];
        [self loadImage];
    }
}




@end
