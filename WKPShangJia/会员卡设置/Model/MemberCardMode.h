//
//  MemberCardMode.h
//  WKPShangJia
//
//  Created by Apple on 2017/11/17.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberCardMode : NSObject
//图片URL
@property (nonatomic, strong) NSString *vipCenter;
@property (nonatomic, strong) NSString *VIP_image_id;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype) memberCardModelWithDictionary:(NSDictionary *) dictionary;
@end
