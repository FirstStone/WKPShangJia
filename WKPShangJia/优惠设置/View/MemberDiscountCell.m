//
//  MemberDiscountCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/9/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberDiscountCell.h"

@interface MemberDiscountCell()
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * contentLbl;
@property(nonatomic,strong)UILabel * numLbl;
@property(nonatomic,strong)UILabel * weekLimitLbl;
@property(nonatomic,strong)UILabel * timeLimitLbl;
@property(nonatomic,strong)UILabel * someLbl;
@property(nonatomic,strong)UILabel * sharedLbl;
@end
@implementation MemberDiscountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{

    _titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 80 , 20)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:16];
    _titleLbl.textColor = [UIColor blackColor];
    _titleLbl.text = @"会员优惠使用条件";
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLbl.frame) + 9, SCREEN_WIDTH - 40 , 1)];
    lineView.backgroundColor = WKPColor(238, 238, 238);
    
    UIButton * deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletedBtn.frame = CGRectMake(SCREEN_WIDTH - 40, _titleLbl.frame.origin.y, 20, 20);
    [deletedBtn setImage:[UIImage imageNamed:@"cha2"] forState:0];
    [deletedBtn addTarget:self action:@selector(deleteDiscount:) forControlEvents:UIControlEventTouchUpInside];
    //NSLog(@"%d",[self.cellTag intValue]);
    deletedBtn.tag =   [self.cellTag intValue] + 1000;

    _contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLbl.frame) + 20, SCREEN_WIDTH - 40 , 20)];
    _contentLbl.textAlignment = NSTextAlignmentLeft;
    _contentLbl.font = [UIFont systemFontOfSize:14];
    _contentLbl.textColor = WKPColor(182, 182, 182);
    
    _numLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
    _numLbl.textAlignment = NSTextAlignmentLeft;
    _numLbl.font = [UIFont systemFontOfSize:14];
    _numLbl.textColor = WKPColor(182, 182, 182);
    
    _weekLimitLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_numLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
    _weekLimitLbl.textAlignment = NSTextAlignmentLeft;
    _weekLimitLbl.font = [UIFont systemFontOfSize:14];
    _weekLimitLbl.textColor = WKPColor(182, 182, 182);
    
    _timeLimitLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_weekLimitLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
    _timeLimitLbl.textAlignment = NSTextAlignmentLeft;
    _timeLimitLbl.font = [UIFont systemFontOfSize:14];
    _timeLimitLbl.textColor = WKPColor(182, 182, 182);
    
    _someLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_timeLimitLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
    _someLbl.textAlignment = NSTextAlignmentLeft;
    _someLbl.font = [UIFont systemFontOfSize:14];
    _someLbl.textColor = WKPColor(182, 182, 182);
    
    _sharedLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_someLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
    _sharedLbl.textAlignment = NSTextAlignmentLeft;
    _sharedLbl.font = [UIFont systemFontOfSize:14];
    _sharedLbl.textColor = WKPColor(182, 182, 182);

    
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:_titleLbl];
    [self.contentView addSubview:_contentLbl];
    [self.contentView addSubview:deletedBtn];
    [self.contentView addSubview:_numLbl];
    [self.contentView addSubview:_weekLimitLbl];
    [self.contentView addSubview:_timeLimitLbl];
    [self.contentView addSubview:_someLbl];
}

- (void)setData:(MemberDiscount *)memberDiscount;
{
    NSArray * arry = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
     _someLbl.text = memberDiscount.restrictions;
    int begin = [memberDiscount.begin_week intValue];
    int end = [memberDiscount.end_week intValue];
    if ([memberDiscount.style isEqualToString:@"2"]) {
        _contentLbl.text =[NSString stringWithFormat:@"消费每满%@元可抵用%@微客币",memberDiscount.totalPrice,memberDiscount.discount];
    }
    else{
    _contentLbl.text =[NSString stringWithFormat:@"消费满%@元可抵用%@微客币",memberDiscount.totalPrice,memberDiscount.discount];
    }
    _numLbl.text =[NSString stringWithFormat:@"可在店消费使用%@次",memberDiscount.useTimes];
    _weekLimitLbl.text =[NSString stringWithFormat:@"限时间%@到%@使用",arry[begin-1],arry[end-1]];
    _timeLimitLbl.text =[NSString stringWithFormat:@"限时间%@到%@使用",memberDiscount.begin_hour,memberDiscount.end_hour];
    if ([memberDiscount.shared isEqualToString:@"0"]) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_sharedLbl.frame) + 10, SCREEN_WIDTH , 10)];
        backView.backgroundColor = WKPColor(238, 238, 238);
        _sharedLbl.text = @"不与店内其他优惠同享";
        [self.contentView addSubview:backView];
        [self.contentView addSubview:_sharedLbl];
    }
    if ([memberDiscount.shared isEqualToString:@"1"])
    {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_someLbl.frame) + 10, SCREEN_WIDTH , 10)];
        backView.backgroundColor = WKPColor(238, 238, 238);
        [self.contentView addSubview:backView];
    }
    
}



- (void)deleteDiscount:(UIButton*)btn
{
//    NSLog(@"%@", _cellTag);
//    NSLog(@"%ld", btn.tag);(int)(btn.tag - 1000)
    [self.delegate deleteDiscount:[_cellTag intValue]];
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
