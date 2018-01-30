//
//  EmployeeManageCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//


#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "Employee.h"
@interface EmployeeManageCell : MGSwipeTableCell
- (void)setDataWith:(Employee *)employee;
@end
