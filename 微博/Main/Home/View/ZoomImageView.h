//
//  ZoomImageView.h
//  微博
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZoomImageView;

@protocol ZoomImageViewDelegate <NSObject>
//图片变大
-(void)imageWillZoomIn:(ZoomImageView *)imageView ;

-(void)imageWillZoomOut:(ZoomImageView *)imageView ;

@end



@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) id<ZoomImageViewDelegate> delegate ;

@property (nonatomic ,copy) NSString *fullImageUrlString;



//gif
@property (nonatomic,assign) BOOL isGif;
@property (nonatomic,strong) UIImageView *iconView;

@end
