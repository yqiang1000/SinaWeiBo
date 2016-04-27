//
//  ThemeLabel.m
//  微博
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//三种初始化方法都写下
//-(instancetype)init {
//    self = [super init];
//    if (self) {
//       
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeChange object:nil];
//        
//    }
//    return self;
//}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeChange object:nil];
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeChange object:nil];
        
    }
    return self;
}

-(void)setColorName:(NSString *)colorName {
    if (![_colorName isEqualToString:colorName]) {
        _colorName = [colorName copy];
        [self loadColor];
    }
  
}

//改变字体
-(void)themeChange:(NSNotification *)notification {
    
    [self loadColor];
    
}
-(void)loadColor {
    
    ThemeManager *mananger = [ThemeManager shareInstance];
    
    self.textColor = [mananger getThemeColor:self.colorName];
    
}


@end
