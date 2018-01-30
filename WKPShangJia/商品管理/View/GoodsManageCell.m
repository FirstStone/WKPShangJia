//
//  GoodsManageCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "GoodsManageCell.h"
#import "WKPSmallButton.h"
#import "UIImageView+WebCache.h"
@interface GoodsManageCell ()
@property(nonatomic,strong)UIImageView * goodsImageView;
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * contentLbl;
@property(nonatomic,strong)UILabel * priceLbl;
@property(nonatomic,strong)UIButton * editBtn;
@property(nonatomic,strong)UIButton * deleteBtn;


@end
@implementation GoodsManageCell

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
    _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    
    _titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 5, _goodsImageView.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_goodsImageView.frame) - 30 , 20)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:14];
    _titleLbl.textColor = [UIColor blackColor];
    
    _contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_titleLbl.frame) + 5, _titleLbl.frame.size.width, 15)];
    _contentLbl.textAlignment = NSTextAlignmentLeft;
    _contentLbl.font = [UIFont systemFontOfSize:12];
    _contentLbl.textColor = WKPColor(155, 155, 155);
    
    _priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_contentLbl.frame) + 5, _titleLbl.frame.size.width, 20)];
    _priceLbl.textAlignment = NSTextAlignmentLeft;
    _priceLbl.font = [UIFont systemFontOfSize:14];
    _priceLbl.textColor = [UIColor redColor];
    
    UIImage * tagImage =  [UIImage imageNamed:@"you"];
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - tagImage.size.width, 45 - tagImage.size.height/2, tagImage.size.width, tagImage.size.height)];
    iconImage.image = tagImage;

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_goodsImageView.frame)+9, SCREEN_WIDTH -20, 1)];
    lineView.backgroundColor = WKPColor(238, 238, 238);
    
    _editBtn = [WKPSmallButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, CGRectGetMaxY(_goodsImageView.frame ) + 10, SCREEN_WIDTH / 2 , 50);
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.tag = 1000 + self.cellTag;
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_editBtn setImage: [UIImage imageNamed:@"bianji"] forState:0];
    [_editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTitleColor:WKPColor(155, 155, 155) forState:0];

    _deleteBtn = [WKPSmallButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.tag = 2000 + self.tag;
    _deleteBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _editBtn.frame.origin.y , SCREEN_WIDTH / 2 , 50);
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_deleteBtn setImage: [UIImage imageNamed:@"shachu"] forState:0];
    [_deleteBtn addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitleColor:WKPColor(155, 155, 155) forState:0];
    
 
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_editBtn.frame), SCREEN_WIDTH, 10)];
    backView.backgroundColor = WKPColor(238, 238, 238);
    
    [self.contentView addSubview:_goodsImageView];
    [self.contentView addSubview:_titleLbl];
    [self.contentView addSubview:_contentLbl];
    [self.contentView addSubview:_priceLbl];
    [self.contentView addSubview:iconImage];
     [self.contentView addSubview:lineView];
    [self.contentView addSubview:_editBtn];
    [self.contentView addSubview:_deleteBtn];
     [self.contentView addSubview:backView];
}

- (void)setDataWitGoods:(GoodsInformation *)goodsInformation
{
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsInformation.image]];;
    _titleLbl.text = goodsInformation.title;
    _contentLbl.text = goodsInformation.introduce;
    _priceLbl.text = goodsInformation.price;
    
}

- (void)deleteGoods:(WKPSmallButton*)btn
{
    [self.delegate deleteGoods:(int)(btn.tag - 2000)];
}

- (void)editGoods:(WKPSmallButton *)btn
{
    [self.delegate editGoods:(int)(btn.tag - 1000)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
