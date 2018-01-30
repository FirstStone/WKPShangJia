//
//  MemberCardView.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCardView : UIView
- (void)setBackViewImage:(NSString *)imageName;
- (instancetype)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName;
@end
