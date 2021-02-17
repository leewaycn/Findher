//
//  RecordLocationVC.h
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordLocationVC : UIViewController


@property (nonatomic,copy) void (^recordDataBlock)(LocationModel *model);


@end

NS_ASSUME_NONNULL_END
