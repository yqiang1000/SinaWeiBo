//
//  CommentCell.h
//  微博
//
//  Created by mac on 15/10/18.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CommentModel.h"


@interface CommentCell : UITableViewCell<WXLabelDelegate>

{
    WXLabel *_commentTextLabel;
}

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) CommentModel *commentModel;

//计算单元格高度
+(CGFloat)getCommentHeight:(CommentModel *)commentModel;

@end
