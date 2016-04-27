//
//  HomeViewController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLayout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface HomeViewController ()<SinaWeiboRequestDelegate>
{

    WeiboTableView *_tableView;
    NSMutableArray *_data ;
    ThemeImageView *_showImage;
    ThemeLabel *_label;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];

    [self createTableView];
    
    [self loadData];
}

- (void)createTableView {
    
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    _tableView.isPerson = NO;
    [self.view addSubview:_tableView];
    
    
}

-(void)loadNewData {
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"10" forKey:@"count"];
    //设置最小值

    if (_data.count != 0) {
        WeiboViewFrameLayout *layout = _data[0];
        NSString *sinceId = layout.model.weiboIdStr;
        [params setValue:sinceId forKey:@"since_id"];

    }
    
    
    SinaWeiboRequest *request =[sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 101;
    
}
-(void)loadMoreData {
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (_data.count != 0) {
        WeiboViewFrameLayout *layout = [_data lastObject];
        NSString *maxId = layout.model.weiboIdStr;
        [params setValue:maxId forKey:@"max_id"];
        
    }
    SinaWeiboRequest *request =[sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];

    request.tag = 102;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData {
    
    [self showHUD:@"正在加载..."];
    
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"10" forKey:@"count"];
    [params setValue:sinaWeibo.userID forKey:@"uid"];
    
    
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 100;
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    //是返回已经完成json解析的数据
//   NSLog(@"接收完毕 %@",result);
    //获取当前的request数据
    NSArray *jsonArray = result[@"statuses"];
    NSMutableArray *layoutArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    for (NSDictionary *dic in jsonArray) {
        
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
        WeiboViewFrameLayout *layout = [[WeiboViewFrameLayout alloc] init];
        layout.model = model;
        
        [layoutArray addObject:layout];
    }
    
    
    //拼接_data 数据
    if (request.tag == 100 ) { //普通加载
        _data = layoutArray;
        
        [self completeHUD:@"加载完成"];
    }
    else if (request.tag == 101) //最新
    {
        if (layoutArray.count > 0)
        {
            NSRange range = NSMakeRange(0, layoutArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:layoutArray atIndexes:indexSet];
            [self showNewCount:layoutArray.count];
        }
        
    }
    
    else if (request.tag == 102) //更多
    {
        if (layoutArray.count > 1) {
            [layoutArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutArray];
        }
    }
    
    if (_data.count != 0) {
        _tableView.data = _data;
        
        [_tableView reloadData];
        
//        [self hiddenHUD];
        
        
    }
    
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
}

-(void)showNewCount:(NSInteger)count {
    if (_showImage == nil) {
        //背景图片
        _showImage = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        _showImage.imgName = @"timeline_notify.png";
        [self.view addSubview:_showImage];
        //文字
        _label = [[ThemeLabel alloc] initWithFrame:_showImage.bounds];
        _label.colorName = @"timeline_notify.png";
        _label.textAlignment = NSTextAlignmentCenter;
        [_showImage addSubview:_label];
        
    }
    if (count > 0) {
        _label.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        
        [UIView animateWithDuration:0.5 animations:^{
            _showImage.transform = CGAffineTransformMakeTranslation(0, 64+40);
            
        } completion:^(BOOL finished) {
            //停留一秒在恢复
            [UIView animateWithDuration:0.5 animations:^{
                [UIView setAnimationDelay:1];
                _showImage.transform = CGAffineTransformIdentity;
            }];
        }];

    }
    
    
}

@end
