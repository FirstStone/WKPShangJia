//
//  NewUserCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewUserDiscount.h"
@protocol NewUserCellDelegate <NSObject>
- (void)deleteDiscount:(int)cellTag;
@end
@interface NewUserCell : UITableViewCell
- (void)setData:(NewUserDiscount *)newUserDiscount;
@property (nonatomic, weak) id<NewUserCellDelegate> delegate;
@property(nonatomic,strong)NSString * cellTag;

@end
