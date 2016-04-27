//
//  WeiboDetailController.m
//  微博
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboDetailController.h"
#import "WeiboDetailCell.h"
#import "WeiboDetailTableView.h"
#import "SinaWeiboRequest.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

@interface WeiboDetailController ()<UITableViewDataSource,UITableViewDelegate,SinaWeiboRequestDelegate>
{
    WeiboDetailTableView *_tableView ;
    SinaWeiboRequest *_request;
}
@end

@implementation WeiboDetailController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    [self loadData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_request disconnect];
}

-(void)createTableView {
    _tableView = [[WeiboDetailTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.model = self.model;
    
    //上拉加载
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

-(void)loadData {
    //微博ID
//    NSString *weiboId = [self.model.weiboId stringValue];

    NSString *weiboId = self.model.weiboIdStr;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    //1.url
    NSString *urlString = [NSString stringWithFormat:@"comments/show.json"];
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    _request = [sinaWeibo requestWithURL:urlString params:params httpMethod:@"GET" delegate:self];
    _request.tag = 100;
    
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeibo;
}

-(void)loadMoreData {
    
    NSString *urlString = [NSString stringWithFormat:@"comments/show.json"];
    
    NSString *weiboId = [self.model.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    //设置max_id 分页加载
    CommentModel *commentModel = [self.data lastObject];
    if (commentModel != nil) {
        return;
    }
    NSString *lastId = commentModel.idstr;
    [params setObject:lastId forKey:@"max_id"];
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request = [sinaWeibo requestWithURL:urlString params:params httpMethod:@"GET" delegate:self];
    _request.tag = 102;
    
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
//    NSLog(@"请求成功:%@",result);
    
    NSArray *array = result[@"comments"];
    
    NSMutableArray *commentModelArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        
        [commentModelArray addObject:commentModel];
    }
    
    if (request.tag == 100) {  //普通的
        self.data = commentModelArray;
    }
    else if (request.tag == 102) {  //下拉加载更多
        [_tableView.footer endRefreshing];
        if (commentModelArray.count > 0) {
            [commentModelArray removeObject:0];
            [_data addObjectsFromArray:commentModelArray];
        }
        else {
            return;
        }
    }
    
    _tableView.commentDataArray = self.data;
    _tableView.commentDic = result;
    [_tableView reloadData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
