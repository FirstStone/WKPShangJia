//
//  AddGoodsViewController.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInformation.h"
@protocol AddGoodsViewControllerDelegate <NSObject>
- (void)backToGoodsManage;
@end
@interface AddGoodsViewController : UIViewController
@property (nonatomic, weak) id<AddGoodsViewControllerDelegate> delegate;
@property (nonatomic,strong)GoodsInformation * goodsInformation;
@end
