//
//  LocationViewController.h
//  微博
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Common.h"
#import "PoiModel.h"

@interface LocationViewController : BaseViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * dataList ;



@end
