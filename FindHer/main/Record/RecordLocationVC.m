//
//  RecordLocationVC.m
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "RecordLocationVC.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "LocationModel.h"

#import "DBManager.h"

@interface RecordLocationVC ()
<MAMapViewDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate>{
    MAUserLocation *MYUserLocation;
    
    CLLocationManager *mangerl;
}

@property (nonatomic,strong) AMapLocationManager *locationManager;


@property (nonatomic,strong)MAMapView *mapView;

 @end

@implementation RecordLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];

//     [CLLocationManager locationServicesEnabled];
    
     // Do any additional setup after loading the view, typically from a nib.
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    _mapView.delegate = self;

    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    _mapView.showsScale = YES;
    _mapView.showsCompass = YES;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"record" style:UIBarButtonItemStylePlain target:self action:@selector(recordAction:)];
    
    
    
}
-(void)recordAction:(UIBarButtonItem*)item{
 
    UIAlertController *alertview=[ UIAlertController alertControllerWithTitle:@"input distance" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertview addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"please input the distace";
    }];
    
    [alertview addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.placeholder = @"please input a name for marker";
    }];
    
    UIAlertAction *aletAcion = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UITextField *tf = alertview.textFields[0];
        
        if (tf.text.length>0) {
            
            LocationModel *model = [LocationModel new];
            model.distance = tf.text.floatValue;
            
            CGFloat randomtail = 0;// arc4random()%100/100.0;
            
            
            model.latitude = MYUserLocation.location.coordinate.latitude;
            model.longitude = MYUserLocation.location.coordinate.longitude;
            
            if (!MYUserLocation) {
                model.latitude = 11;
                model.longitude = 100;
            }
//            model.location = CLLocationCoordinate2DMake(MYUserLocation.location.coordinate.latitude, MYUserLocation.location.coordinate.longitude+randomtail);
            model.time = [NSDate date];
            model.id = [LocationModel incrementaID];
            
            UITextField *tf2 = alertview.textFields[1];

            model.address = tf2.text?:@"empty";
            
            if (self.recordDataBlock) {
                self.recordDataBlock(model);
            }
            
            [[DBManager shareInstance] saveLocation:model];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            
        }
        
        
        
    }];
    [alertview addAction:aletAcion];
    
    UIAlertAction *cancelaletAcion = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertview addAction:cancelaletAcion];
    
    
    [self presentViewController:alertview animated:YES completion:nil];

}




#pragma mark - mapview delegate
#pragma mark - MAMapViewDelegate
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager
{
    NSLog(@"%s",__func__);
    [locationManager requestWhenInUseAuthorization];
}



- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    MYUserLocation = userLocation;
    
    
    if (!updatingLocation)
    {
        MAAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}

 - (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager
 {
     DebugMethod();
     [locationManager requestWhenInUseAuthorization];
 }


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[AMapLocationManager alloc] init];
#if DEBUG
        self.locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
#else
        self.locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
#endif
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.locatingWithReGeocode = NO;
      
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if(kCLAuthorizationStatusNotDetermined == status)
        {
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
           
            [locationManager requestWhenInUseAuthorization];
            
        }
        self.locationManager.delegate = self;
//        self.searchAPI = [[AMapSearchAPI alloc] init];
//        self.searchAPI.delegate = self;
//        [self setupCommand];
    }
    return self;
}

@end
