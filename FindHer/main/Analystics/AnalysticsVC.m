//
//  AnalysticsVC.m
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "AnalysticsVC.h"
#import "LocationModel.h"

//#import <AMapLocationKit/AMapLocationKit.h>
//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>


@interface AnalysticsVC ()<MAMapViewDelegate>


@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *MYannotations;
@property (nonatomic, strong) NSArray *circles;

@end

@implementation AnalysticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initAnnotations];
       
//       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                                                style:UIBarButtonItemStylePlain
//                                                                               target:self
//                                                                               action:@selector(returnAction)];
       
       self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
       self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       self.mapView.delegate = self;
       
       [self.view addSubview:self.mapView];
       
       [self.mapView addAnnotations:self.MYannotations];
       [self.mapView showAnnotations:self.MYannotations animated:YES];
       
       NSLog(@"self.annotations.cout = %ld",self.MYannotations.count);
       NSLog(@"mapView.annotations.oct = %ld",self.mapView.annotations.count);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"record" style:UIBarButtonItemStylePlain target:self action:@selector(recordAction:)];

    
    return;
    
    
    [self initAnnotations];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
//    [AMapServices sharedServices].enableHTTPS = YES;
    
    
    
    
    
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    
    _mapView.showsScale = YES;
    _mapView.showsCompass = YES;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"record" style:UIBarButtonItemStylePlain target:self action:@selector(recordAction:)];
  
//    [self drawData];
 }

-(void)recordAction:(id)sder{
    
    NSLog(@"%s",__func__);
    
    
    [self initAnnotations];
    
    [self.mapView addAnnotations:self.MYannotations];
    [self.mapView showAnnotations:self.MYannotations animated:YES];
    
    NSLog(@"selfelf.annotations.count.count == %ld",self.MYannotations.count);

       NSLog(@"self.mapView.annotations.count == %ld",self.mapView.annotations.count);
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self drawData];
    [self.mapView addOverlays:self.circles];

}

 #pragma mark - Initialization
 - (void)initAnnotations
 {
     self.MYannotations = [NSMutableArray array];
     
     CLLocationCoordinate2D coordinates[10] = {
         {39.992520, 116.336170},
         {39.992520, 116.336170},
         {39.998293, 116.352343},
         {40.004087, 116.348904},
         {40.001442, 116.353915},
         {39.989105, 116.353915},
         {39.989098, 116.360200},
         {39.998439, 116.360201},
         {39.979590, 116.324219},
         {39.978234, 116.352792}};
     
     for (int i = 0; i < 10; ++i)
     {
         MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
         a1.coordinate = coordinates[i];
         a1.title      = [NSString stringWithFormat:@"anno: %d", i];
         [self.MYannotations addObject:a1];
     }
 }
-(void)drawData{
    
    NSLog(@"%s",__func__);
    self.MYannotations = [NSMutableArray array];

    NSMutableArray *overlayser = [NSMutableArray array];
    for (LocationModel *model in self.datas) {
    
        NSLog(@"d .latit.longitude %f :%f :%f",model.distance,model.latitude,model.longitude);
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate =   CLLocationCoordinate2DMake(model.latitude, model.longitude);
        pointAnnotation.title = model.address;
        pointAnnotation.subtitle = [NSString stringWithFormat:@"%f",model.distance];

//        [_mapView addAnnotation:pointAnnotation];
//        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        [self.MYannotations addObject:pointAnnotation];
        
        
        
        MACircle *circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude) radius:model.distance< 15000?15000:2*model.distance];
         circle1.hollowShapes = @[[MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude) radius:model.distance]];
        
        [overlayser addObject:circle1];
        
        
    }
    NSLog(@"selfelf.annotations.count.count == %ld",self.MYannotations.count);

    self.circles = [NSArray arrayWithArray:overlayser];
    
    [self.mapView addAnnotations:self.MYannotations];
    [self.mapView showAnnotations:self.MYannotations animated:YES];
    
    [self.mapView addOverlays:overlayser];
    
    
    NSLog(@"self.mapView.annotations.count == %ld",self.mapView.annotations.count);
    [self.mapView reloadMap];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//
//    [self.mapView addOverlays:self.circles];
//}

#pragma mark - Initialization
- (void)initCircles {
    NSMutableArray *arr = [NSMutableArray array];
    /* Circle. */
    MACircle *circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.996441, 116.411146) radius:15000];
    [arr addObject:circle1];
    circle1.hollowShapes = @[[MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.996441, 116.411146) radius:5000]];
    
    
    MACircle *circle2 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(40.096441, 116.511146) radius:12000];
    [arr addObject:circle2];
    
    MACircle *circle3 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.896441, 116.311146) radius:9000];
    [arr addObject:circle3];
    
    
//    self.circles = [NSArray arrayWithArray:arr];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {    NSLog(@"%s",__func__);

        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 1;
        circleRenderer.strokeColor = [UIColor blueColor];
        
//        NSInteger index = [self.circles indexOfObject:overlay];
//        if(index == 0) {
            circleRenderer.fillColor   = [RandColor colorWithAlphaComponent:0.2];
//        } else if(index == 1) {
//            circleRenderer.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.3];
//        } else if(index == 2) {
//            circleRenderer.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.3];
//        } else {
//            circleRenderer.fillColor   = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
//        }
        
        return circleRenderer;
    }
    
    return nil;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    NSLog(@"%s",__func__);

    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

/*!
 @brief 当mapView新添加annotation views时调用此接口
 @param mapView 地图View
 @param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
}

/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
}

/*!
 @brief 标注view的accessory view(必须继承自UIControl)被点击时调用此接口
 @param mapView 地图View
 @param annotationView callout所属的标注view
 @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

/**
 *  标注view的calloutview整体点击时调用此接口
 *
 *  @param mapView 地图的view
 *  @param view calloutView所属的annotationView
 */
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view {
    
}

/*!
 @brief 拖动annotation view时view的状态变化，ios3.2以后支持
 @param mapView 地图View
 @param view annotation view
 @param newState 新状态
 @param oldState 旧状态
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    
}


#pragma mark - mapview delegate
#pragma mark - MAMapViewDelegate
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestWhenInUseAuthorization];
}

-(void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    NSLog(@"%s",__func__);
}
-(void)mapViewWillStartLoadingMap:(MAMapView *)mapView{
    NSLog(@"%s",__func__);
}


@end
