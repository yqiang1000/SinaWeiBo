//
//  HeaderView.h
//  微博
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface HeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *briefLabel;
@property (strong, nonatomic) IBOutlet UIView *attentionView;
@property (strong, nonatomic) IBOutlet UIView *fansView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *moreView;

@property (strong, nonatomic) UserModel *userModel;

@end
