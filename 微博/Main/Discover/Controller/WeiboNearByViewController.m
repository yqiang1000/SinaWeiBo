//
//  WeiboNearByViewController.m
//  微博
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboNearByViewController.h"
#import "DataService.h"
#import "Common.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "NearWeiboAnnotationView.h"
#import "WeiboDetailController.h"

@interface WeiboNearByViewController ()
{
    MKMapView *_mapView ;
    
}
@end

@implementation WeiboNearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
}



-(void)createView {
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //map模式
    _mapView.mapType = MKMapTypeStandard;
    //map跟踪模式
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    //用户的位置
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSString * lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString * lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
//    NSLog(@"经度：%f,纬度：%f",lon,lat);
    
    //设置定位的中心点和范围
    CLLocationCoordinate2D center = coordinate;
    MKCoordinateSpan span = {0.5,0.5};
    MKCoordinateRegion region = {center ,span };
    _mapView.region = region;
    
    //获取附近的微博
    [self loadWeiboWithLongtitude:lon latitude:lat];
    
 
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *identifier = @"weibo";
    
    //处理当前位置
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        NearWeiboAnnotationView *view = (NearWeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (view == nil) {
            
            view = [[NearWeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        view.annotation = annotation;
        [view setNeedsLayout];
        return view;
    }
    
    return nil;
    
}


#pragma mark - mapView 代理
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"选中");
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]]) {
        return;
    }
    
    
    WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)view.annotation;
    WeiboModel *weiboModel = weiboAnnotation.model;
    
    WeiboDetailController *vc = [[WeiboDetailController alloc] init];
    vc.model  = weiboModel;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


//网络请求
-(void)loadWeiboWithLongtitude:(NSString *)lon latitude:(NSString *)lat {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:lon forKey:@"long"];
    [params setValue:lat forKey:@"lat"];
    
    [DataService requestUrl:nearby_timeline httpMethod:@"GET" params:params block:^(id result) {

        NSArray *statuses = [result valueForKey:@"statuses"];
        NSMutableArray *annotationArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
        
        for (NSDictionary *dic in statuses) {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
    
            [annotationArray addObject:annotation];
            
        }
        
        [_mapView addAnnotations:annotationArray];
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
