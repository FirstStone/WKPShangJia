//
//  ChooseMapViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/10/20.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//


#import "ChooseMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <MapKit/MapKit.h>
#import "MerchantInforViewController.h"
@interface ChooseMapViewController()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lon;
@property (nonatomic,assign) float firstlat;
@property (nonatomic,assign) float firstlon;
@property (nonatomic,strong)BMKPointAnnotation* annotation;
@end

@implementation ChooseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地图位置";
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"确定" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(onClickedOKbtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    [self getLatLon];
  
}

-(void)openMap
{
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate =self;
    CLLocationCoordinate2D coor;
    coor.latitude = self.lat;
    coor.longitude = self.lon;
    self.mapView.centerCoordinate = coor;
    //更新位置数据
    self.mapView.zoomLevel =18;
    //添加到view上
    [self.view addSubview:self.mapView];
    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    //设置代理
    self.service.delegate = self;
    
    //开启定位
    [self.service startUserLocationService];
    // Do any additional setup after loading the view.
}
//获取经纬度
- (void)getLatLon
{
    CLGeocoder *geoc = [[CLGeocoder alloc]init];
    // 根据地址关键字, 进行地理编码
    [geoc geocodeAddressString:self.address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        /**
         *  CLPlacemark : 地标对象
         *  location : 对应的位置对象
         *  name : 地址全称
         *  locality : 城市
         *  按相关性进行排序
         */
        CLPlacemark *pl = [placemarks firstObject];
        
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            self.lat = pl.location.coordinate.latitude;
            self.lon = pl.location.coordinate.longitude;
            [self openMap];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.service.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    self.service.delegate = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 添加一个PointAnnotation
    _annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.lat;
    coor.longitude = self.lon;
    _annotation.coordinate = coor;
    [_mapView addAnnotation:_annotation];
}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    self.lat = coordinate.latitude;
    self.lon = coordinate.longitude;
    [self addPointAnnotation];
}

//添加标注
- (void)addPointAnnotation
{
    [_mapView removeAnnotation:_annotation];
    _annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.lat;
    coor.longitude = self.lon;
    _annotation.coordinate = coor;
    [_mapView addAnnotation:_annotation];
}
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

-(void)onClickedOKbtn
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",self.lon] forKey:@"lon"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",self.lat] forKey:@"lat"];
    NSArray *temArray = self.navigationController.viewControllers;
    
    for(UIViewController *temVC in temArray)
        
    {
        if ([temVC isKindOfClass:[MerchantInforViewController class]])
        {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
