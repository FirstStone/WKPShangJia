//
//  DetailedCell.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/4.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "DetailedCell.h"
@interface DetailedCell ()
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * timeLbl;
@property(nonatomic,strong)UILabel * numLbl;


@end
@implementation DetailedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
 
    }
    return self;
}

- (void)setUpUI
{
    
    
    _titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(20,15  , SCREEN_WIDTH - 145, 20)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:15];
    _titleLbl.textColor = [UIColor blackColor];
    
    _timeLbl  = [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_titleLbl.frame) + 5, _titleLbl.frame.size.width, 20)];
    _timeLbl.textAlignment = NSTextAlignmentLeft;
    _timeLbl.font = [UIFont systemFontOfSize:12];
    _timeLbl.textColor = WKPColor(186, 186, 186);
    

    _numLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLbl.frame) + 20, 25 , 80, 20)];
    _numLbl.textAlignment = NSTextAlignmentRight;
    _numLbl.font = [UIFont systemFontOfSize:15];
    _numLbl.textColor = [UIColor redColor];

    
    [self.contentView addSubview:_titleLbl];
    [self.contentView addSubview:_timeLbl];
    [self.contentView addSubview:_numLbl];
    
}

-(void)setData:(MoneyRecord *)moneyRecord
{
    
    if ([moneyRecord.style isEqualToString:@"21"]) {
        _titleLbl.text = @"用户在店消费收入(线下)";
    }
    if ([moneyRecord.style isEqualToString:@"23"]) {
        _titleLbl.text = @"会员充值返利";
    }
    if ([moneyRecord.style isEqualToString:@"22"]) {
        _titleLbl.text = @"跨店收益";
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[moneyRecord.time doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];

    _timeLbl.text = dateString;
    _numLbl.text = [NSString stringWithFormat:@"+%@",moneyRecord.money];

    
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
