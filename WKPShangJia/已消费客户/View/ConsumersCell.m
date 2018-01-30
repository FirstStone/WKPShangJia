//
//  ConsumersCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "ConsumersCell.h"
#import "UIImageView+WebCache.h"
@interface ConsumersCell ()
@property(nonatomic,strong)UIImageView * portraitView;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UILabel * consumerNumLbl;
@property(nonatomic,strong)UILabel * timeLbl;



@end
@implementation ConsumersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
 
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setUpUI
{
    _portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_portraitView.frame) +10, _portraitView.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_portraitView.frame) - 10 , 20)];
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    _nameLbl.font = [UIFont systemFontOfSize:14];
    _nameLbl.textColor = [UIColor blackColor];
    
    _consumerNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(_nameLbl.frame.origin.x, CGRectGetMaxY(_nameLbl.frame) + 5, _nameLbl.frame.size.width, 15)];
    _consumerNumLbl.textAlignment = NSTextAlignmentLeft;
    _consumerNumLbl.font = [UIFont systemFontOfSize:12];
    _consumerNumLbl.textColor = WKPColor(155, 155, 155);
    
    _timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(_nameLbl.frame.origin.x, CGRectGetMaxY(_consumerNumLbl.frame) , _nameLbl.frame.size.width, 20)];
    _timeLbl.textAlignment = NSTextAlignmentLeft;
    _timeLbl.font = [UIFont systemFontOfSize:12];
    _timeLbl.textColor = WKPColor(155, 155, 155);
    
    [self.contentView addSubview:_portraitView];
    [self.contentView addSubview:_nameLbl];
    [self.contentView addSubview:_consumerNumLbl];
    [self.contentView addSubview:_timeLbl];
  
}

-(void)setData:(Consumers *)consumer;
{
    [_portraitView sd_setImageWithURL:[NSURL URLWithString:consumer.face]];
    _nameLbl.text = consumer.nickname;
    _consumerNumLbl.text = [NSString stringWithFormat:@"消费次数 : %@次",consumer.ordernum];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    _timeLbl.text = [NSString stringWithFormat:@"最近一次消费时间 : %@",[objDateformat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[consumer.ordertime doubleValue]]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
