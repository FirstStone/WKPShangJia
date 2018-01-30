//
//  ZYYBtn.h
//  GFR
//
//  Created by JIN CHAO on 2017/10/24.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int, CBSSegmentHeaderTypeScroll) {
    /// 正常
    imageNomal,
    ///图片在左
    imageLeft,
    ///图片在右
    imageRight,
    ///图片在上
    imageTop,
    ///图片在下
    imageBottom,
    ///图片靠左
    imagePullOverLeft,
    ///图片靠右
    imagePullOverRight,
    ///图片靠上
    imagePullOverTop,
    ///图片靠下
    imagePullOverBottom
};
@interface ZYYBtn : UIButton
///图片和文字间的距离
@property(nonatomic,assign)float distance;
///按钮样式
@property(nonatomic,assign)int btnStyle;
@end
