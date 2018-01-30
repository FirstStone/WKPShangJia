//
//  WKPSButton.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/3.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "WKPSButton.h"

@implementation WKPSButton
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.frame.size.width / 2 - self.imageView.image.size.width / 2 - self.titleLabel.frame.size.width / 2 - 5,
                                                            self.frame.size.height / 2 - self.imageView.image.size.height / 2,
                                                            self.imageView.image.size.width,
                                                            self.imageView.image.size.height);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10,
                                                          self.frame.size.height / 2 - self.titleLabel.frame.size.height / 2 ,
                                                          self.titleLabel.frame.size.width,
                                                          self.titleLabel.frame.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
