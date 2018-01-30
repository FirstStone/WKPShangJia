//
//  GoodsManageCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInformation.h"
@protocol GoodsManageCellDelegate <NSObject>
- (void)deleteGoods:(int)cellTag;
- (void)editGoods:(int)cellTag;
@end
@interface GoodsManageCell : UITableViewCell
@property (nonatomic, weak) id<GoodsManageCellDelegate> delegate;
@property (nonatomic,assign)int cellTag;
- (void)setDataWitGoods:(GoodsInformation *)goodsInformation;
@end
