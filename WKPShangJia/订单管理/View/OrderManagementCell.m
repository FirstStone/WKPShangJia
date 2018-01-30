//
//  OrderManagementCell.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "OrderManagementCell.h"
#import <PYPhotoBrowser.h>
#import "UIImageView+WebCache.h"
@interface OrderManagementCell()
@property(nonatomic,strong)UIImageView *portraitView;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,assign)BOOL isEvaluate;
@property(nonatomic,strong)UILabel * timeLbl;
@property(nonatomic,strong)UILabel * priceLbl;
@property(nonatomic,strong)UILabel * isEvaluateLbl;
@property(nonatomic,strong)UILabel * discountLbl;
@property(nonatomic,strong)UILabel * paymentMethodLbl;
@property(nonatomic,strong)UILabel * evaluationContentLbl;
@property(nonatomic,strong)UIView  * evaluationContenImageView;
@property(nonatomic,strong)UILabel * moneyLbl;
@property(nonatomic,strong)UIButton * sendBtn;
@end
@implementation OrderManagementCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    _portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_portraitView.frame) + 10, 10, 90, 30)];
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    _nameLbl.font = [UIFont systemFontOfSize:14];
    _nameLbl.textColor = [UIColor blackColor];
    
    _isEvaluateLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 10, 90, 30)];
    _isEvaluateLbl.textAlignment = NSTextAlignmentRight;
    _isEvaluateLbl.font = [UIFont systemFontOfSize:14];
    _isEvaluateLbl.textColor = [UIColor lightGrayColor];
    _isEvaluateLbl.text = @"待评价";
    
    UIView * linView = [[UIView alloc]init];
    linView.frame =  CGRectMake( 0, CGRectGetMaxY(_portraitView.frame) + 5,SCREEN_WIDTH, 1);
    linView.backgroundColor = WKPColor(238, 238, 238);
    
    _paymentMethodLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_portraitView.frame) + 10, SCREEN_WIDTH - 20, 20)];
    _paymentMethodLbl.textAlignment = NSTextAlignmentLeft;
    _paymentMethodLbl.font = [UIFont systemFontOfSize:14];
    _paymentMethodLbl.textColor = [UIColor blackColor];
    
    _timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_paymentMethodLbl.frame),  SCREEN_WIDTH - 10, 20)];
    _timeLbl.textAlignment = NSTextAlignmentLeft;
    _timeLbl.font = [UIFont systemFontOfSize:14];
    _timeLbl.textColor = [UIColor blackColor];
    
    _priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_timeLbl.frame), SCREEN_WIDTH - 10, 20)];
    _priceLbl.textAlignment = NSTextAlignmentLeft;
    _priceLbl.font = [UIFont systemFontOfSize:14];
    _priceLbl.textColor = [UIColor blackColor];
    
    _discountLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_priceLbl.frame), SCREEN_WIDTH - 10, 20)];
    _discountLbl.textAlignment = NSTextAlignmentLeft;
    _discountLbl.font = [UIFont systemFontOfSize:14];
    _discountLbl.textColor = [UIColor blackColor];
    
    _evaluationContentLbl= [[UILabel alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(_priceLbl.frame), SCREEN_WIDTH - 90, 0)];
    _evaluationContentLbl.font = [UIFont systemFontOfSize:14];
    _evaluationContentLbl.textColor = [UIColor blackColor];
    _evaluationContentLbl.numberOfLines = 0;

    _moneyLbl= [[UILabel alloc]initWithFrame:CGRectMake( 10, CGRectGetMaxY(_priceLbl.frame) + 20,SCREEN_WIDTH - 20, 20)];
    _moneyLbl.textAlignment = NSTextAlignmentLeft;
    _moneyLbl.font = [UIFont systemFontOfSize:14.0];
    _moneyLbl.textColor = [UIColor blackColor];
    

    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(SCREEN_WIDTH - 100, CGRectGetMaxY(_moneyLbl.frame) + 20,90, 30);
    [_sendBtn setTitle:@"发送评价提醒" forState:UIControlStateNormal];

    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
 //   [_sendBtn addTarget:self action:@selector(goToHomeVC) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.backgroundColor = [UIColor redColor];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_sendBtn.layer setMasksToBounds:YES];
    [_sendBtn.layer setCornerRadius:1.0];
    
    [self.contentView addSubview:_portraitView];
    [self.contentView addSubview:_nameLbl];
    [self.contentView addSubview:linView];
    [self.contentView addSubview:_isEvaluateLbl];
    [self.contentView addSubview:_timeLbl];
    [self.contentView addSubview:_priceLbl];
    [self.contentView addSubview:_discountLbl];
    [self.contentView addSubview:_paymentMethodLbl];
}

- (void)setData:(WKPOrder *)wkpOrder
{
    
    [_portraitView sd_setImageWithURL:[NSURL URLWithString:wkpOrder.face]];
    _nameLbl.text   = wkpOrder.realname;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    _timeLbl.text   = [NSString stringWithFormat:@"买单时间:%@",[objDateformat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[wkpOrder.paytime doubleValue]]]];
    NSString *undiscount_string = [wkpOrder.undiscount intValue] > 0 ? [NSString stringWithFormat:@"(不参与优惠：%@元)",wkpOrder.undiscount] : @"";
    _priceLbl.text   = [NSString stringWithFormat:@"消费金额:%@元%@",wkpOrder.totalprice, undiscount_string];
    _discountLbl.text   = [NSString stringWithFormat:@"微客币抵扣:%d元",([wkpOrder.totalprice intValue] - [wkpOrder.payprice intValue])];
    _paymentMethodLbl.text = [NSString stringWithFormat:@"订单号：%@",wkpOrder.ordercode];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"应收金额:%@元",wkpOrder.payprice]];
//    [AttributedStr addAttribute:NSFontAttributeName
//                          value:[UIFont systemFontOfSize:14.0]
//                          range:NSMakeRange(0, wkpOrder.payprice.length + 7)];
//
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value:[UIColor redColor]
//                          range:NSMakeRange(4, wkpOrder.payprice.length + 3)];
//    //_moneyLbl.attributedText = AttributedStr;
    _moneyLbl.text = [NSString stringWithFormat:@"应收金额:%@元",wkpOrder.payprice];
    UIView * linView1 = [[UIView alloc]init];
    UIView * linView2 = [[UIView alloc]init];
    UIView * backView = [[UIView alloc]init];
//    linView1.frame =  CGRectMake( 0, _moneyLbl.frame.origin.y - 11 ,SCREEN_WIDTH, 1);
    linView1.frame =  CGRectMake( 0, CGRectGetMinY(_moneyLbl.frame) ,SCREEN_WIDTH, 1);
    linView1.backgroundColor = WKPColor(238, 238, 238);
    
    linView2.frame =  CGRectMake( 0, CGRectGetMaxY(_moneyLbl.frame) + 9,SCREEN_WIDTH, 1);
    linView2.backgroundColor = WKPColor(238, 238, 238);
    
    if ([wkpOrder.hasComment isEqualToString:@"1"]) {
        NSMutableArray * imgArry = [[NSMutableArray alloc]init];
        NSArray *array = [wkpOrder.commentImages componentsSeparatedByString:@","];
        for (int i = 0 ; i<array.count; i++) {

            [imgArry addObject:array[i]];
            
        }
    // 2. 创建一个photosView
    _evaluationContentLbl.text = wkpOrder.content;
        
    UILabel * evaluationTitleLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_moneyLbl.frame),70 , 20)];
    evaluationTitleLbl.textAlignment = NSTextAlignmentLeft;
    evaluationTitleLbl.font = [UIFont systemFontOfSize:14];
    evaluationTitleLbl.textColor = [UIColor blackColor];
    evaluationTitleLbl.text = @"评价内容 : ";
        
        PYPhotosView *photosView = [PYPhotosView photosViewWithThumbnailUrls:imgArry originalUrls:imgArry];
        photosView.photoWidth = _evaluationContentLbl.frame.size.width / 3 - 20 / 3;
        photosView.photoHeight =   photosView.photoWidth;
        photosView.frame = CGRectMake(CGRectGetMaxX(evaluationTitleLbl.frame), CGRectGetMaxY(_evaluationContentLbl.frame) > CGRectGetMaxY(evaluationTitleLbl.frame) ? CGRectGetMaxY(_evaluationContentLbl.frame) : CGRectGetMaxY(evaluationTitleLbl.frame) + 10, _evaluationContentLbl.frame.size.width, photosView.frame.size.height);
        //_moneyLbl.frame =  CGRectMake( 10, CGRectGetMaxY(photosView.frame) + 20,SCREEN_WIDTH - 20, 20);

        _isEvaluateLbl.text = @"已评价";
        [_sendBtn setTitle:@"发送感谢词" forState:UIControlStateNormal];
        _sendBtn.frame = CGRectMake(SCREEN_WIDTH - 100, CGRectGetMaxY(_moneyLbl.frame) + 20,90, 30);

       // linView1.frame =  CGRectMake( 0, CGRectGetMaxY(photosView.frame) + 9,SCREEN_WIDTH, 1);

        linView2.frame =  CGRectMake( 0, CGRectGetMaxY(photosView.frame) + 9,SCREEN_WIDTH, 1);
 
        [self.contentView addSubview:evaluationTitleLbl];
        [self.contentView addSubview:_evaluationContentLbl];
        [self.contentView addSubview:photosView];
}
    
    backView.frame =  CGRectMake( 0, CGRectGetMaxY(linView2.frame) + 10,SCREEN_WIDTH, 10);
    backView.backgroundColor = WKPColor(238, 238, 238);
    self.cellHeight = CGRectGetMaxY(backView.frame);
//    [self.contentView addSubview:linView1];
    [self.contentView addSubview:linView2];
    [self.contentView addSubview:backView];
    [self.contentView addSubview:_moneyLbl];
//    [self.contentView addSubview:_sendBtn];

  
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
