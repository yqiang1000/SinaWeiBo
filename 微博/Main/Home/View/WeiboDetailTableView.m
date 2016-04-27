//
//  WeiboDetailTableView.m
//  微博
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboDetailTableView.h"
#import "WeiboDetailCell.h"
#import "WeiboViewFrameLayout.h"
#import "WeiboCell.h"
#import "CommentCell.h"

@implementation WeiboDetailTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {

        [self createHeaderView];
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentCell"];

    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _commentDataArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *commentModel = _commentDataArray[indexPath.row];
    CGFloat height = [CommentCell getCommentHeight:commentModel];
    
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //1 组视图
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    //2 评论Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.font = [UIFont systemFontOfSize:16.0];
    countLabel.textColor = [UIColor blackColor];
    
    //3 评论数
    NSNumber *count = _commentDic[@"total_number"];
    NSInteger value = [count integerValue];
    countLabel.text = [NSString stringWithFormat:@"评论数:%li",value];
    [sectionHeaderView addSubview:countLabel];
    sectionHeaderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];

    return sectionHeaderView;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.commentModel = self.commentDataArray[indexPath.row];
    
    return cell;
}

-(void)createHeaderView {
    
    _theTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _theTableHeaderView.backgroundColor = [UIColor clearColor];
    
    //从xib中获取_userView
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil] lastObject];
    _userView.backgroundColor = [UIColor clearColor];
    _userView.width = kScreenWidth;
    _userView.backgroundColor =  [UIColor colorWithWhite:0.5 alpha:0.1];
    [_theTableHeaderView addSubview:_userView];
    
    //创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _weiboView.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_theTableHeaderView addSubview:_weiboView];
    
    
    
}


-(void)setModel:(WeiboModel *)model {
    if (_model != model ) {
        _model = model;
        
        //创建微博布局对象
        WeiboViewFrameLayout *layout = [[WeiboViewFrameLayout alloc] init];
        //赋值
        layout.isDetail = YES;
        layout.model = model;
        #pragma mark - 检查
        _weiboView.layout = layout;
        _weiboView.frame = layout.frame;
        _weiboView.top = _userView.bottom + 20;

        //用户视图
        _userView.weiboModel = model;
        
        //设置头视图
        _theTableHeaderView.height = _weiboView.bottom;
        self.tableHeaderView = _theTableHeaderView;
    }
    
}






@end
