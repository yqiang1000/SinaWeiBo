//
//  ProfileViewController.h
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//
/*
 @property(nonatomic,copy)NSString *idstr;           //字符串型的用户UID
 @property(nonatomic,copy)NSString *screen_name;     //用户昵称
 @property(nonatomic,copy)NSString *location;        //用户所在地
 @property(nonatomic,copy)NSString *url;             //用户博客地址
 @property(nonatomic,copy)NSString * profile_image_url;  //用户头像地址，50×50像素
 @property(nonatomic,copy)NSString * avatar_large;  //用户大头像地址
 @property(nonatomic,copy)NSString * gender;             //性别，m：男、f：女、n：未知
 @property(nonatomic,retain)NSNumber * followers_count;    //粉丝数
 @property(nonatomic,retain)NSNumber * friends_count;     
 */


#import "BaseViewController.h"
#import "SinaWeiboRequest.h"

@interface ProfileViewController : BaseViewController<SinaWeiboRequestDelegate>

//@property (strong, nonatomic) IBOutlet UIImageView *headImage;
//@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *userAddressLabel;
//@property (strong, nonatomic) IBOutlet UILabel *userBrief;
//@property (strong, nonatomic) IBOutlet UIView *attention;
//@property (strong, nonatomic) IBOutlet UIView *fans;
//@property (strong, nonatomic) IBOutlet UIView *info;
//@property (strong, nonatomic) IBOutlet UIView *more;

@end
