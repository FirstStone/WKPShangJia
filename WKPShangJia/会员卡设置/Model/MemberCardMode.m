
//
//  MemberCardMode.m
//  WKPShangJia
//
//  Created by Apple on 2017/11/17.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberCardMode.h"

@implementation MemberCardMode

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+ (instancetype) memberCardModelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.VIP_image_id = value;
    }
}

@end
