//
//  WKPPickerViewController.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/29.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WKPPickerViewControllerDelegate <NSObject>
- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict;
@end
@interface WKPPickerViewController : UIViewController
@property(nonatomic,strong)NSString * contentStr;
- (void)setUpUIWithArry:(NSArray *)dataArry;
@property(nonatomic,assign)int  Tag;
@property (nonatomic, weak) id<WKPPickerViewControllerDelegate> delegate;
@end
