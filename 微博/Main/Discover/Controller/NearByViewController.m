//
//  NearByViewController.m
//  微博
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearByViewController ()
{
//    CLLocationCoordinate2D coordinate;
}
@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
    
    CLLocationCoordinate2D coordinate = {30.2042,120.2019};
    
    /*
     1 定义(遵循MKAnnotation协议 )annotation类-->MODEL
     2 创建 annotation对象，并且把对象加到mapView;
     3 实现mapView 的协议方法 ,创建标注视图
     */

    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"你好啊";
    annotation.subTitle = @"hello";
    [_mapView addAnnotation:annotation];
    
}


-(void)createViews {
    //创建地图
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //用户地理位置
    _mapView.showsUserLocation = YES;
    //地图种类
    _mapView.mapType = MKMapTypeStandard;
    //用户跟踪模式
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
}



#pragma mark - 定位用户当前的位置
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%@",userLocation);
    //获取经纬度
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度:%f 纬度:%f",coordinate.longitude,coordinate.latitude);
    
    
    //设置定位中心和精度
    CLLocationCoordinate2D center = coordinate;
    MKCoordinateSpan span = {0.5,0.5};
    MKCoordinateRegion region = {center,span};
    _mapView.region = region;

}

#pragma mark - 设置标注 标注地图
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *identifier = @"hello";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        //背景图片
//        pin.pinColor = MKPinAnnotationColorRed;
//        //从天而降
//        pin.animatesDrop = YES;
//        //显示标题
//        pin.canShowCallout = YES;
//    }
//    
//    return pin;
    
    
    WeiboAnnotationView *anno = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (self) {
        anno = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
    }
    return anno;
    
}




/*

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"hello";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        if (annotationView == nil) {
            annotationView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        return annotationView;
    }
    return  nil;
    

}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
