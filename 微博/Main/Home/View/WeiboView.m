//
//  WeiboView.m
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation WeiboView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return  self;
    
}

-(void)createSubViews {
    _textLabel = [[WXLabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.linespace = 5.0;
    _textLabel.wxLabelDelegate = self;
    
    _sourceLabel = [[WXLabel alloc] init];
    _sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.linespace = 5.0;
    _sourceLabel.wxLabelDelegate = self;
    
    //微博图片
    _imgView = [[ZoomImageView alloc] init];
    //背景图片
    _bgImageView = [[ThemeImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    //背景图片拉伸点
    _bgImageView.leftCap = 30;
    _bgImageView.topCap = 30;
    
    [self addSubview:_bgImageView];
    [self addSubview:_textLabel];
    [self addSubview:_sourceLabel];
    [self addSubview:_imgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange1:) name:kThemeChange object:nil];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)themeChange1:(NSNotification *)notification {
    
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
}

-(void)setLayout:(WeiboViewFrameLayout *)layout {
    
    if (_layout != layout) {
        _layout = layout;
        [self setNeedsLayout];
    }
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboModel *model = _layout.model;
    //微博文字
    _textLabel.frame = _layout.textFrame;
    _textLabel.text = model.text;
    _textLabel.wxLabelDelegate = self;
    _textLabel.font = [UIFont systemFontOfSize:FontSize_Weibo(_layout.isDetail)];
    
    _sourceLabel.font = [UIFont systemFontOfSize:FontSize_ReWeibo(_layout.isDetail)];
    _sourceLabel.wxLabelDelegate = self;

    
    if (model.reWeiboModel != nil) {  //有转发
        _bgImageView.hidden = NO;
        _sourceLabel.hidden = NO;
        
        //被转发的微博
        _sourceLabel.frame = _layout.srTextFrame;
        _sourceLabel.text = model.reWeiboModel.text;
        
        //背景图片
        _bgImageView.frame = _layout.bgImageFrame;
        _bgImageView.imgName = @"timeline_rt_border_9.png";
        
        //图片
        NSString *imageString = model.reWeiboModel.thumbnailImage;
        if (imageString == nil) {  //没图片
            _imgView.hidden = YES;
        }else {
            //大图链接
            _imgView.fullImageUrlString = model.reWeiboModel.originalImage;
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageString]];
            
        }
    }
    else {  //没转发
        _bgImageView.hidden = YES;
        _sourceLabel.hidden = YES;
        
        //图片
        NSString *imageString = model.thumbnailImage;
        if (imageString == nil) {
            _imgView.hidden = YES;
        }else {
            //大图链接
            _imgView.fullImageUrlString = model.originalImage;
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageString]];
            
        }
    }
    
    if (_imgView.hidden == NO) {
        _imgView.iconView.frame = CGRectMake(_imgView.width-24, _imgView.height-24, 24, 24);
        NSString *extersion;
        
        if (model.reWeiboModel != nil) {
            extersion = [model.reWeiboModel.thumbnailImage pathExtension];
        }else{
            extersion = [model.thumbnailImage pathExtension];
        }
        
        if ([extersion isEqualToString:@"gif"]) {
            //是gif图片
            _imgView.isGif = YES;
            _imgView.iconView.hidden = NO;
        }else {
            _imgView.isGif = NO;
            _imgView.iconView.hidden = YES;
            //不是gif
        }
    }
    
}


#pragma mark - WXLabel 的协议方法


- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    if ([context containsString:@"www."] || [context containsString:@"http"]) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.urlStr = context;
        [self.viewController.navigationController pushViewController:webVC animated:YES];
    }
    NSLog(@"点击");
}

- (NSString *)urlStringWithWXLabel:(WXLabel *)wxLabel {
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    //    NSLog(@"%@",wxLabel.text);
    NSString *urlStr = [NSString stringWithFormat:@"(%@)",regex2];
    return urlStr;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
//    return  [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
    return [UIColor redColor];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    
    return  [UIColor blueColor];
}






@end
