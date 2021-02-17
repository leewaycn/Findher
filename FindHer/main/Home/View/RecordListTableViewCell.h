//
//  RecordListTableViewCell.h
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationModel.h"

@interface RecordListTableViewCell : UITableViewCell

@property (nonatomic, assign)BOOL isChoose;

@property (nonatomic, strong) LocationModel *location;


@end



