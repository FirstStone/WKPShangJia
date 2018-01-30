//
//  PrivilegeManagementCBSSViewController.m
//  WeiKePaiShangJia
//
//  Created by JIN CHAO on 2017/8/9.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "PrivilegeManagementCBSSViewController.h"
#import "AddPermissionViewController.h"
#import "AddEmployeeViewController.h"
@interface PrivilegeManagementCBSSViewController ()

@end

@implementation PrivilegeManagementCBSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置各个标签名字
    self.cbs_titleArray = @[@"权限管理", @"员工管理"];
    //设置各个标签对应的ViewController，如果数量不对会崩溃
    self.cbs_viewArray = @[@"PrivilegeManagementViewController", @"EmployeeManagementViewController"];
    self.cbs_Type = CBSSegmentHeaderTypeScroll;
    self.cbs_headerColor = [UIColor whiteColor];
    self.cbs_buttonHeight = 40;
    self.cbs_lineHeight = 2;
    self.cbs_lineWeight = 0.7;
    self.cbs_titleSelectedColor = WKPColor(235, 0, 0);
    self.cbs_bottomLineColor = WKPColor(235, 0, 0);
    self.cbs_Type = CBSSegmentHeaderTypeFixed;
    self.title = @"权限管理";
    //先设置cbs_titleArray和cbs_viewArray再调用initSegment
    [self initSegment];
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"添加" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(addTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

    // Do any additional setup after loading the view.
}

- (void)addTo
{
    if (self.VCtag == 0) {
        AddPermissionViewController * addPermissionVC = [[AddPermissionViewController alloc]init];
        [self.navigationController pushViewController:addPermissionVC animated:YES];
    }
    else
    {
        AddEmployeeViewController * addEmployeeVC = [[AddEmployeeViewController alloc]init];
        [self.navigationController pushViewController:addEmployeeVC animated:YES];

    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
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
