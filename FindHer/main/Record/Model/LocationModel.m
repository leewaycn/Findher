//
//  LocationModel.m
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

-(id)copyWithZone:(NSZone *)zone{
    LocationModel *model = [LocationModel new];
    model.id = self.id;
    model.address = self.address;
    model.latitude = self.latitude;
    model.longitude = self.longitude;
    model.distance = self.distance;
    model.time = self.time;
    model.choosed = self.choosed;
    
    return model;
}
+(NSString*)primaryKey{
    return @"id";
}

+ (int)incrementaID{
    RLMResults *result = [[[self class]allObjects] sortedResultsUsingKeyPath:@"id" ascending:YES];
    if (result.count>0) {
        int lastID = [[[result lastObject]valueForKey:@"id"] intValue];
        return lastID + 1;
    }
    return 1;
}


- (NSArray *)recombinantRLMArray:(RLMArray *)rlmArray appendObject:(RLMObject *)object{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<rlmArray.count; i++) {
        [array addObject:rlmArray[i]];
    }
    if (object) {
        [array addObject:object];
    }
    return array.copy;
}



@end
