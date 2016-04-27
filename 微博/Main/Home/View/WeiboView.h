//
//  WeiboView.h
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "WeiboViewFrameLayout.h"
#import "WeiboModel.h"
#import "WXLabel.h"
#import "ZoomImageView.h"

#import "WebViewController.h"
#import "UIView+UIViewController.h"
@interface WeiboView : UIView<WXLabelDelegate>

@property (nonatomic,strong)WXLabel *textLabel;//微博文字
@property (nonatomic,strong)WXLabel *sourceLabel;//如果转发则：原微博文字
@property (nonatomic,strong)ZoomImageView *imgView;// 微博图片
@property (nonatomic,strong)ThemeImageView *bgImageView;//原微博背景图片

@property (nonatomic,strong)WeiboViewFrameLayout *layout;


@end
