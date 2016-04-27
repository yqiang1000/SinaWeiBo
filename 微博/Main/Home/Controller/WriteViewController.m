//
//  WriteViewController.m
//  微博
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WriteViewController.h"
#import "BaseNavigationController.h"
#import "ThemeButton.h"
#import "Common.h"
#import "UIViewExt.h"
#import "DataService.h"


@interface WriteViewController ()
{
    NSString *_text;
    NSString *_error;
    
}
@end

@implementation WriteViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏透明  或者设置默认偏移为空
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavigationBar];
    
    [self createSubView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
}

-(void)createNavigationBar {
    //button_icon_close
    //button_icon_ok@2x.png
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.normalImageName = @"button_icon_close";
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    
    ThemeButton *okButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    okButton.normalImageName = @"button_icon_ok";
    [okButton addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithCustomView:okButton];
    self.navigationItem.rightBarButtonItem = okItem;
    
    
    

}

#pragma mark - 发送和取消按钮
-(void)closeAction:(UIButton *)button {
    
    [_textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)okAction:(UIButton *)button {
    
    _text = _textView.text;
    _error = nil;
    
    if (_text.length <= 0) {
        _error = @"不能发送空内容";
    }
    else if (_text.length > 140) {
        _error = @"超过140个字";
    }
    
    if (_error == nil) {
        //提示发送
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要发送吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        [alertView show];
        return;
        
        };
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 ) {
        NSLog(@"取消发送");
        return;
        
    }
    else if (buttonIndex == 1){
        NSLog(@"确定发送");
        
        AFHTTPRequestOperation *operation = [DataService sendWeibo:_text image:_sendImage block:^(id result) {
            NSLog(@"发送成功:%@",result);
            [self showStatusTipWithTitle:@"发送成功" show:NO operation:nil];
        }];
    
        [self showStatusTipWithTitle:@"正在发送" show:YES operation:operation];
    
    
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}


-(void)createSubView {
    //文本编辑
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.editable = YES;
    //设置圆角
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.borderWidth = 2;
    [self.view addSubview:_textView];
    
    
    
    //编辑工具栏
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - 64, kScreenWidth, 55)];
    _editView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_editView];
    NSArray *imageArray = @[@"compose_toolbar_1.png",
                            @"compose_toolbar_4.png",
                            @"compose_toolbar_3.png",
                            @"compose_toolbar_5.png",
                            @"compose_toolbar_6.png",
                            ];
    
    CGFloat buttonWidth = kScreenWidth / imageArray.count;
    for (NSInteger i = 0 ; i < imageArray.count ; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, 55)];
        button.normalImageName = imageArray[i];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:button];
    }

    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
    _locationLabel.hidden = YES;
    _locationLabel.backgroundColor = [UIColor grayColor];
    _locationLabel.font = [UIFont systemFontOfSize:14];
    [_editView addSubview:_locationLabel];
    
}

-(void)editButtonAction:(UIButton *)button {
    NSInteger tag = button.tag - 200;
    switch (tag) {
        case 0: //发照片
            [self selectPhoto];
            break;
        case 1: //发话题
            [self selectButton];
            break;
        case 2: //@XX
            [self selectButton];
            break;
        case 3: //发位置
            [self _loaction];
            break;
        case 4: //发表情
            [self selectButton];
            break;
            
        default:
            break;
    }

}

#pragma mark - 选择照片
-(void)selectPhoto {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];

    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self photoFormLibrary];
            break;
        case 1:
            [self photoFormCamera];
            return;
            break;
            
        default:
            return;
            break;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = _sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

-(void)photoFormLibrary {
    _sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}
-(void)photoFormCamera {
    _sourceType = UIImagePickerControllerSourceTypeCamera;
    BOOL isCanema = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
    if (!isCanema) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到可用的摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 定位

#pragma mark - 地理位置

/*
 修改 info.plist 增加以下两项
 NSLocationWhenInUseUsageDescription  BOOL YES
 NSLocationAlwaysUsageDescription         string “提示描述”
 */
- (void)_loaction{
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        if (kVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"已经更新位置");
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"经度 %lf 纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address
    
    NSString *coordinateString = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:coordinateString forKey:@"coordinate"];
    
    __weak typeof(self) weakSelf = self;
    
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *geo = [result objectForKey:@"geos"];
        if (geo.count > 0) {
            NSDictionary *geoDic = [geo lastObject];
            
            NSString *address = [geoDic objectForKey:@"address"];
            NSLog(@"地址:%@",address);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf->_locationLabel.text = address;
                strongSelf->_locationLabel.hidden = NO;
            });
        }
    }];
    
    
// ios内置
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *place = [placemarks lastObject];
//        NSLog(@"%@",place.name);
//        
//        NSLog(@"%@",place.areasOfInterest);
//    }];
    


    
}



-(void)selectButton {
    NSLog(@"helloWorld");
}



#pragma mark - zoom代理
-(void)imageWillZoomIn:(ZoomImageView *)imageView {
    
    [_textView becomeFirstResponder];
}
-(void)imageWillZoomOut:(ZoomImageView *)imageView {
    [_textView resignFirstResponder];
}

#pragma mark - 键盘代理
-(void)keyBoardWillShow:(NSNotification *)notification {
//    NSLog(@"SHOW===%@",notification);
    //取出键盘的frame ---> 高度
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    CGRect frame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat height = frame.size.height;
    
    //设置_editView的高度
    [UIView animateWithDuration:0.25 animations:^{
        _editView.bottom = kScreenHeigth - 55 - height;
    }];
    
}
-(void)keyBoardWillHide:(NSNotification *)notification {
    //设置_editView的高度
    [UIView animateWithDuration:0.25 animations:^{
        _editView.frame = CGRectMake(0, kScreenHeigth, kScreenWidth, 55);
    }];
    

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_textView resignFirstResponder];
    
}

#pragma mark - 相册代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"%@",info);
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc] init];
        _zoomImageView.frame = CGRectMake(20, _textView.bottom+20, 80, 80);
        [self.view addSubview:_zoomImageView];
        _zoomImageView.delegate = self;
    }
    _zoomImageView.image = image;
    
    _sendImage = image;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


@end
