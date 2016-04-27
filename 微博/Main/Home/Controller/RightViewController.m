//
//  RightViewController.m
//  微博
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "WriteViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "LocationViewController.h"

//newbar_icon_1@2x
@interface RightViewController ()<SinaWeiboRequestDelegate>
{
    
    NSMutableArray *_buttonNames ;
}
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createButtonName];
    
    [self createNewBar];
    
    [self text];
    
}

-(void)createButtonName {
    
    _buttonNames = [NSMutableArray array];
    
    for (int i = 0; i < 5 ; i++) {
        NSString *string = [NSString stringWithFormat:@"newbar_icon_%d@2x",i+1];
        [_buttonNames addObject:string];
    }

}

-(void)createNewBar {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    for (int i = 0 ; i < 5 ; i++ ) {
        NSString *imageName = _buttonNames[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(10, i * 50 + 64, 40, 40)];
        [button addTarget:self action:@selector(newBarAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
        
        UIImage *image = [manager getThemeImage:imageName];
        [button setImage:image forState:UIControlStateNormal];
        
        [self.view addSubview:button];
    }

}


-(void)newBarAction:(UIButton *)button {
    NSInteger tag = button.tag - 10;
    
    NSLog(@"%@",self);
    
    switch (tag) {
        case 0:
//            NSLog(@"点击第%li个按钮",tag);
            [self writeWeibo];
            
            break;
        case 1:
            NSLog(@"点击第%d个按钮",tag);
            break;
        case 2:
            NSLog(@"点击第%d个按钮",tag);
            break;
        case 3:
            NSLog(@"点击第%d个按钮",tag);
            break;
        case 4:
//            NSLog(@"点击第%li个按钮",tag);
            [self location];
            break;
            
        default:NSLog(@"未点击");
            break;
    }
    
    
}
#pragma mark - 写微博
-(void)writeWeibo {
    //关闭右侧视图
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
        WriteViewController *writeVC = [[WriteViewController alloc] init];
        writeVC.title = @"发送微博";
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:writeVC];
        
        [self.mm_drawerController presentViewController:navi animated:YES completion:nil];
        
    }];
 
}
#pragma mark - 定位附近商圈
-(void)location {
    //关闭右侧视图
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        locationVC.title = @"我的附近";
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:locationVC];
        [self presentViewController:navi animated:YES completion:nil];
        
        
    }];
}


#pragma mark - 测试
-(void)text {
    
    UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 314, 40, 40)];
    loadButton.backgroundColor = [UIColor blueColor];
    [loadButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loadButton addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *loadButton1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 364, 40, 40)];
    loadButton1.backgroundColor = [UIColor blueColor];
    [loadButton1 setTitle:@"登出" forState:UIControlStateNormal];
    [loadButton1 addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *loadButton2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 424, 40, 40)];
    loadButton2.backgroundColor = [UIColor blueColor];
    [loadButton2 setTitle:@"获取" forState:UIControlStateNormal];
    [loadButton2 addTarget:self action:@selector(loadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    loadButton.tag = 40;
    loadButton1.tag = 41;
    loadButton2.tag = 42;
    
    [self.view addSubview:loadButton];
    [self.view addSubview:loadButton1];
    [self.view addSubview:loadButton2];
}
-(void)loadButtonAction:(UIButton *)button {
    
    NSInteger tag = button.tag;
    if (tag == 40) {
        AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
        SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
        [sinaWeibo logIn];

    }
    else if (tag == 41){
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
        
        [sinaWeibo logOut];

        
    }
    else {
        AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        //如果已经登陆则获取微博数据
        if (appDelegate.sinaWeibo.isLoggedIn) {
            //请求网路链接 获取用户微博
            //https://api.weibo.com/2/statuses/user_timeline.json
            [appDelegate.sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                                           params:[NSMutableDictionary dictionaryWithObject:appDelegate.sinaWeibo.userID forKey:@"uid"]
                                       httpMethod:@"GET"
                                         delegate:self];
            
            return;
        }
        [appDelegate.sinaWeibo logIn];

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
