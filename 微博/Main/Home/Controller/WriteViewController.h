//
//  WriteViewController.h
//  微博
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZoomImageView.h"

@interface WriteViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    //编辑栏
    UIView *_editView ;
    //文本编辑栏
    UITextView *_textView ;
    //缩略图
    ZoomImageView *_zoomImageView;
    //位置管理器
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
    
    UIImagePickerControllerSourceType _sourceType;
    UIImage *_sendImage;
    
    
    
}


@end
