//
//  WKPHttpRequest.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/17.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "WKPHttpRequest.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

static BOOL isFirst = NO;
static BOOL canCHeckNetwork = NO;

@implementation WKPHttpRequest

HHHttpManger *_manger;

+ (void)initialize
{
    _manger = [HHHttpManger shareManger];
    
}

+(void) get:(NSString *)urlpath
      param:(NSDictionary *)dict
     finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb {
    
    //监察网络
    [WKPHttpRequest checkNetWorkIsAvailble];
    
    
    //2..实现解析
    
    [_manger GET:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //成功 cb是对方传递过来的对象 这里是直接调用
        NSDictionary *obj = [NSDictionary dictionaryWithDictionary:responseObject];
        cb(responseObject, obj ,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        cb(nil, nil ,error);
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode == 401) {
            
            //token 失效
            [SVProgressHUD showErrorWithStatus:@"请重新登录"];
            [SVProgressHUD dismissWithDelay:1.0f];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"网络访问失败"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }];
    
}

+(void) post:(NSString *)urlpath param:(NSDictionary *)dict finish:(void (^)(NSData *,NSDictionary *obj, NSError *))cb
{
    
    //监察网络
    [WKPHttpRequest checkNetWorkIsAvailble];

    //2..实现解析
    
    [_manger POST:[self urlAddTail:urlpath] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //成功 cb是对方传递过来的对象 这里是直接调用
         NSDictionary *obj = [NSDictionary dictionaryWithDictionary:responseObject];
         cb(responseObject, obj ,nil);
         if (![[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
             [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
             [SVProgressHUD dismissWithDelay:1.0f];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //失败
         cb(nil, nil ,error);
       
//         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
//         NSInteger responseStatusCode = [httpResponse statusCode];
  
         [SVProgressHUD showErrorWithStatus:@"网络访问失败"];
         [SVProgressHUD dismissWithDelay:1.0f];
         
     }];
    
};



+(void) payPost:(NSString *)urlpath param:(NSDictionary *)dict finish:(void (^)(NSData *,NSDictionary *obj, NSError *))cb
{
    
    //监察网络
    [WKPHttpRequest checkNetWorkIsAvailble];
    
    //2..实现解析
    
    [_manger POST:[self urlAddTail:urlpath] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         //成功 cb是对方传递过来的对象 这里是直接调用
         NSDictionary *obj = [NSDictionary dictionaryWithDictionary:responseObject];
         cb(responseObject, obj ,nil);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //失败
         cb(nil, nil ,error);
         
         //         NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
         //         NSInteger responseStatusCode = [httpResponse statusCode];
         
         [SVProgressHUD showErrorWithStatus:@"网络访问失败"];
         [SVProgressHUD dismissWithDelay:1.0f];
         
     }];
    
};





//put请求
+(void) put:(NSString *)urlpath
      param:(NSDictionary *)dict
     finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;
{
    
    //监察网络
    [WKPHttpRequest checkNetWorkIsAvailble];
    
    
    //2..实现解析
    
    //将用户信息加入header
    _manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [_manger PUT:urlpath parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"----------------%@",urlpath);
         //成功 cb是对方传递过来的对象 这里是直接调用
         NSDictionary *obj = [NSDictionary dictionaryWithDictionary:responseObject];
         cb(responseObject, obj ,nil);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //失败
         cb(nil, nil ,error);
         
         
         [SVProgressHUD showErrorWithStatus:@"网络访问失败"];
         [SVProgressHUD dismissWithDelay:1.0f];
     }];
}

//post上传
+ (void)postUpload:(NSString *)urlpath
             param:(NSDictionary *)dict uploadImageData:(NSData *)imageData finish:( void (^)(NSData *data,NSDictionary *obj, NSError *error))cb {
    
    //监察网络
    [WKPHttpRequest checkNetWorkIsAvailble];
    
    
    //2..实现解析
    
    
    [_manger POST:[self urlAddTail:urlpath] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //        [MBProgressHUD showMessage:@"上传中" toView:LQWindow];
               
//            NSDictionary *upLoad = upLoadParam[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:imageData name:@"file"  fileName:fileName mimeType:@"image/jpeg"];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [MBProgressHUD hideHUDForView:LQWindow animated:YES];
    
        
        //成功 cb是对方传递过来的对象 这里是直接调用
        NSDictionary *obj = [NSDictionary dictionaryWithDictionary:responseObject];
        cb(responseObject, obj ,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //失败
        cb(nil, nil ,error);
        [SVProgressHUD showErrorWithStatus:@"网络访问失败"];
        [SVProgressHUD dismissWithDelay:1.0f];
        
    }];
    
}

+ (void)checkNetWorkIsAvailble {
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
}

+ (NSString *)urlAddTail:(NSString *)url
{
    return [NSString stringWithFormat:@"%@%@%@",WKPhttpHeader,url,WKPhttpTail];
}
@end
