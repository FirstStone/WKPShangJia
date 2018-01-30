//
//  ChooseMembersCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "ChooseMembersCell.h"
#import "UIImageView+WebCache.h"
@interface ChooseMembersCell ()
@property(nonatomic,strong)UIImageView * brandImageView;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UILabel * timeLbl;


@end
@implementation ChooseMembersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
   
    }
    return self;
}

- (void)setUpUI
{
 
    _brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 + 10 , 30 - 20, 40, 40)];
    
    _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_brandImageView.frame) + 10, 30 - 10 , SCREEN_WIDTH - 160, 20)];
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    _nameLbl.font = [UIFont systemFontOfSize:14];
    _nameLbl.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:_brandImageView];
    [self.contentView addSubview:_nameLbl];
    
}

-(void)setData:(Member*)member
{
    
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString:member.face]];
    _nameLbl.text = member.realname;
    
}
//- (void)chooseMembers:(UIButton *)btn
//{
//    [self.delegate chooseMembers:(int)btn.tag - 1000];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
