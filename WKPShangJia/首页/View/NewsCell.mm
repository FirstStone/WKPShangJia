//
//  NewsCell.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/3.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
@interface NewsCell ()

@property(nonatomic,strong)UIImageView * brandImageView;
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * contentLbl;
@property(nonatomic,strong)UILabel * timeLbl;

@end
@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    
    _brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 45, 45)];
    
    _titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_brandImageView.frame) + 15, _brandImageView.frame.origin.y  , SCREEN_WIDTH - 200, 20)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:14];
    _titleLbl.textColor = [UIColor blackColor];
    
    _contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_titleLbl.frame) + 5, _titleLbl.frame.size.width, 20)];
    _contentLbl.textAlignment = NSTextAlignmentLeft;
    _contentLbl.font = [UIFont systemFontOfSize:13];
    _contentLbl.textColor = WKPColor(186, 186, 186);
    
    _timeLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLbl.frame) + 20, _titleLbl.frame.origin.y - 2, 100, 20)];
    _timeLbl.textAlignment = NSTextAlignmentRight;
    _timeLbl.font = [UIFont systemFontOfSize:11];
    _timeLbl.textColor = WKPColor(186, 186, 186);
    
    [self.contentView addSubview:_brandImageView];
    [self.contentView addSubview:_titleLbl];
    [self.contentView addSubview:_contentLbl];
    [self.contentView addSubview:_timeLbl];
    
    
}

-(void)setData:(MyNews * )myNews
{
    
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString:myNews.logo]];
    _titleLbl.text = myNews.title;
    _contentLbl.text = myNews.content;
    _timeLbl.text = myNews.ymd_his;
    
    if (myNews.ymd_his != NULL && myNews.title == NULL) {
        _brandImageView.image = [UIImage imageNamed:@"tongzhi"];
        _titleLbl.text = @"通知消息";
    }
    
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
