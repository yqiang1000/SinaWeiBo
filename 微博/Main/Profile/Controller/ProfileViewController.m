//
//  ProfileViewController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "WeiboViewFrameLayout.h"
#import "WeiboTableView.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@interface ProfileViewController ()
{
    NSMutableArray *_layoutArray;
    WeiboTableView *_tableView;
    UserModel *_user;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
}

-(void)createTableView {
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.isPerson = YES;
    [self.view addSubview:_tableView];
}

-(void)loadData {
    
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //是返回已经完成json解析的数据
//        NSLog(@"接收完毕 %@",result);
    NSArray *jsonArray = result[@"statuses"];
    
    _layoutArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in jsonArray) {
        
        WeiboViewFrameLayout *layout = [[WeiboViewFrameLayout alloc] init];
        
        layout.model = [[WeiboModel alloc] initWithDataDic:dic];
        
        [_layoutArray addObject:layout];
    }
    _tableView.data = _layoutArray;
    
    WeiboViewFrameLayout *layout = _layoutArray[0];
    WeiboModel *weiboMedel = layout.model;
    _tableView.userModel = weiboMedel.userModel;
    
    [_tableView reloadData];
    


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
