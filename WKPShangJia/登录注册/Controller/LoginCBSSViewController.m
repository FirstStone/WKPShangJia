//
//  LoginCBSSViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "LoginCBSSViewController.h"
#import "HomeViewController.h"
#import "MyNavViewController.h"
@interface LoginCBSSViewController ()

@end

@implementation LoginCBSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置各个标签名字
    self.cbs_titleArray = @[@"普通登录", @"验证码登录"];
    //设置各个标签对应的ViewController，如果数量不对会崩溃
    self.cbs_viewArray = @[@"LogViewController", @"LogViewController"];
//    self.cbs_Type = CBSSegmentHeaderTypeScroll;
    self.cbs_headerColor = [UIColor whiteColor];
    self.cbs_buttonHeight = 40;
    self.cbs_lineHeight = 2;
    self.cbs_lineWeight = 0.7;
    self.cbs_titleSelectedColor = WKPColor(235, 0, 0);
    self.cbs_bottomLineColor = WKPColor(235, 0, 0);
    self.cbs_Type = CBSSegmentHeaderTypeFixed;
    self.title = @"登录";
    //先设置cbs_titleArray和cbs_viewArray再调用initSegment
    [self initSegment];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
