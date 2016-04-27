//
//  WeiboCell.h
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboViewFrameLayout.h"
#import "WeiboView.h"
#import "ThemeLabel.h"

@interface WeiboCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *rePostLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property (strong, nonatomic) WeiboViewFrameLayout *layout ;

@property (strong, nonatomic) WeiboView *weiboView ;

@end
