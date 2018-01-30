//
//  PrivilegeManagementCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivilegeManagement.h"
@protocol PrivilegeManagementDelegate <NSObject>
- (void)editPrivilegeMangement:(int)cellTag;

@end

@interface PrivilegeManagementCell : UITableViewCell

@property(nonatomic,assign)CGFloat  cellHeight;
@property (nonatomic,assign)int cellTag;
@property (nonatomic, weak) id<PrivilegeManagementDelegate> delegate;

- (void)setData:(PrivilegeManagement *)privilegeManagement;
@end
