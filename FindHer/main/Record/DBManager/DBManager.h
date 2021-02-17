//
//  DBManager.h
//  FindHer
//
//  Created by tql on 2020/6/12.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocationModel.h"


@interface DBManager : NSObject

+(instancetype)shareInstance;

-(void)saveLocation:(LocationModel*)locModel;

-(NSMutableArray*)getAllLocation;

-(void)clearLocations;



@end

 
