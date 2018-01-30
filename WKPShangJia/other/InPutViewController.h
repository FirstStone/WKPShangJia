//
//  InPutViewController.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/21.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int, CBSSegmentHeaderType) {
    inputVCWithDataPicker,//时间选择器
    inputVCWithCityPicker,//城市选择器
    inputVCWithStatePicker,//类型选择器
    inputVCWithNomal//普通
};
@protocol InPutViewControllerDelegate <NSObject>
- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict;
@end
@interface InPutViewController : UIViewController
@property(nonatomic,strong)NSString * contentStr;
@property(nonatomic,assign)int  Tag;
@property(nonatomic,assign)int VCStyle;
@property(nonatomic,assign)int streetId;
@property(nonatomic,strong)NSString * street;
@property (nonatomic, weak) id<InPutViewControllerDelegate> delegate;
@end
