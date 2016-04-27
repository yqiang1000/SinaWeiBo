//
//  NearByViewController.h
//  微博
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearByViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    MKMapView *_mapView;
}

@end
