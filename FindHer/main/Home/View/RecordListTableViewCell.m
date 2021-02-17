//
//  RecordListTableViewCell.m
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "RecordListTableViewCell.h"

@interface RecordListTableViewCell ()

@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *coorlabel;
@property (nonatomic, strong) UILabel *distancelabel;
@property (nonatomic, strong) UILabel *isChooseLabel;

@end

@implementation RecordListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    DebugMethod();
    self.namelabel  = ({
        UILabel *lb = [UILabel new];
        lb.textColor = [UIColor redColor];
        lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        lb;
    });
    [self addSubview:self.namelabel];
   
    
    self.coorlabel  = ({
           UILabel *lb = [UILabel new];
           lb.textColor = [UIColor blueColor];
           lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
           lb;
       });
       [self addSubview:self.coorlabel];
    
    self.distancelabel  = ({
           UILabel *lb = [UILabel new];
           lb.textColor = [UIColor greenColor];
           lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
           lb;
       });
       [self addSubview:self.distancelabel];
    
    self.isChooseLabel  = ({
           UILabel *lb = [UILabel new];
           lb.textColor = [UIColor orangeColor];
           lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
           lb;
       });
       [self addSubview:self.isChooseLabel];
    
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
    }];
    [self.coorlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.namelabel);
        make.top.equalTo(self.namelabel.mas_bottom).offset(10);
    }];
    [self.distancelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.namelabel.mas_right).offset(10);
        make.centerY.equalTo(self.namelabel);
    }];
    [self.isChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coorlabel.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
    }];
    
    
    
    
    
}

-(void)setLocation:(LocationModel *)location{
    NSLog(@"%d",location.choosed);
    self.namelabel.text = [NSString stringWithFormat:@"name:%@", location.address];
    self.distancelabel.text = [NSString stringWithFormat:@"(distance:%@m)", @(location.distance)];
    self.coorlabel.text = [NSString stringWithFormat:@"(LA:%@,LN:%@)",@(location.latitude),@(location.longitude)];
    self.isChooseLabel.text  =location.choosed?@"VVVVVV":@"XXXXXX";
    
    self.backgroundColor = location.choosed?RandColor: [UIColor whiteColor];

}

-(void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    self.backgroundColor = isChoose?[UIColor yellowColor]: [UIColor whiteColor];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
