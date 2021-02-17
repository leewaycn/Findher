//
//  LocationModel.h
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Realm/Realm.h>
#import <MapKit/MapKit.h>

@interface LocationModel : RLMObject
<NSCopying>
@property int id;


@property  float distance;
@property  float latitude;
@property  float longitude;

//@property (nonatomic, assign) CLLocationCoordinate2D location;

@property  NSDate *time;
@property  NSString *address;

@property  BOOL choosed;

// 自动管理键值
+ (int)incrementaID;

- (NSArray *)recombinantRLMArray:(RLMArray *)rlmArray appendObject:(RLMObject *)object;


@end



//
//@property (nonatomic,assign) float distance;
//
//@property (nonatomic,assign) CLLocationCoordinate2D location;
//
//@property (nonatomic,strong) NSDate *time;
//@property (nonatomic,strong) NSString *address;
//
//@property (nonatomic,assign) BOOL choosed;
