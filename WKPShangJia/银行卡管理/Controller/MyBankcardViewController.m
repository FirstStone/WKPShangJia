//
//  MyBankcardViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/9/23.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MyBankcardViewController.h"
#import "MJExtension.h"
#import "MyBankCard.h"
#import "MyBankcardCell.h"
#import "AddBanckCardViewController.h"
@interface MyBankcardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray *dataArry;
@end

@implementation MyBankcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    _dataArry = [[NSMutableArray alloc]init];
    [WKPHttpRequest post:WKPGetMyCardList param:@{@"mid":[[NSUserDefaults standardUserDefaults] objectForKey:@"mid"]} finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
            for (NSDictionary *dic in [obj objectForKey:@"data"]) {
                MyBankCard * myBankCard = [[MyBankCard alloc]init];
                myBankCard = [MyBankCard mj_objectWithKeyValues:dic];
                [_dataArry addObject:myBankCard];
                
            }
            [_tableview reloadData];
        }
                                       
    }];
}
- (void)setUpUI
{
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableview.tableFooterView = [self  footerView];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headerView;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
}

- (UIView *)footerView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBanckCard)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:singleTap];
    
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 , 150, 30)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"+ 添加银行卡";
    UIImage * tagImage =  [UIImage imageNamed:@"you"];
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - tagImage.size.width, 25 - tagImage.size.height/2, tagImage.size.width, tagImage.size.height)];
    iconImage.image = tagImage;
    [backView addSubview:iconImage];
    [backView addSubview:titleLbl];
    [footerView addSubview:backView];
    
    return footerView;
}

-(void)addBanckCard
{
    AddBanckCardViewController * addBanckCardVC = [[AddBanckCardViewController alloc]init];
    [self.navigationController pushViewController:addBanckCardVC animated:YES];
}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBankcardCell * cell = [[MyBankcardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell getData:_dataArry[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 140;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
