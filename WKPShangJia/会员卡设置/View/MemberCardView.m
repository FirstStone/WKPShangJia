//
//  MemberCardView.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberCardView.h"

@interface MemberCardView ()

@property(nonatomic,strong)UIImageView * brandImageView;
@property(nonatomic,strong)UILabel * titleLbl;
@property(nonatomic,strong)UILabel * contentLbl;
@property(nonatomic,strong)UILabel * timeLbl;
@property(nonatomic,strong)UIImageView * backgroundView;
@property(nonatomic,assign)float  proportion;
@end
@implementation MemberCardView

-(instancetype)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName
{
    if (self = [super initWithFrame:frame]) {
        _proportion = (float)frame.size.width / (float)(SCREEN_WIDTH - 20);
        [self setUpUI:imageName];
    }
    return self;
}

-(void)setUpUI:(NSString *)imageName
{
    _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
    _backgroundView.userInteractionEnabled = YES;
    _backgroundView.image = [UIImage imageNamed:imageName];
    UIImageView * brandView = [[UIImageView alloc]initWithFrame:CGRectMake(15 * _proportion, 15 * _proportion, 30 * _proportion, 30 * _proportion)];
    brandView.image = [UIImage imageNamed:@"kendeji"];
    
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(brandView.frame) + 10* _proportion, 20 * _proportion, 200 * _proportion, 20 * _proportion)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14* _proportion];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = @"肯德基园区1店";
    
    [_backgroundView addSubview:brandView];
    [_backgroundView addSubview:titleLbl];
    [self addSubview:_backgroundView];
    
}

- (void)setBackViewImage:(NSString *)imageName
{
    _backgroundView.image = [UIImage imageNamed:imageName];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
