//
//  MoreTableViewCell.m
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self createSubView];
        [self themeChangeAction];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeChange object:nil];
    }
    return self;
    
    
    
}

-(void)themeChangeAction {
    
    self.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
}

-(void)createSubView {
    
    _themeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    _themeTextLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(_themeImageView.right+5, 11, 200, 20)];
    _themeDetailLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(self.right- 95-30, 11, 95, 20)];
    
    _themeTextLabel.font = [UIFont boldSystemFontOfSize:16];
    _themeTextLabel.backgroundColor = [UIColor clearColor];
    _themeTextLabel.colorName = @"More_Item_Text_color";
    
    _themeDetailLabel.font = [UIFont boldSystemFontOfSize:15];
    _themeDetailLabel.backgroundColor = [UIColor clearColor];
    _themeDetailLabel.colorName = @"More_Item_Text_color";
    _themeDetailLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_themeImageView];
    [self.contentView addSubview:_themeTextLabel];
    [self.contentView addSubview:_themeDetailLabel];

    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    _themeDetailLabel.frame = CGRectMake(self.right - 95-30, 11, 95, 20);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
