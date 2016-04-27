//
//  CommentCell.m
//  微博
//
//  Created by mac on 15/10/18.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "ThemeManager.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _commentTextLabel= [[WXLabel alloc] initWithFrame:CGRectZero];
        _commentTextLabel.font = [UIFont systemFontOfSize:16];
        _commentTextLabel.linespace = 5;
        _commentTextLabel.wxLabelDelegate = self;
        [self addSubview:_commentTextLabel];
        
    }
    return self;
    
    
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    //头像
    NSString *imageViewName = _commentModel.user.profile_image_url;
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:imageViewName]];
    
    //昵称
    _nameLabel.text = _commentModel.user.screen_name;
    
    //消息
    //单元格高度
    CGFloat height = [WXLabel getTextHeight:14.f width:240 text:_commentModel.text linespace:5];
    _commentTextLabel.frame = CGRectMake(_ImageView.right+5, _nameLabel.bottom+5, kScreenWidth - 70, height);
    _commentTextLabel.text = _commentModel.text;
    
}

-(NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //话题
    NSString *regex1 = @"#^#+#";  //\w 匹配字母或数字或下划线或汉字
    //网址
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    //@XX
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex3 = @"@\\w+"; //@"@[_$]";
    
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return regex;
    
}

-(UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    UIColor *color= [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
    return color;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}


//计算评论单元格的高度
+(CGFloat)getCommentHeight:(CommentModel *)commentModel {
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:kScreenWidth-70
                                       text:commentModel.text
                                  linespace:5];
    
    return height+40;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
