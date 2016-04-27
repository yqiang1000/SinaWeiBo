//
//  WeiboDetailController.h
//  微博
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"


@interface WeiboDetailController : UIViewController



@property (nonatomic, strong) WeiboModel *model;

//评论列表
@property (nonatomic, strong) NSMutableArray *data;


@end
