//
//  HeaderView.m
//  微博
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "HeaderView.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"

@implementation HeaderView



-(void)setUserModel:(UserModel *)userModel {
    if (_userModel != userModel) {

        _userModel = userModel;
        //头像
        NSString *imageStr = _userModel.avatar_large;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"Default"]];
        //昵称
        _nameLabel.text = _userModel.name;
        //地址
        NSString *sex = _userModel.gender;
        NSString *add = _userModel.location;
        _addressLabel.text = [NSString stringWithFormat:@"性别:%@ %@",sex,add];
        //简介
        _briefLabel.text = _userModel.url;

    }

}



@end
