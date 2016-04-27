//
//  WeiboTableView.h
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSArray *data ;
@property (nonatomic, assign) BOOL isPerson;

@property (nonatomic, strong) UserModel *userModel;

@end
