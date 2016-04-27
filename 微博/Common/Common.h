//
//  Common.h
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#ifndef ___Common_h
#define ___Common_h


#define kVersion   [[UIDevice currentDevice].systemVersion doubleValue]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height


#define kAppKey          @"680708663"
#define kAppSecret       @"745a2a5a846494f5d17f953c8b6da135"
#define kAppRedirectURI  @"http://sns.whalecloud.com/sina2/callback"




#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表
#define send_update @"statuses/update.json"  //发微博(不带图片)
#define send_upload @"statuses/upload.json"  //发微博(带图片)
#define geo_to_address @"location/geo/geo_to_address.json"  //查询坐标对应的位置
#define nearby_pois @"place/nearby/pois.json" // 附近商圈
#define nearby_timeline  @"place/nearby_timeline.json" //附近动态


//微博字体
#define FontSize_Weibo(isDetail)     isDetail?16:15
#define FontSize_ReWeibo(isDetail) isDetail?15:14



#endif
