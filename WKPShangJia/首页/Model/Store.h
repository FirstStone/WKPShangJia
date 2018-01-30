//
//  Store.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/23.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject
@property(nonatomic,strong)NSString * id;

@property(nonatomic,strong)NSString * title;
/**
 评级
 */
@property(nonatomic,strong)NSString * score;

@property(nonatomic,strong)NSString * logo;

//总收入
@property(nonatomic,strong)NSString * totalpay;

//总订单
@property(nonatomic,strong)NSString * totalorder;

@property(nonatomic,strong)NSString *usermobile;

@property(nonatomic,strong)NSString *mobile;

@property(nonatomic,strong)NSString *shopaddress;

@property(nonatomic,strong)NSString * average;

@property(nonatomic,strong)NSString * industryname;

@property(nonatomic,strong)NSString * indu_license;

@property(nonatomic,strong)NSString * indu_end_time;

@property(nonatomic,strong)NSString * bus_license;

@property(nonatomic,strong)NSString * bus_license_code;

@property(nonatomic,strong)NSString * bus_end_time;

@property(nonatomic,strong)NSString * provicncename;

@property(nonatomic,strong)NSString * provinceid;

@property(nonatomic,strong)NSString * countyname;

@property(nonatomic,strong)NSString * countyid;

@property(nonatomic,strong)NSString *industryid;

@property(nonatomic,strong)NSString * cityname;

@property(nonatomic,strong)NSString * cityid;

@property(nonatomic,strong)NSString * address;

@property(nonatomic,strong)NSString * banner;

@property(nonatomic,strong)NSArray * bannerImage;

@property(nonatomic,strong)NSString *service_begin_time;

@property(nonatomic,strong)NSString *service_end_time;

@property(nonatomic,strong)NSString *districtname;

@property(nonatomic,strong)NSString *bus_district_id;
@end
