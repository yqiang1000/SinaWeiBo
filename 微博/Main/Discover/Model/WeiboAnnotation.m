//
//  WeiboAnnotation.m
//  微博
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


-(void)setModel:(WeiboModel *)model {
    if (_model != model) {
        _model = model;
        
        NSDictionary *geo = model.geo;
        
        NSArray *coordinates = [geo valueForKey:@"coordinates"];
        if (coordinates.count > 1) {
            NSString *longitude = [coordinates firstObject];
            NSString *latitude = [coordinates lastObject];
            
            //坐标一定要设置
            CGFloat lon = [longitude floatValue];
            CGFloat lat = [latitude floatValue];
            
            _coordinate = CLLocationCoordinate2DMake(lon, lat);
            
        }
    }
}


@end
