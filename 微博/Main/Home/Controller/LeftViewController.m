//
//  LeftViewController.m
//  微博
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LeftViewController.h"
#import "Common.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_array1;
    NSArray *_array2;
    NSArray *_array3;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
}

-(void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, kScreenHeigth) style:UITableViewStyleGrouped];
    
    _array1 = @[@"无",@"偏移",@"偏移&缩放",@"旋转",@"视差"];
    _array2 = @[@"大图",@"小图"];
    _array3 = @[@"页面切换效果",@"图片浏览模式"];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _array1.count;
    }
    else {
        return _array2.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    label.text = _array3[section];
    return label;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"leftCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, cell.bounds.size.width-20, cell.bounds.size.height)];
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    if (indexPath.section == 0) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
        label.text = _array1[indexPath.row];
    }
    else {
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
        label.text = _array2[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *allCell = [tableView visibleCells];
    for (UITableViewCell *cell in allCell) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor = [UIColor purpleColor];
    cell.selectedBackgroundView = view;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
