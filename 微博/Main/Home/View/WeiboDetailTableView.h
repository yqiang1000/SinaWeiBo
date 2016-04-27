//
//  WeiboDetailTableView.h
//  微博
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "UserView.h"
#import "CommentModel.h"

@interface WeiboDetailTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    WeiboView *_weiboView;
    UserView *_userView;
    
    //头视图
    UIView *_theTableHeaderView;
    
}

@property (nonatomic, strong) NSArray *commentDataArray;
@property (nonatomic, strong) WeiboModel *model;
@property (nonatomic, strong) NSDictionary *commentDic;

@end
