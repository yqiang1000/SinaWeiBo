//
//  BaseViewController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "Common.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MBProgressHUD.h"


@interface BaseViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *_hud;
    UIWindow *_tipWindow ;

    
}
@end

@implementation BaseViewController



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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarItem];
    
    [self loadImage];
    
}


-(void)themeChange:(NSNotification *)notification {
    
    [self loadImage];
   
}

-(void)loadImage {

    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:@"bg_home.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
}


-(void)setTabBarItem {

    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *bjLeftImage = [manager getThemeImage:@"button_title.png"];
    UIImage *leftImage = [manager getThemeImage:@"group_btn_all_on_title.png"];
    UIImage *bjRightImage = [manager getThemeImage:@"button_m.png"];
    UIImage *rightImage = [manager getThemeImage:@"button_icon_plus.png"];
    
    //左侧按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [leftButton setBackgroundImage:bjLeftImage forState:UIControlStateNormal];
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = 1000;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    //右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setBackgroundImage:bjRightImage forState:UIControlStateNormal];
//    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = 1001;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    
}

-(void)buttonAction:(UIButton *)button {
    
    NSInteger tag = button.tag;
    if (tag == 1000) {
        MMDrawerController *mmDrawer = self.mm_drawerController;
        [mmDrawer openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    if (tag == 1001) {
        MMDrawerController *mmDrawer = self.mm_drawerController;
        [mmDrawer openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }
    
}

//设置动作
-(void)setAction {
    
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}
//编辑动作
-(void)editAction {
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)showHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;
    [_hud hide:YES afterDelay:2];
    
}
-(void)hiddenHUD {
    _hud.hidden = YES;
}


#pragma mark - 进入主页加载数据的进度
-(void)completeHUD:(NSString *)title {
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1];
    
}


#pragma mark - 显示头视图
-(void)showStatusTipWithTitle:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation {
    
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.backgroundColor = [UIColor blackColor];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        
        UILabel *label = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100;
        [_tipWindow addSubview:label];
        
        
        //进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.tag = 101;
        progressView.frame = CGRectMake(0, 17, kScreenWidth, 5);
        progressView.progress = 0.0;
        [_tipWindow addSubview:progressView];
    
    }
    
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:100];
    label.text = title;
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    
    if (show) {
        [_tipWindow setHidden:NO];
        if (operation != nil) {
            progressView.hidden = NO;
           // [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
            
        }else {
            progressView.hidden = YES;
        }
    }else {
        [self performSelector:@selector(hideTipWindow) withObject:nil afterDelay:1];
        
    }
    
    
}

- (void)hideTipWindow{
    
    [_tipWindow setHidden:YES];
    
    _tipWindow = nil;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
