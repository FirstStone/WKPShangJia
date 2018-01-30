//
//  NewsViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/3.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "MyNews.h"
#import "MJExtension.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self getData];
    self.title = @"我的消息";
    // Do any additional setup after loading the view.
}


- (void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"shopid"]  forKey:@"shopid"];
    [param setObject:[defaults objectForKey:@"mid"]  forKey:@"mid"];
    [WKPHttpRequest post:WKPGetshopmessage param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
            _dataArry = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in [obj objectForKey:@"data"]) {
                MyNews * myNews = [[MyNews alloc]init];
                myNews = [MyNews mj_objectWithKeyValues:dic];
                [_dataArry addObject:myNews];
            }
            [_tableview reloadData];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }];
    
}
- (void)setUpUI
{
    
    
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell * cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
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
