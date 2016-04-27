//
//  NearWeiboAnnotationView.m
//  微博
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "NearWeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation NearWeiboAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 140, 40);
        [self createViews];
    }
    return self;

}

-(void)createViews {
    
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _headerImage.image = [UIImage imageNamed:@"icon"];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 40)];
    _textLabel.backgroundColor = [UIColor darkGrayColor];
    _textLabel.text = @"hello world";
    _textLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:_headerImage];
    [self addSubview:_textLabel];
    
}


-(void)layoutSubviews {

    [super layoutSubviews];
    WeiboAnnotation *annotation = self.annotation;
    WeiboModel *model = annotation.model;
    //微博内容
    _textLabel.text = model.text;
    _textLabel.font = [UIFont systemFontOfSize:10];
    _textLabel.numberOfLines = 3;
    
    //头像
    NSString *urlStr = model.userModel.profile_image_url;
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
}




@end
