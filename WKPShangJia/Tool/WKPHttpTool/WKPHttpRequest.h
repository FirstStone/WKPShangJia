//
//  WKPHttpRequest.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/17.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHHttpManger.h"
@interface WKPHttpRequest : NSObject

/**
 post请求
 
 @param urlpath 网址
 @param dict 传入参数
 @param cb cb回调
 */
+(void) post:(NSString *)urlpath
       param:(NSDictionary *)dict
      finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;


/**
 payPost支付请求
 
 @param urlpath 网址
 @param dict 传入参数
 @param cb cb回调
 */
+(void) payPost:(NSString *)urlpath
       param:(NSDictionary *)dict
      finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;


/**
 get 请求
 
 @param urlpath 网址
 @param dict 传入参数
 @param cb cb回调
 */
+(void) get:(NSString *)urlpath
      param:(NSDictionary *)dict
     finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;


/**
 put 请求
 
 @param urlpath urlPath
 @param dict dict
 @param cb cb回调
 */
+(void) put:(NSString *)urlpath
      param:(NSDictionary *)dict
     finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;


/**
 post上传
 
 @param urlpath 上传url
 @param dict 参数
 @param imageData 图片参数
 @param cb cb回调
 */
+ (void)postUpload:(NSString *)urlpath
             param:(NSDictionary *)dict uploadImageData:(NSData *)imageData finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;
@end

