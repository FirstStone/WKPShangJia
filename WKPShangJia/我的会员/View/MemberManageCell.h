//
//  MemberManageCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "Member.h"
@interface MemberManageCell : MGSwipeTableCell
-(void)setData:(Member*)member;
@end
