//
//  WeiboCell.m
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"

@implementation WeiboCell

- (void)awakeFromNib {
    
    [self createSubViews];

}
-(void)createSubViews {
    _weiboView = [[WeiboView alloc] init];
    [self.contentView addSubview:_weiboView];
}


-(void)setLayout:(WeiboViewFrameLayout *)layout {
    
    if (_layout != layout) {
        _layout = layout;
        _weiboView.layout = _layout;
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsLayout];
        
    }
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    WeiboModel *_model = _layout.model;
    //头像
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_model.userModel.profile_image_url]];
    //昵称
    _nameLabel.text = _model.userModel.screen_name;
    //转发
    NSString *repost = [_model.repostsCount stringValue];
    _rePostLabel.text = [NSString stringWithFormat:@"转发:%@",repost];

    //评论
    NSString *comment = [_model.commentsCount stringValue];
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",comment];
    
    //来源
    _sourceLabel.text = _model.source;

    _weiboView.frame = _layout.frame;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
