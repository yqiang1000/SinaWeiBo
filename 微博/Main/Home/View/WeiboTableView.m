//
//  WeiboTableView.m
//  微博
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboViewFrameLayout.h"
#import "WeiboDetailController.h"
#import "UIView+UIViewController.h"
#import "HeaderView.h"


@implementation WeiboTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        //注册单元格
        [self registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:@"WeiboCell"];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return  self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"****%li",_data.count);
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //单元格复用方法一
    
    //方法二
    //前提是先注册单元格
    WeiboCell *cell = (WeiboCell *) [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];

    WeiboViewFrameLayout *layout = _data[indexPath.row];
    
    //cell的model被设置的时候会重新布局子视图
    cell.layout = layout;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboViewFrameLayout *layout =  _data[indexPath.row];

    return layout.frame.size.height + 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboDetailController *weiboDetailVC = [[WeiboDetailController alloc] init];
    
    //传递当前微博信息的数据
    WeiboViewFrameLayout *layout = _data[indexPath.row];
    weiboDetailVC.model = layout.model;
    //获取导航控制器
    [self.viewController.navigationController pushViewController:weiboDetailVC animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isPerson) {
        return 230;
    }
    else {
        return 0;
    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isPerson) {
        HeaderView *headerView = (HeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"HearderView" owner:self options:nil]lastObject] ;
        headerView.userModel = _userModel;
        
        return headerView;
    }
    else return nil;
    
}



@end
