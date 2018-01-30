//
//  NewUserCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "NewUserCell.h"
@interface NewUserCell()
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * contentLbl;
@property(nonatomic,strong)UILabel * someLbl;
@property(nonatomic,strong)UILabel * sharedLbl;
@end
@implementation NewUserCell
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
    _titleLbl.text = @"APP新用户优惠使用条件";
    
    UIButton * deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletedBtn.frame = CGRectMake(SCREEN_WIDTH - 40, _titleLbl.frame.origin.y - 10, 30, 30);
    [deletedBtn setImage:[UIImage imageNamed:@"cha2"] forState:0];
    [deletedBtn addTarget:self action:@selector(deleteDiscount:) forControlEvents:UIControlEventTouchUpInside];
    deletedBtn.tag =   [self.cellTag intValue] + 1000;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLbl.frame) + 9, SCREEN_WIDTH - 40 , 1)];
    lineView.backgroundColor = WKPColor(238, 238, 238);

    _contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLbl.frame) + 20, SCREEN_WIDTH - 40 , 20)];
    _contentLbl.textAlignment = NSTextAlignmentLeft;
    _contentLbl.font = [UIFont systemFontOfSize:14];
    _contentLbl.textColor = WKPColor(182, 182, 182);
    
    _someLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
    _someLbl.textAlignment = NSTextAlignmentLeft;
    _someLbl.font = [UIFont systemFontOfSize:14];
    _someLbl.textColor = WKPColor(182, 182, 182);
    
    _someLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentLbl.frame) + 10, SCREEN_WIDTH - 40 , 20)];
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
     [self.contentView addSubview:_someLbl];
     [self.contentView addSubview:deletedBtn];

}

- (void)setData:(NewUserDiscount *)newUserDiscount
{
    
    _contentLbl.text =[NSString stringWithFormat:@"消费满%@元可抵用%@微客币",newUserDiscount.totalPrice,newUserDiscount.discount];
    _someLbl.text = newUserDiscount.restrictions;
    if ([newUserDiscount.shared isEqualToString:@"0"]) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_sharedLbl.frame) + 10, SCREEN_WIDTH , 10)];
        backView.backgroundColor = WKPColor(238, 238, 238);
        _sharedLbl.text = @"不与店内其他优惠同享";
         [self.contentView addSubview:backView];
         [self.contentView addSubview:_sharedLbl];
    }
       if ([newUserDiscount.shared isEqualToString:@"1"])
    {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_someLbl.frame) + 10, SCREEN_WIDTH , 10)];
        backView.backgroundColor = WKPColor(238, 238, 238);
        [self.contentView addSubview:backView];
    }
    
}



- (void)deleteDiscount:(UIButton*)btn
{
        [self.delegate deleteDiscount:(int)(btn.tag - 1000)];
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
