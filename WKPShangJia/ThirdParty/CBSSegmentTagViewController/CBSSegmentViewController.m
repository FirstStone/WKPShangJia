//
//  CBSSegmentViewController.m
//  cbsSegmentView
//
//  Created by 陈秉慎 on 5/5/16.
//  Copyright © 2016 cbs. All rights reserved.
//  GitHub:https://github.com/cbsfly/CBSSegmentView
//  please STAR it if you think it is helpful!
//  blog:http://cbsfly.github.io/ios/segmentview
//

#import "CBSSegmentViewController.h"
#import "LogViewController.h"
#import "PrivilegeManagementViewController.h"
#import "EmployeeManagementViewController.h"
#import "OrderManagementViewController.h"
#import "MessagePushViewController.h"
#import "SMSEditorViewController.h"
#import "NewUserViewController.h"
#import "MemberPreferencesViewController.h"
#import "CertificateViewController.h" 
@interface CBSSegmentViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *segmentBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UIScrollView *headerView;
@property (nonatomic, strong) UIScrollView *headerSelectedView;
@property (nonatomic, strong) UIView *headerSelectedSuperView;
@property (nonatomic, strong) NSMutableArray *isFinishedArray;
@property (nonatomic, strong) UIView *view2;

@end

@implementation CBSSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCtag = 0;
    // Do any additional setup after loading the view.

}

- (void)initSegment
{
    switch (self.cbs_Type) {
        case 1: {
            self.cbs_buttonWidth = self.width/self.cbs_titleArray.count;
            [self addBackViewWithCount:self.cbs_titleArray.count];
            [self addFixedHeader:self.cbs_titleArray];
            for (NSInteger i = 0; i < self.cbs_viewArray.count; i++) {
                [self.isFinishedArray addObject:@0];
            }
            [self initViewController:0];
            break;
        }
        case 0: {
            [self addBackViewWithCount:self.cbs_titleArray.count];
            [self addScrollHeader:self.cbs_titleArray];
            for (NSInteger i = 0; i < self.cbs_viewArray.count; i++) {
                [self.isFinishedArray addObject:@0];
            }
            [self initViewController:0];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - private
- (void)initViewController:(NSInteger)index
{
    if ([self.isFinishedArray[index] integerValue] == 0) {
        Class className = NSClassFromString(self.cbs_viewArray[index]);

        if ([self.cbs_viewArray[index] isEqualToString:@"LogViewController"]) {
            LogViewController * viewController = [[className alloc] init];
            if (is_IPhone_X) {
                [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - 88)];
            }else {
                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
            }
//            if ([CBSSegmentViewController is_IPhone_X]) {
//                [viewController.view setFrame:CGRectMake(self.width *index, 0, self.width, self.height - self.cbs_buttonHeight)];
//            }
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 46, self.width, self.height - self.cbs_buttonHeight - 46)];
//            }
            viewController.tag = (int)index;
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"PrivilegeManagementViewController"]) {
            PrivilegeManagementViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight - 24)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            viewController.tag = (int)index;
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"EmployeeManagementViewController"]) {
            EmployeeManagementViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight - 24)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"OrderManagementViewController"]) {
            OrderManagementViewController * viewController = [[className alloc] init];
            viewController.Tag = (int)index;
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight- 24)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            NSLog(@"%f, %f",viewController.view.frame.size.height, viewController.view.frame.size.width);
            NSLog(@"%f, %f",self.backView.frame.size.height, self.backView.frame.size.width);
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"MessagePushViewController"]) {
            MessagePushViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"SMSEditorViewController"]) {
            SMSEditorViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, self.height - self.cbs_buttonHeight)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"NewUserViewController"]) {
            NewUserViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight - 24)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"MemberPreferencesViewController"]) {
            MemberPreferencesViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight - 24)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }else if ([self.cbs_viewArray[index] isEqualToString:@"CertificateViewController"]) {
            CertificateViewController * viewController = [[className alloc] init];
            [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, SCREEN_HEIGHT - self.cbs_buttonHeight - 24)];
//            if (@available(iOS 11.0, *)){
//                [viewController.view setFrame:CGRectMake(self.width*index, 40, self.width, self.height - self.cbs_buttonHeight - 40)];
//            }
            [self addChildViewController:viewController];
            [self.backView addSubview:viewController.view];
            self.isFinishedArray[index] = @1;
        }
    }
}

- (void)addBackViewWithCount:(NSInteger)count
{
    self.backView = [[UIScrollView alloc] init];
    if (is_IPhone_X) {
        self.backView.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT);
        self.backView.contentSize = CGSizeMake(self.width*count, self.height - 88);
    }else {
     self.backView.frame = CGRectMake(0, 0, self.width, self.height - self.cbs_buttonHeight-24);
        self.backView.contentSize = CGSizeMake(self.width*count, self.height - 64);
    }
    [self.view addSubview:self.backView];
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {- self.cbs_buttonHeight
//        //if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view).mas_offset(40);
//        //}else {
//         //make.top.equalTo(self.view).mas_offset(20);
////        }
//        make.width.equalTo(self.view);
//        make.height.equalTo(self.view);
//    }];
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(40);
//        make.width.equalTo(self.view);
//        make.height.equalTo(self.view);
//    }];
    [self.backView setPagingEnabled:YES];
    [self.backView setShowsVerticalScrollIndicator:NO];
    [self.backView setShowsHorizontalScrollIndicator:NO];
    self.backView.directionalLockEnabled = YES;
    self.backView.backgroundColor = self.cbs_backgroundColor;
    
    self.backView.bounces = YES;
    self.backView.delegate = self;
}

- (void)addScrollHeader:(NSArray *)titleArray
{
    self.headerView.frame = CGRectMake(0, 64, self.width, self.cbs_buttonHeight);
    self.headerView.contentSize = CGSizeMake(self.cbs_buttonWidth*titleArray.count, self.cbs_buttonHeight);
    [self.view addSubview:self.headerView];
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cbs_buttonWidth*index, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];
        _titleLabel.textColor = self.cbs_titleColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.headerView addSubview:_titleLabel];
        
        _segmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cbs_buttonWidth*index, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];
        _segmentBtn.tag = index;
        [_segmentBtn setBackgroundColor:[UIColor clearColor]];
        [_segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_segmentBtn];
    }
    
    
    self.headerSelectedSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  self.cbs_buttonHeight - self.cbs_lineHeight, self.cbs_buttonWidth*titleArray.count, self.cbs_lineHeight)];
    bottomView.backgroundColor = WKPColor(238, 238, 238);
    [self.headerView addSubview:bottomView];
    
    [self.headerView addSubview:self.headerSelectedSuperView];
    
    self.headerSelectedView.frame =CGRectMake(0, 64, self.cbs_buttonWidth, self.cbs_buttonHeight);
    self.headerSelectedView.contentSize = CGSizeMake(self.cbs_buttonWidth*titleArray.count, self.cbs_buttonHeight);
 
    [self.headerSelectedSuperView addSubview:self.headerSelectedView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cbs_buttonWidth*index, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];
        _titleLabel.textColor = self.cbs_titleSelectedColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
 
        [self.headerSelectedView addSubview:_titleLabel];
        
    }
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerSelectedView.contentSize.height - self.cbs_lineHeight, self.headerSelectedView.contentSize.width, self.cbs_lineHeight)];
    bottomLine.backgroundColor = self.cbs_bottomLineColor;

    [self.headerSelectedView addSubview:bottomLine];
}

- (void)addFixedHeader:(NSArray *)titleArray
{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_offset(self.cbs_buttonHeight);
        if (is_IPhone_X) {
            make.top.equalTo(self.view);
        }else {
            make.top.equalTo(self.view);
        }
    }];
//    if ([CBSSegmentViewController is_IPhone_X]) {
//        self.headerView.frame = CGRectMake(0, 90, self.width, self.cbs_buttonHeight);
//    }else {
//        self.headerView.frame = CGRectMake(0, 64, self.width, self.cbs_buttonHeight);
//    }
//    if (@available(iOS 11.0,*)) {
//        self.headerView.frame = CGRectMake(0, 90, self.width, self.cbs_buttonHeight);
//    }else {
//        self.headerView.frame = CGRectMake(0, 64, self.width, self.cbs_buttonHeight);
//    }
    self.headerView.contentSize = CGSizeMake(self.width, self.cbs_buttonHeight);
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cbs_buttonWidth*index, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];
        _titleLabel.textColor = self.cbs_titleColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.headerView addSubview:_titleLabel];
        
        _segmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cbs_buttonWidth*index, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];
        _segmentBtn.tag = index;
        [_segmentBtn setBackgroundColor:[UIColor clearColor]];
        [_segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_segmentBtn];
    }
    
    self.headerSelectedSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cbs_buttonWidth  , self.cbs_buttonHeight)];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  self.cbs_buttonHeight - self.cbs_lineHeight, self.cbs_buttonWidth*titleArray.count, self.cbs_lineHeight)];
    bottomView.backgroundColor = WKPColor(238, 238, 238);
    [self.headerView addSubview:bottomView];
    [self.headerView addSubview:self.headerSelectedSuperView];
    
    self.headerSelectedView.frame =CGRectMake(self.cbs_buttonWidth * (1 - self.cbs_lineWeight) /2, 0, self.cbs_buttonWidth * self.cbs_lineWeight, self.cbs_buttonHeight);
    self.headerSelectedView.contentSize = CGSizeMake(self.width, self.cbs_buttonHeight);
    [self.headerSelectedSuperView addSubview:self.headerSelectedView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cbs_buttonWidth*index -  self.cbs_buttonWidth * (1 - self.cbs_lineWeight) /2, 0, self.cbs_buttonWidth, self.cbs_buttonHeight)];
        _titleLabel.textColor = self.cbs_titleSelectedColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
     _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.headerSelectedView addSubview:_titleLabel];
        
    }
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerSelectedView.contentSize.height - self.cbs_lineHeight, self.headerSelectedView.contentSize.width, self.cbs_lineHeight)];
    bottomLine.backgroundColor = self.cbs_bottomLineColor;
    [self.headerSelectedView addSubview:bottomLine];
    
}

- (void)btnClick:(UIButton *)button
{
    [self.backView scrollRectToVisible:CGRectMake(button.tag*self.width, self.cbs_buttonHeight, self.backView.frame.size.width, self.backView.frame.size.height) animated:YES];
    
    [self didSelectSegmentIndex:button.tag];
}

- (void)didSelectSegmentIndex:(NSInteger)index
{

}

- (void)correctHeader:(UIScrollView *)scrollView
{
    
    if (scrollView == _backView) {
        CGFloat location = _headerSelectedView.contentOffset.x + self.cbs_buttonWidth/2 - self.width/2;
        if (location <= 0) {
            [UIView animateWithDuration:.3 animations:^{
                _headerView.contentOffset = CGPointMake(0, _headerSelectedView.contentOffset.y);
            }];
        }else if (location >= _headerView.contentSize.width - self.width) {
            [UIView animateWithDuration:.3 animations:^{
                _headerView.contentOffset = CGPointMake(_headerView.contentSize.width - self.width, _headerSelectedView.contentOffset.y);
            }];
        }else {
            if (_headerView.contentOffset.x != location) {
                [UIView animateWithDuration:.3 animations:^{
                    _headerView.contentOffset = CGPointMake(location, _headerSelectedView.contentOffset.y);
                }];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _backView) {
        self.headerSelectedSuperView.frame = CGRectMake(scrollView.contentOffset.x * (self.cbs_buttonWidth/self.width), self.headerSelectedSuperView.frame.origin.y, self.headerSelectedSuperView.frame.size.width, self.headerSelectedSuperView.frame.size.height);
        self.headerSelectedView.contentOffset = CGPointMake(scrollView.contentOffset.x * (self.cbs_buttonWidth/self.width), 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == _backView) {
        [self correctHeader:scrollView];
        [self initViewController:(scrollView.contentOffset.x/self.width)];
        self.VCtag = (scrollView.contentOffset.x/self.width);
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    if (scrollView == _backView) {
        [self correctHeader:scrollView];
        [self initViewController:(scrollView.contentOffset.x/self.width)];
        self.VCtag = (scrollView.contentOffset.x/self.width);
    }
}


#pragma mark - getter
- (CGFloat)height
{
    return self.view.frame.size.height;
}

- (CGFloat)width
{
    return self.view.frame.size.width;
}

- (CGFloat)originX
{
    return self.view.frame.origin.x;
}

- (CGFloat)originY
{
    return self.view.frame.origin.y;
}

- (NSMutableArray *)isFinishedArray
{
    if (_isFinishedArray == nil) {
        _isFinishedArray = [[NSMutableArray alloc] init];
    }
    return _isFinishedArray;
}

- (UIScrollView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIScrollView alloc] init];
        [_headerView setShowsVerticalScrollIndicator:NO];
        [_headerView setShowsHorizontalScrollIndicator:NO];
        _headerView.delegate = self;
        _headerView.bounces = NO;
        _headerView.backgroundColor = self.cbs_headerColor;
    }
    return _headerView;
}

- (UIScrollView *)headerSelectedView
{
    if (_headerSelectedView == nil) {
        _headerSelectedView = [[UIScrollView alloc] init];
        [_headerSelectedView setShowsVerticalScrollIndicator:NO];
        [_headerSelectedView setShowsHorizontalScrollIndicator:NO];
        _headerSelectedView.userInteractionEnabled = NO;
        _headerSelectedView.delegate = self;
        _headerSelectedView.backgroundColor = self.cbs_headerColor;
        _headerSelectedView.clipsToBounds = YES;
    }
    return _headerSelectedView;
}

- (CGFloat)cbs_buttonHeight
{
    if (_cbs_buttonHeight == 0) {
        _cbs_buttonHeight = 40;
    }
    return _cbs_buttonHeight;
}

- (CGFloat)cbs_buttonWidth
{
    if (_cbs_buttonWidth == 0) {
        _cbs_buttonWidth = self.width/5;
    }
    return _cbs_buttonWidth;
}

- (CGFloat)cbs_lineHeight
{
    if (_cbs_lineHeight == 0) {
        _cbs_lineHeight = 1;
    }
    return _cbs_lineHeight;
}

- (CGFloat)cbs_lineWeight
{
    if (_cbs_lineWeight == 0) {
        _cbs_lineWeight = 1 ;
    }
    return _cbs_lineWeight;
}

- (UIColor *)cbs_backgroundColor
{
    if (_cbs_backgroundColor == nil) {
        _cbs_backgroundColor = [UIColor clearColor];
    }
    return _cbs_backgroundColor;
}

- (UIColor *)cbs_headerColor
{
    if (_cbs_headerColor == nil) {
        _cbs_headerColor = [UIColor whiteColor];
    }
    return _cbs_headerColor;
}

- (UIColor *)cbs_titleColor
{
    if (_cbs_titleColor == nil) {
        _cbs_titleColor = [UIColor blackColor];
    }
    return _cbs_titleColor;
}

- (UIColor *)cbs_titleSelectedColor
{
    if (_cbs_titleSelectedColor == nil) {
        _cbs_titleSelectedColor = [UIColor blueColor];
    }
    return _cbs_titleSelectedColor;
}

- (UIColor *)cbs_bottomLineColor
{
    if (_cbs_bottomLineColor == nil) {
        _cbs_bottomLineColor = self.cbs_titleSelectedColor;
    }
    return _cbs_bottomLineColor;
}
//+ (BOOL) is_IPhone_X{
//    
//    float height = [[UIScreen mainScreen] bounds].size.height;
//    if (height == 812) {
//        return YES;
//    }
//    return NO;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
@end
