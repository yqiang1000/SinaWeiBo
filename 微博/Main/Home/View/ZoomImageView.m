//
//  ZoomImageView.m
//  微博
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "UIViewExt.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>


@interface ZoomImageView ()<NSURLConnectionDataDelegate>
{
    
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    double _length;
    NSURLConnection *_connection;
    NSMutableData *_data;
    MBProgressHUD *_hud;
    
    
    
}
@end

@implementation ZoomImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTap];
        [self createIconView];
    }
    return self;
    
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initTap];
        [self createIconView];
    }
    return self;
}
- (instancetype) initWithImage:(UIImage *)image{
    
    self = [super initWithImage:image];
    if (self) {
        [self initTap];
        [self createIconView];
    }
    return self;
}

-(void)createIconView {
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconView];
    _iconView.hidden = YES;
}

-(void)createView {
    if (_scrollView == nil) {
        //scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_scrollView];
        
        
        //_fullImageView
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.image = self.image;
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_fullImageView];
        
    }
    //单击缩小
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
    _fullImageView.userInteractionEnabled = YES;
    [_fullImageView addGestureRecognizer:tap];
    
    
    
    //长按保存
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
    
    [_scrollView addGestureRecognizer:longPress];
    
    
}

-(void)initTap {
    //打开交互
    self.userInteractionEnabled = YES;
    //创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    //内容模式
    self.contentMode = UIViewContentModeScaleAspectFit;

}

-(void)zoomIn {
    //通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    
    self.hidden = YES;
    [self createView];
    
    //fullImageView的Frame
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        _fullImageView.frame = _scrollView.frame;
    }completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        //加载大图
        [self downBigImage];
        
    }];
    
}

-(void)zoomOut {
    //通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    //取消网络下载
    [_connection cancel];

    _scrollView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        
        //如果scrollView偏移了，偏移量也要算进去
        _fullImageView.top += _scrollView.contentOffset.y;
        
        
    }completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
//        _fullImageView = nil;
        self.hidden = NO;
        
    }];
    
    
}



-(void)downBigImage {

    if (_fullImageUrlString.length != 0) {
        //显示进度
        _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        //网络请求
        NSURL *url = [NSURL URLWithString:_fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];

    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"%@",response);
    //获取相应头
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *allHeadFields = httpResponse.allHeaderFields;
    
    _length = [[allHeadFields valueForKey:@"Content-Length"] doubleValue];
    _data = [[NSMutableData alloc] init];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"加载失败:%@",error);
    }else {
        NSLog(@"加载成功");
    }

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_data appendData:data];
    double receiveLength = _data.length;
    _hud.progress = receiveLength / _length;
    NSLog(@"下载进度:%.2f%%",receiveLength / _length * 100);

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    _hud.hidden = YES;
    NSLog(@"下载完毕");
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    //尺寸处理
    CGFloat height = image.size.height / image.size.width * kScreenWidth;
    if (height > kScreenHeigth) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _fullImageView.height = height;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
            
        }];
    
    }
    if (_isGif) {
        [self showGif];
        
    }
    
    
    
}

-(void)showGif {
    
    
    //webView播放器
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.frame];
//    webView.userInteractionEnabled = YES;
//    
//    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:webView];
    
    
    
    //第三方 sd_webImage
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    
//    //用imageIO
//    //创建片源
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) _data, NULL);
//    size_t count = CGImageSourceGetCount(source);
//    NSMutableArray *images = [NSMutableArray array];
//    
//    NSTimeInterval timer = 0.0f;
//    
//    for (int i = 0; i < count; i++) {
//        //取每张图片 存到images 数组中
//        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//        timer += 0.1;
//        [images addObject:[UIImage imageWithCGImage:image]];
//        
//        CGImageRelease(image);
//        
//    }
//    //播放方法一
//    _fullImageView.animationImages = images;
//    _fullImageView.animationDuration = timer;
//    [_fullImageView startAnimating];
//    
//    //播放方法二
//    UIImage *animImage = [UIImage animatedImageWithImages:images duration:timer];
//    _fullImageView.image = animImage;
//    CFRelease(source);
    
    
}



-(void)savePhoto:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alertView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消保存");
            return;
            break;
        case 1:
            NSLog(@"baocun");
            [self savePhoto];
            return;
        default:
            break;
    }
    
    
}

-(void)savePhoto {
    NSLog(@"hello");
    UIImage *image = _fullImageView.image;
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:DidFinishSavingWithError:contextInfo:), nil);
    
    
}
-(void)image:(UIImage *)image DidFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"保存成功");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延时隐藏
    [hud hide:YES afterDelay:1];
    
    
    
}


@end
