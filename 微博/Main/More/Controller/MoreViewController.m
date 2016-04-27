//
//  MoreViewController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeChangeController.h"
#import "MoreTableViewCell.h"
#import "AppDelegate.h"



@interface MoreViewController ()
{

    NSMutableArray *_cellModelArray;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    
}

-(void)createTableView {
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:@"MoreCell"];
    _tableView.scrollEnabled = NO;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return 2;
            break;
        case 1: return 1;
            break;
        default:return 1;
            break;
    }

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MoreCell";
    
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            cell.titleLabel.text = @"主题选择";
            cell.themeImageView.imgName = @"more_icon_theme.png";
            cell.themeTextLabel.text = @"主题选择";
            cell.themeDetailLabel.text = [ThemeManager shareInstance].themeName;
            
        }
        if (indexPath.row == 1) {
//            cell.titleLabel.text = @"账户管理";
            cell.themeImageView.imgName = @"more_icon_account.png";
            cell.themeTextLabel.text = @"账户管理";
        }
    }
    if (indexPath.section == 1) {
//        cell.titleLabel.text = @"意见反馈";
        cell.themeTextLabel.text = @"意见反馈";
        cell.themeImageView.imgName = @"more_icon_feedback.png";

    }
    else if (indexPath.section == 2) {
//        cell.titleLabel.text = @"退出当前帐号";
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([appDelegate.sinaWeibo isLoggedIn]) {
            cell.themeTextLabel.text = @"登出当前账号";
        } else {
            cell.themeTextLabel.text = @"登录";
        }
        cell.themeTextLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.themeTextLabel.center = cell.contentView.center;

    }
    //设置箭头
    if (indexPath.section < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }

    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //进入主题选择页面
    if (indexPath.row == 0 && indexPath.section == 0) {
        ThemeChangeController *vc = [[ThemeChangeController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //登出
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([appDelegate.sinaWeibo isLoggedIn]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认登出么?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.delegate = self;
            [alert show];
            
            
        }else{
            [appDelegate.sinaWeibo logIn];
            [_tableView reloadData];
            
        }
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate.sinaWeibo logOut];
        
    }
    
    [_tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}


@end
