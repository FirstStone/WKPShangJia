//
//  PrivilegeManagementCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "PrivilegeManagementCell.h"
#import "PrivilegeManagement.h"
@interface PrivilegeManagementCell ()
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * contentLbl;
@property(nonatomic,strong)UIButton * editBtn;
@property (nonatomic, strong) NSString *cell_ID;

@end
@implementation PrivilegeManagementCell

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
    
    _titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH  - 100 , 20)];
    _titleLbl.textAlignment = NSTextAlignmentLeft;
    _titleLbl.font = [UIFont systemFontOfSize:16];
    _titleLbl.textColor = [UIColor blackColor];
    
   _contentLbl= [[UILabel alloc]initWithFrame:CGRectMake(_titleLbl.frame.origin.x, CGRectGetMaxY(_titleLbl.frame)+10, _titleLbl.frame.size.width, 0)];
    _contentLbl.font = [UIFont systemFontOfSize:12];
    _contentLbl.textColor = WKPColor(155, 155, 155);
    _contentLbl.numberOfLines = 0;
    //label3.lineBreakMode = NSLineBreakByWordWrapping;//(默认)
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.frame = CGRectMake(0,  self.cellHeight / 2 - 10, 30, 20);
    _editBtn.tag = 1000 + self.cellTag;
    [_editBtn addTarget:self action:@selector(editPrivilegeMangement:) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.contentView addSubview:_contentLbl];
    [self.contentView addSubview:_editBtn];
    [self.contentView addSubview:_titleLbl];
}

- (void)setData:(PrivilegeManagement *)privilegeManagement
{
    _cell_ID = privilegeManagement.id;
    _titleLbl.text = privilegeManagement.title;
    _contentLbl.text = privilegeManagement.menutitle;
    CGSize size = [_contentLbl sizeThatFits:CGSizeMake(_contentLbl.frame.size.width, MAXFLOAT)];
    _contentLbl.frame = CGRectMake(_contentLbl.frame.origin.x, _contentLbl.frame.origin.y, _contentLbl.frame.size.width,  size.height);
 
    self.cellHeight = CGRectGetMaxY(_contentLbl.frame)+ 20;

    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLbl.frame) + 8, 25, 2, self.cellHeight - 50)];
    lineView.backgroundColor = WKPColor(238, 238, 238);

    _editBtn.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 20,  self.cellHeight / 2 - 10, 30, 20);

    [self.contentView addSubview:lineView];
   
}

- (void)editPrivilegeMangement:(UIButton *)btn
{
    
    [self.delegate editPrivilegeMangement:[_cell_ID intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
