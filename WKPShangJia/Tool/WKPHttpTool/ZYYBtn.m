//
//  ZYYBtn.m
//  GFR
//
//  Created by JIN CHAO on 2017/10/24.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "ZYYBtn.h"

@implementation ZYYBtn
- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.btnStyle) {
        case imageNomal:
        {
            
        }
            break;
        case imageLeft:
        {
            self.imageView.frame = CGRectMake(self.frame.size.width / 2 - self.imageView.image.size.width / 2 - self.titleLabel.frame.size.width / 2 - self.distance/2,
                                              self.frame.size.height / 2 - self.imageView.image.size.height / 2,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
            
            self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + self.distance,
                                               self.frame.size.height / 2 - self.titleLabel.frame.size.height / 2 ,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
        }
            break;
        case imagePullOverLeft:
        {
            self.imageView.frame = CGRectMake(0,
                                              self.frame.size.height / 2 - self.imageView.image.size.height / 2,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
            
            self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + self.distance,
                                               self.frame.size.height / 2 - self.titleLabel.frame.size.height / 2 ,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
        }
            break;
        case imageRight:
        {
            self.titleLabel.frame = CGRectMake(self.frame.size.width / 2 - self.imageView.image.size.width / 2 - self.titleLabel.frame.size.width / 2 - self.distance/2,
                                               self.frame.size.height / 2 - self.titleLabel.frame.size.height / 2 ,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
            self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + self.distance,
                                              self.frame.size.height / 2 -self.imageView.image.size.height / 2,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
            
            
        }
            break;
        case imagePullOverRight:
        {
            self.titleLabel.frame = CGRectMake(self.frame.size.width  - self.imageView.image.size.width  - self.titleLabel.frame.size.width  - self.distance,
                                               self.frame.size.height / 2 - self.titleLabel.frame.size.height / 2 ,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
            self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + self.distance,
                                              self.frame.size.height / 2 -self.imageView.image.size.height / 2,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
            
            
        }
            break;
        case imageTop:
        {
            self.imageView.frame = CGRectMake(self.frame.size.width / 2 - self.imageView.image.size.width/2,
                                              self.frame.size.height / 2 - self.imageView.image.size.height / 2 - self.titleLabel.frame.size.height / 2 - self.distance/2,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
            
            self.titleLabel.frame = CGRectMake(self.frame.size.width / 2 - self.titleLabel.frame.size.width / 2 ,
                                               CGRectGetMaxY(self.imageView.frame) + self.distance,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
        }
            break;
        case imagePullOverTop:
        {
            self.imageView.frame = CGRectMake(self.frame.size.width / 2 - self.imageView.image.size.width/2,
                                              0,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
            
            self.titleLabel.frame = CGRectMake(self.frame.size.width / 2 - self.titleLabel.frame.size.width / 2 ,
                                               CGRectGetMaxY(self.imageView.frame) + self.distance,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
        }
            break;

        case imageBottom:
        {
            self.titleLabel.frame = CGRectMake(self.frame.size.width / 2 - self.titleLabel.frame.size.width / 2 ,
                                               self.frame.size.height / 2 - self.imageView.image.size.height / 2 - self.titleLabel.frame.size.height / 2 - self.distance/2,
                                               self.titleLabel.frame.size.width,
                                               self.titleLabel.frame.size.height);
            self.imageView.frame = CGRectMake(
                                              self.frame.size.width / 2 -self.imageView.image.size.width / 2,CGRectGetMaxY(self.titleLabel.frame) + self.distance,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
        }
            break;
        case imagePullOverBottom:
        {
            self.titleLabel.frame = CGRectMake(0 ,
                                               self.frame.size.height  - self.imageView.image.size.height  - self.titleLabel.frame.size.height  - self.distance,
                                               self.frame.size.width,
                                               self.titleLabel.frame.size.height);
            self.imageView.frame = CGRectMake(
                                             0,CGRectGetMaxY(self.titleLabel.frame) + self.distance,
                                              self.imageView.image.size.width,
                                              self.imageView.image.size.height);
        }
            break;
            
        default:
            break;
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
// 省略了部分非关键代码
- (void)buttonClick:(UIButton *)button {
    self.selected = !self.selected;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
