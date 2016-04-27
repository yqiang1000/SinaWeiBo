//
//  WeiboAnnotationView.m
//  微博
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboAnnotationView.h"

@implementation WeiboAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 140, 40);
        [self createView];
        
    }
    return self;
}

-(void)createView {
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _headerImage.image = [UIImage imageNamed:@"icon"];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 40)];
    _label.backgroundColor = [UIColor redColor];
    _label.text = @"hello world";
    [self addSubview:_headerImage];
    [self addSubview:_label];

}

@end
