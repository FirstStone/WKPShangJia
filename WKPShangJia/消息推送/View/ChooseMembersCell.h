//
//  ChooseMembersCell.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
@protocol ChooseMembersCellDelegate <NSObject>

- (void)chooseMembers:(int)btntag;

@end
@interface ChooseMembersCell : UITableViewCell
-(void)setData:(Member*)member;

@property(nonatomic,weak)id <ChooseMembersCellDelegate> delegate;
@end
