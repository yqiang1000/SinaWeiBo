//
//  MoreTableViewCell.h
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "ThemeImageView.h"


@interface MoreTableViewCell : UITableViewCell

@property (nonatomic, strong) ThemeImageView * themeImageView ;
@property (nonatomic, strong) ThemeLabel * themeTextLabel ;
@property (nonatomic, strong) ThemeLabel * themeDetailLabel ;

@end
