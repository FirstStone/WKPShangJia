//
//  MyBankcardCell.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/9/23.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MyBankcardCell.h"
#import "UIImageView+WebCache.h"
@interface MyBankcardCell ()
@property(nonatomic,strong)UIImageView * mainImageView;
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * cardNumLbl;


@end
@implementation MyBankcardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = WKPColor(238, 238, 238);
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 80 * WKPSP , 80 * WKPSP)];
    
    _titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_mainImageView.frame) + 15, _mainImageView.frame.origin.y  + 10, SCREEN_WIDTH - CGRectGetMaxX(_mainImageView.frame)  , 30 * WKPSP)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:20* WKPSP];
    _titleLbl.textColor = [UIColor blackColor];
    
    _cardNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_titleLbl.frame) + 20 , _titleLbl.frame.size.width, 30* WKPSP)];
    _cardNumLbl.textAlignment = NSTextAlignmentLeft;
    _cardNumLbl.font = [UIFont systemFontOfSize:20 * WKPSP];
    _cardNumLbl.textColor = [UIColor blackColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 120)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [backView addSubview:_mainImageView];
    [backView addSubview:_titleLbl];
    [backView addSubview:_cardNumLbl];
    [self.contentView addSubview:backView];
    
    
}


- (void)getData:(MyBankCard *)myBankCard
{
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:myBankCard.logo]];
    _titleLbl.text = myBankCard.name;
    _cardNumLbl.text = [NSString stringWithFormat:@"****  ****  ****  %@",  [myBankCard.cardNumber substringFromIndex: myBankCard.cardNumber.length- 4 ]];
  
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
