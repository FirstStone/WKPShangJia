//
//  MemberDiscountCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/9/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDiscount.h"
@protocol MemberDiscountCellDelegate <NSObject>
- (void)deleteDiscount:(int)cellTag;
@end
@interface MemberDiscountCell : UITableViewCell
- (void)setData:(MemberDiscount *)memberDiscount;
@property (nonatomic, weak) id<MemberDiscountCellDelegate> delegate;
@property(nonatomic,strong)NSString * cellTag;
@end
