//
//  ThemeChangeController.m
//  微博
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ThemeChangeController.h"
#import "Common.h"
#import "ThemeManager.h"

@interface ThemeChangeController ()
{
    NSArray *_themeNames;
    
}
@end

@implementation ThemeChangeController

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:kThemeChange object:nil];
    }
    return self;
    
}

-(void)themeChange {
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIImage *image = [manager getThemeImage:@"bg_home.jpg"];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"theme.plist" ofType:nil];
    
    NSDictionary *themeConfig = [NSDictionary dictionaryWithContentsOfFile:path];
    
    _themeNames = [themeConfig allKeys];

    [self createTableView];
    
    
}
//创建tableView
-(void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeNames.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    NSString *title = _themeNames[indexPath.row];
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIImage *image = [manager getThemeImage:@"bg_home.jpg"];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:image];
    
    cell.textLabel.text = title;
    cell.textLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *themeName = _themeNames[indexPath.row];
    
    [[ThemeManager shareInstance] setThemeName:themeName];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"主题：%@",themeName);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
