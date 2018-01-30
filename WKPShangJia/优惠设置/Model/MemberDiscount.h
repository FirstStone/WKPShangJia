//
//  MemberDiscount.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/9/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberDiscount : NSObject
@property(nonatomic,strong)NSString * totalPrice;

@property(nonatomic,strong)NSString * discount;

@property(nonatomic,strong)NSString * couponid;

@property(nonatomic,strong)NSString * begin_week;

@property(nonatomic,strong)NSString * useTimes;

@property(nonatomic,strong)NSString * end_week;

@property(nonatomic,strong)NSString * begin_hour;

@property(nonatomic,strong)NSString * end_hour;

@property(nonatomic,strong)NSString *style;

@property(nonatomic,strong)NSString *shared;

@property(nonatomic,strong)NSString * restrictions;
@end
