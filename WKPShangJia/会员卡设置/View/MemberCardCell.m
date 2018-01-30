//
//  MemberCardCell.m
//  WKPShangJia
//
//  Created by Apple on 2017/11/18.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberCardCell.h"
#import "MemberCardMode.h"
#import <UIImageView+WebCache.h>
@interface MemberCardCell()
//@property (nonatomic, strong) MemberCardView *memberCardView;
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation MemberCardCell
//CGRectMake(10, 40, SCREEN_WIDTH / 3 - 40 /3, 80)
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(10);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-10);
            make.top.equalTo(self.contentView).mas_offset(20);
            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-20);
        }];
//        self.memberCardView = [[MemberCardView alloc] init];
//        _memberCardView.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:_memberCardView];
//        [_memberCardView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).mas_offset(10);
//            make.right.equalTo(self.contentView.mas_right).mas_offset(-10);
//            make.top.equalTo(self.contentView).mas_offset(20);
//            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-20);
//        }];
    }
    return self;
}

- (void)setupUI:(MemberCardMode *)memberCarModel {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:memberCarModel.vipCenter]];
}

@end
