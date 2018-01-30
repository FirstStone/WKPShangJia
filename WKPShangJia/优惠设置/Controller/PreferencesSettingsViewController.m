//
//  PreferencesSettingsViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "PreferencesSettingsViewController.h"

@interface PreferencesSettingsViewController ()
@property(nonatomic,strong)UIButton *releaseButton;
@end

@implementation PreferencesSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置各个标签名字
    self.cbs_titleArray = @[@"新用户优惠", @"会员优惠设置", @"兑换券设置"];
    //设置各个标签对应的ViewController，如果数量不对会崩溃
    self.cbs_viewArray = @[@"NewUserViewController",@"MemberPreferencesViewController", @"CertificateViewController"];
    //self.cbs_Type = CBSSegmentHeaderTypeScroll;
    self.cbs_headerColor = [UIColor whiteColor];
    self.cbs_buttonHeight = 40;
    self.cbs_lineHeight = 2;
    self.cbs_lineWeight = 0.85;
    self.cbs_titleSelectedColor = WKPColor(235, 0, 0);
    self.cbs_bottomLineColor = WKPColor(235, 0, 0);
    self.cbs_Type = CBSSegmentHeaderTypeFixed;
    self.title = @"优惠设置";
    //先设置cbs_titleArray和cbs_viewArray再调用initSegment
    [self initSegment];
    _releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _releaseButton.frame = CGRectMake(20,20, 30, 30);
    _releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
     [_releaseButton setTitle:@"添加" forState:0];
    [_releaseButton addTarget:self action:@selector(addTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    // Do any additional setup after loading the view.
}

- (void)addTo
{
    
    if (self.VCtag == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"btn1" object:nil];
    }
    if (self.VCtag == 1)
    {
       [[NSNotificationCenter defaultCenter]postNotificationName:@"btn2" object:nil];
    }
    if (self.VCtag == 2){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"btn3" object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.hidden = no;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
