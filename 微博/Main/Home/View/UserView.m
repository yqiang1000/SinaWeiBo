//
//  UserView.m
//  微博
//
//  Created by mac on 15/10/18.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

@implementation UserView

-(void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self setNeedsLayout];
    }
}

-(void)setNeedsLayout {
    [super setNeedsLayout];

    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImageView.layer.borderWidth = 1;
    _userImageView.layer.cornerRadius = _userImageView.width/2;
    _userImageView.layer.masksToBounds = YES;
    
    //1.用户头像
    NSString *imgURL = self.weiboModel.userModel.avatar_large;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    
    
    
    //2.昵称
    _nameLabel.text = self.weiboModel.userModel.screen_name;
    
    //3.发布时间
    //    _createLabel.text = [UIUtils fomateString:self.weiboModel.createDate];
    
    //4.来源
    _sourceLabel.text = self.weiboModel.source;
}


@end
