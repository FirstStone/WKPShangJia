//
//  MemberManageCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberManageCell.h"
#import "UIImageView+WebCache.h"
@interface MemberManageCell ()
@property(nonatomic,strong)UIImageView * brandImageView;
@property(nonatomic,strong)UILabel * nameLbl;



@end
@implementation MemberManageCell

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
    _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_brandImageView.frame) + 10, 30 , SCREEN_WIDTH - 160, 15)];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
