//
//  UserView.h
//  微博
//
//  Created by mac on 15/10/18.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface UserView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (strong, nonatomic) WeiboModel *weiboModel;



@end
