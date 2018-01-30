//
//  MemberCardCell.h
//  WKPShangJia
//
//  Created by Apple on 2017/11/18.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberCardMode;
@interface MemberCardCell : UICollectionViewCell
//@property (nonatomic, strong) MemberCardMode *memberCarModel;

- (void)setupUI:(MemberCardMode *)memberCarModel;

@end
