//
//  LocationViewController.m
//  微博
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LocationViewController.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"

@interface LocationViewController ()
{
    
    CLLocationManager *_locationManager ;
    UITableView *_tableView ;
    
}
@end

@implementation LocationViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"附近商圈";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
    [self location];
    
    
}


#pragma mark - 创建视图
-(void)createView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
    //创建返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

-(void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 定位
-(void)location {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        if (kVersion > 8.0 ) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //停止定位
    [_locationManager stopUpdatingLocation];
    //获取当前请求的位置
    CLLocation *location = [locations lastObject];
    
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];

    //开始加载网络
    [self loadNearByPoisWithhon:lon lat:lat];
    
}

//加载网络
-(void)loadNearByPoisWithhon:(NSString *)lon lat:(NSString *)lat {
    
    //配置请求参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    [params setObject:@50 forKey:@"count"];
    
    //请求数据
    //获取附近商家
    __weak typeof(self) weakSelf = self;
    [DataService requestUrl:nearby_pois httpMethod:@"GET" params:params block:^(id result) {
//        NSLog(@"%@",result);
        
        NSMutableArray *dataList = [[NSMutableArray alloc] init];
        
        NSArray *pois = [result valueForKey:@"pois"];
        for (NSDictionary *dic in pois) {
            //创建商圈对象模型
            PoiModel *poiModel = [[PoiModel alloc] initWithDataDic:dic];
            
            [dataList addObject:poiModel];
            
        }
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->_dataList = dataList;
        [strongSelf->_tableView reloadData];

    }];
    
}

#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    PoiModel *poi = _dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.textLabel.text = poi.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"地址:%@",poi.address];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
