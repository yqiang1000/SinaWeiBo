//
//  ThemeImageView.m
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

-(void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeChange object:nil];
        
    }
    return self;
    
    
}

//接收通知后做的事 ---> 修改背景图片. 把修改图片的方法封装出来
-(void)themeChange:(NSNotification *)notification {
    
    [self loadImage];
    
}


-(void)setImgName:(NSString *)imgName {
    
    if (![_imgName isEqualToString:imgName]) {
        _imgName = [imgName copy];
        [self loadImage];
    }
    
}

-(void)loadImage {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    //获取图片
    UIImage *image = [manager getThemeImage:self.imgName];
    image = [image stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    if (image != nil) {
        self.image = image;
    }
    
}


@end
