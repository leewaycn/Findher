//
//  DBManager.m
//  FindHer
//
//  Created by tql on 2020/6/12.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

+(instancetype)shareInstance{
    static DBManager *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[[self class]alloc]init];
    });
    return _share;
}

-(void)saveLocation:(LocationModel*)locModel{
    
    DebugMethod();
    if (![locModel isInvalidated]) {
        NSLog(@"Object has been deleted or invalidated.???");
        return;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *res  = [[LocationModel allObjects] objectsWhere:@"id = %d",locModel.id];
    [realm beginWriteTransaction];
    
    if (res) {
        [realm deleteObjects:res];
    }
    
    [LocationModel createOrUpdateInRealm:realm withValue:locModel];
    
    [realm commitWriteTransaction];
    
}

-(NSMutableArray*)getAllLocation{
    NSMutableArray *arr =[NSMutableArray new];
    RLMResults *results = [[LocationModel allObjects] sortedResultsUsingKeyPath:@"id" ascending:YES];
    for (int i = 0; i<results.count; i++) {
        
        LocationModel *model = [results objectAtIndex:i];
        if (![model isInvalidated]) {
            [arr addObject:model];
        }
    }
    
    return arr;
}
-(void)clearLocations{
    DebugMethod();

    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *res  = [LocationModel allObjects] ;
    [realm beginWriteTransaction];
    
    if (res) {
        [realm deleteObjects:res];
    }
    
    
    
    [realm commitWriteTransaction];
}

@end
