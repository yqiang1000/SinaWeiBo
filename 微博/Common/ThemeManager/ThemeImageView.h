//
//  ThemeImageView.h
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, assign) CGFloat leftCap; //拉伸点
@property (nonatomic, assign) CGFloat topCap;

@end
