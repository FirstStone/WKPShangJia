//
//  EmployeeManageCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "EmployeeManageCell.h"
#import "UIImageView+WebCache.h"
@interface EmployeeManageCell ()

@property(nonatomic,strong)UIImageView * brandImageView;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UILabel * timeLbl;


@end
@implementation EmployeeManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];

    }
    return self;
}

- (void)setUpUI
{
    
    _brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 35, 35)];
    
    _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_brandImageView.frame) + 10, _brandImageView.frame.origin.y  , SCREEN_WIDTH - 160, 15)];
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    _nameLbl.font = [UIFont systemFontOfSize:14];
    _nameLbl.textColor = [UIColor blackColor];
    
    _timeLbl  = [[UILabel alloc]initWithFrame:CGRectMake(_nameLbl.frame.origin.x, CGRectGetMaxY(_nameLbl.frame) + 5, _nameLbl.frame.size.width, 15)];
    _timeLbl.textAlignment = NSTextAlignmentLeft;
    _timeLbl.font = [UIFont systemFontOfSize:13];
    _timeLbl.textColor = WKPColor(186, 186, 186);
    
    
     [self.contentView addSubview:_brandImageView];
     [self.contentView addSubview:_nameLbl];
     [self.contentView addSubview:_timeLbl];


    
}

- (void)setDataWith:(Employee *)employee
{
    
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString:employee.uface]];
    _nameLbl.text = [NSString stringWithFormat:@"%@ (%@)",employee.realname,employee.jobName];
    _timeLbl.text = employee.mobile;
 
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
