//
//  ViewController.m
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "HomeViewController.h"
#import "RecordLocationVC.h"


#import "RecordListTableViewCell.h"
#import "AnalysticsVC.h"
#import "DBManager.h"


@interface HomeViewController ()
<UITableViewDelegate,UITableViewDataSource,
AMapLocationManagerDelegate,CLLocationManagerDelegate
>
@property (nonatomic,strong) AMapLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSMutableArray *locationList;


@end

@implementation HomeViewController

//-(void)loadView{
//    UIImageView *imagev  = [UIImageView new];
//    imagev.image =IMAGENAME(@"miniyellow");
//    imagev.contentMode = UIViewContentModeScaleAspectFill;
//    self.view = imagev;
//}

- (IBAction)clearAction:(id)sender {
    NSLog(@"%s",__func__);
    
    [[DBManager shareInstance]clearLocations];
    
    self.locationList = [[DBManager shareInstance]getAllLocation];
    [self.tableview reloadData];
    

    
}
- (IBAction)recordAction:(id)sender {
    NSLog(@"%s",__func__);
    RecordLocationVC *vc  = [RecordLocationVC new];
    
    __weak typeof(self) weakself = self;
    vc.recordDataBlock = ^(LocationModel * _Nonnull model) {
    
        [weakself.locationList addObject:model];
        [weakself.tableview reloadData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.locationList = [NSMutableArray array];
    
    self.locationList = [[DBManager shareInstance]getAllLocation];
    
    
    [self.tableview reloadData];
    
    
    [self initlocation];
    
    [self.view bringSubviewToFront:self.tableview];

    
}
- (IBAction)goToAnalys:(id)sender {
    DebugMethod();
    [self makeotherthingsAnalyst];

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locationList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordListTableViewCell"];
    if (!cell) {
        cell = [[RecordListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecordListTableViewCell"];
    }
    
    
    
    LocationModel *model = self.locationList[indexPath.row];
    cell.location = model;
    

//    if (0) {
//        cell.textLabel.text = [NSString stringWithFormat:@"%f-(LAT:%f,LONG:%f)", model.distance,model.location.latitude,model.location.longitude];///
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
//        if (model.choosed) {
//            cell.textLabel.textColor = [UIColor redColor];
//        }else{
//            cell.textLabel.textColor = [UIColor blackColor];
//        }
//    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
    
    @try {
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        LocationModel *model = self.locationList[indexPath.row]; //copy];
        
        BOOL choose = model.choosed;
        
        model.choosed = !choose;//!model.choosed;
        
        if ([model isInvalidated]) {
            NSLog(@"fsdfsdfsd");
            [realm commitWriteTransaction];

            return;
        }
        
        RLMResults *res  = [[LocationModel allObjects] objectsWhere:@"id = %d",model.id];
        //        [realm beginWriteTransaction];
        
        if (res) {
//            [realm deleteObjects:res];
        }
        
        [LocationModel createOrUpdateInRealm:realm withValue:model];
        
        [realm commitWriteTransaction];
        
        
        
        //    [[DBManager shareInstance] saveLocation:model];
        
        [self.tableview reloadData];
//    [self makeotherthingsAnalyst];
    
    
    } @catch (NSException *exception) {
        NSLog(@"exceptionexception:%@",exception);
    } @finally {
    
    }
    
    
}
-(void)unchooseAll{
    NSLog(@"%s",__func__);
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];

    
    for (LocationModel *model in self.locationList) {
        model.choosed = NO;
//        [[DBManager shareInstance] saveLocation:model];
        [LocationModel createOrUpdateInRealm:realm withValue:model];

    }
    [realm commitWriteTransaction];

    
    
    [self.tableview reloadData];
}

-(void)makeotherthingsAnalyst{
    NSLog(@"%s",__func__);
    
    NSMutableArray *chooseData = [NSMutableArray array];
    for (LocationModel *model in self.locationList) {
        
        if (model.choosed) {
            [chooseData addObject:model];
        }
    }
    
    if (chooseData.count>0) {
        [self unchooseAll];
        [self gotoAnalyData:chooseData];
//        break;
    }
    
    
}
-(void)gotoAnalyData:(NSMutableArray*)datas{
    AnalysticsVC *vc = [AnalysticsVC new];
    vc.datas = datas;
    
    [self.navigationController pushViewController:vc animated:YES];

    
    
}



- (void)initlocation{
    DebugMethod();
    
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

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager
{
    DebugMethod();
    [locationManager requestWhenInUseAuthorization];
}

@end
