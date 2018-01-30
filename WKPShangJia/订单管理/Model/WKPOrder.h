//
//  WKPOrder.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/31.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKPOrder : NSObject
@property(nonatomic,strong)NSString * id;
/**
 总价
 */
@property(nonatomic,strong)NSString * totalprice;
/**
 付款金额
 */
@property(nonatomic,strong)NSString * payprice;

@property(nonatomic,strong)NSString * commentImages;

@property(nonatomic,strong)NSString * content;

@property(nonatomic,strong)NSString * status;
/**
 支付时间
 */
@property(nonatomic,strong)NSString * paytime;

@property(nonatomic,strong)NSString * realname;

@property(nonatomic,strong)NSString * face;

@property(nonatomic,strong)NSString * hasComment;
/**
 订单号
 */
@property (nonatomic, strong) NSString *ordercode;
/**
 不参与的金额
 */
@property (nonatomic, strong) NSString *undiscount;
@end
