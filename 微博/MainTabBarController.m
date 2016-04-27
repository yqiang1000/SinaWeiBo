//
//  MainTabBarController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "Common.h"
#import "ThemeLabel.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "SinaWeibo.h"

@interface MainTabBarController ()
{
    ThemeImageView *_selectedImage;
    ThemeLabel *_badgeLabel;
    ThemeImageView *_badgeImage;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createNavigationController];
    
    [self _createTabBar];
    
    //创建定时器
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 添加控制器
-(void)_createNavigationController {
    //@"Message"
    NSArray *names = @[@"Home",@"Discover",@"Profile",@"More"];
    NSMutableArray *navis = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0 ; i < BarNumber ; i++ ) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        
        BaseNavigationController *navi = [storyBoard instantiateInitialViewController];
        
        [navis addObject:navi];
        
    }
    
    self.viewControllers = navis;
    
}


#pragma mark - 自定义TabBar
-(void)_createTabBar {
    
    //01 移除原有的标签
    for (UIView *view in self.tabBar.subviews) {
        //通过字符串获取类对象
        Class class = NSClassFromString(@"UITabBarButton");
        
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
    
    //02 创建自定义的标签栏
    //设置背景图片
    ThemeImageView *bgImage = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    
    bgImage.imgName = @"mask_navbar.png";
    
    [self.tabBar addSubview:bgImage];
    
    //设置选中图片
    _selectedImage = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5, 49)];
    _selectedImage.imgName = @"home_bottom_tab_arrow.png";
    
    
    [self.tabBar addSubview:_selectedImage];
    
    //@"home_tab_icon_2.png",
    NSArray *buttonImage = @[
                             @"home_tab_icon_1.png",
                             
                             @"home_tab_icon_3.png",
                             @"home_tab_icon_4.png",
                             @"home_tab_icon_5.png",
                             ];
    
    //设置按钮图片
    CGFloat buttonW = kScreenWidth / buttonImage.count;
    
    for (int i = 0 ; i < BarNumber ; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, 49)];
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        
        button.normalImageName = buttonImage[i];
        [self.tabBar addSubview:button];
        
    }
}


#pragma mark - 
-(void)selectedAction:(UIButton *)button {
    
    self.selectedIndex = button.tag - 100;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        _selectedImage.center = button.center;
    }];
    
//    NSLog(@"点击了第%li个视图",button.tag - 100);
    
    
}


-(void)timerAction {
    //发送网络请求

    AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    //解析数据
//    NSLog(@"%--------------@",result);
   /*
    {
    "all_cmt" = 0;
    "all_follower" = 0;
    "all_mention_cmt" = 0;
    "all_mention_status" = 0;
    "attention_cmt" = 0;
    "attention_follower" = 0;
    "attention_mention_cmt" = 0;
    "attention_mention_status" = 0;
    badge = 0;
    "chat_group_client" = 0;
    "chat_group_notice" = 0;
    "chat_group_pc" = 0;
    cmt = 0;
    dm = 1;
    follower = 0;
    group = 0;
    invite = 0;
    "mention_cmt" = 0;
    "mention_status" = 0;
    notice = 0;
    "page_friends_to_me" = 0;
    photo = 0;
    status = 0;
    }

    */
    
    
    if (_badgeImage == nil) {
        CGFloat buttonWidth = kScreenWidth / BarNumber;
        _badgeImage = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth - 32, 0, 32, 32)];
        _badgeImage.imgName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeImage];
        
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImage.bounds];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:14];
        [_badgeImage addSubview:_badgeLabel];
        
    }
    

    NSInteger count = [result[@"status"] integerValue];
    
    if (count >= 99) {

        _badgeLabel.text = [NSString stringWithFormat:@"99"];
    }else if (count == 0) {
        _badgeImage.hidden = YES;
//        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
    }
    else {

        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
        
    }
    
    
}




@end
