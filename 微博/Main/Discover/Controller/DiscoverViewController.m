//
//  DiscoverViewController.m
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"
#import "WeiboNearByViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)mapButton:(id)sender {
    
    NearByViewController *nearByVC = [[NearByViewController alloc] init];
    [self.navigationController pushViewController:nearByVC animated:YES];
}

- (IBAction)nearWeibo:(id)sender {
    WeiboNearByViewController *nearWeibo = [[WeiboNearByViewController alloc] init];
    [self.navigationController pushViewController:nearWeibo animated:YES];
}

- (IBAction)nearPerson:(id)sender {
//    NearByViewController *nearByVC = [[NearByViewController alloc] init];
//    [self.navigationController pushViewController:nearByVC animated:YES];
}
@end
