//
//  BaseNavigationController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeChange object:nil];
        
    }
    return self;
}

-(void)themeChange:(NSNotification *)notification {
    [self loadImage];
    
    
}

-(void)loadImage {
    
    //主题管家
    ThemeManager *manager = [ThemeManager shareInstance];
    
    //更改导航栏背景图片
    UIImage *image = [manager getThemeImage:@"mask_titlebar64.png"];
    
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    

    //更改标题栏的字体f
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    NSDictionary *attrDic = @{NSForegroundColorAttributeName:color};
    
    self.navigationBar.titleTextAttributes = attrDic;
                        
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
