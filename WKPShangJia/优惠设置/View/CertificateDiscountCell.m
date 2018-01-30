//
//  CertificateDiscountCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/9/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "CertificateDiscountCell.h"
@interface CertificateDiscountCell()
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * stateLbl;
@property(nonatomic,strong)UILabel * numLbl;
@property(nonatomic,strong)UILabel * timeLbl;
@property(nonatomic,strong)UIImageView * backView;
@end
@implementation CertificateDiscountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 120)];
    
    
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH /2 - 40 , 30)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:24];
    _titleLbl.textColor = [UIColor whiteColor];
    
    _stateLbl = [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_titleLbl.frame) + 10  , SCREEN_WIDTH /2 - 40 , 20)];
    _stateLbl.textAlignment = NSTextAlignmentLeft;
    _stateLbl.font = [UIFont systemFontOfSize:12];
    _stateLbl.textColor = [UIColor whiteColor];
    
    _numLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2, _titleLbl.frame.origin.y + 10  , SCREEN_WIDTH /2 - 40 , 20)];
    _numLbl.textAlignment = NSTextAlignmentRight;
    _numLbl.font = [UIFont systemFontOfSize:12];
    _numLbl.textColor = [UIColor whiteColor];
    
    _timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(_numLbl.frame.origin.x, _stateLbl.frame.origin.y  , SCREEN_WIDTH /2 - 40 , 20)];
    _timeLbl.textAlignment = NSTextAlignmentRight;
    _timeLbl.font = [UIFont systemFontOfSize:12];
    _timeLbl.textColor = [UIColor whiteColor];
    
    [_backView addSubview:_titleLbl];
    [_backView addSubview:_stateLbl];
    [_backView addSubview:_numLbl];
    [_backView addSubview:_timeLbl];
    [self.contentView addSubview:_backView];
}

-(void)setData:(CertificateDiscount*)certificateDiscount
{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy.MM.dd"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    if ([certificateDiscount.end_time  integerValue] > date) {
        _stateLbl.text = @"进行中";
        _backView.image = [UIImage imageNamed:@"quanti"];
    }
    else
    {
        _stateLbl.text = @"已结束";
        _backView.image = [UIImage imageNamed:@"guoqiduihuanquan"];

    }
    
    _titleLbl.text = certificateDiscount.title;
    
    _numLbl.text = [NSString stringWithFormat:@"总量%@张 | 已兑换%@张",certificateDiscount.number,certificateDiscount.remain_num];
    _timeLbl.text = [NSString stringWithFormat:@"有效期%@-%@",[objDateformat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[certificateDiscount.begin_time doubleValue]]],
                     [objDateformat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[certificateDiscount.end_time doubleValue]]]];
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
