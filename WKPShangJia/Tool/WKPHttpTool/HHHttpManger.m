

#import "HHHttpManger.h"
#import "AFHTTPSessionManager.h"


@implementation HHHttpManger

+ (instancetype)shareManger
{
    
    static HHHttpManger *manger;
    static dispatch_once_t onceToken;
    
    // 重写给 acceptableContentTypes赋值
    dispatch_once(&onceToken, ^{
        
        manger = [[self alloc]init];
        
//      manger.requestSerializer = [AFJSONRequestSerializer serializer];
        manger.responseSerializer = [AFJSONResponseSerializer serializer];
 //       [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",@"application/x-javascript",@"multipart/form-data", nil];
        
    });
    manger.requestSerializer.timeoutInterval = 15.0;
    
    return manger;
}

@end
