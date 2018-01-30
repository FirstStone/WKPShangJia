//
//  OrderManagementCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPOrder.h"
@interface OrderManagementCell : UITableViewCell
@property(nonatomic,assign)CGFloat  cellHeight;
- (void)setData:(WKPOrder *)wkpOrder;
@end
