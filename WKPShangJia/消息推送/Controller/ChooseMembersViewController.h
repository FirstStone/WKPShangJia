//
//  ChooseMembersViewController.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseMembersViewControllerDelegate <NSObject>
- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict;
@end
@interface ChooseMembersViewController : UIViewController
@property (nonatomic, weak) id<ChooseMembersViewControllerDelegate> delegate;
@property (nonatomic,strong)NSString * chooseMember;

@end
