//
//  SetUpViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/2.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "SetUpViewController.h"
#import "ChangePasswordViewController.h"
#import "FeedbackViewController.h"
#import "LoginCBSSViewController.h"
#import "MyNavViewController.h"
@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)NSArray * titleArry;
@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    _titleArry = @[@"修改登录密码",@"当前版本",@"清除缓存",@"关于我们",@"意见反馈"];
    
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headView;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    btn.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    [btn setTitle:@"退出账户" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    [btn addTarget:self action:@selector(goToLogVC) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];


    [footerView addSubview:btn];
    
}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 150, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = _titleArry[indexPath.row];
    if (indexPath.row == 1) {
        UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 15, 50, 15)];
        contentLbl.textAlignment = NSTextAlignmentRight;
        contentLbl.font = [UIFont systemFontOfSize:14 ];
        contentLbl.textColor = [UIColor redColor];
        contentLbl.text = @"V1.0";
        [cell.contentView addSubview:contentLbl];
    }
    if (indexPath.row == 0 ||  indexPath.row == 2 ||  indexPath.row == 3 ||  indexPath.row == 4 ) {
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 20, 8, 10)];
        iconImage.image = [UIImage imageNamed:@"you"];
        [cell.contentView addSubview:iconImage];
    }
    
    [cell.contentView addSubview:titleLbl];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        ChangePasswordViewController * changePasswordVC = [[ChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }
    if (indexPath.row == 4) {
        FeedbackViewController * feedbackVC = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToLogVC
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"isLogin"] isEqualToString:@"0"]) {
        [defaults setObject:@"0" forKey:@"mid"];
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [defaults setObject:@"0" forKey:@"mid"];
        LoginCBSSViewController *logVC = [[LoginCBSSViewController alloc] init];
        MyNavViewController * nav = [[MyNavViewController alloc]initWithRootViewController:logVC];
        [defaults setObject:@"0" forKey:@"isLogin"];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
