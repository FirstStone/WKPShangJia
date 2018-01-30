//
//  CashRegisterViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "CashRegisterViewController.h"
#import "CashRegisterCell.h"
#import "MJExtension.h"
#import "MoneyRecord.h"
#import <MJRefresh.h>
@interface CashRegisterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property (nonatomic, assign) NSInteger pages;
@end

@implementation CashRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pages = 1;
    [self setUpUI];
    self.title = @"支出记录";
    //[self getData];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)dataArry {
    if (!_dataArry) {
        _dataArry = [[NSMutableArray alloc]init];
    }
    return _dataArry;
}

-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:@(1) forKey:@"type"];
    [param setObject:@(12) forKey:@"style"];
    [param setObject:@(10) forKey:@"pagesize"];
    [param setObject:@(self.pages) forKey:@"page"];
    [WKPHttpRequest post:WKPGetshopmoneyrecord param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_header endRefreshing];
        if([[obj objectForKey:@"ret"] intValue]) {
            NSArray *array = [obj objectForKey:@"data"];
            if (array.count) {
                for (NSDictionary * dic in array) {
                    MoneyRecord * moneyRecord = [[MoneyRecord alloc]init];
                    moneyRecord = [MoneyRecord mj_objectWithKeyValues:dic];
                    [self.dataArry addObject:moneyRecord];
                }
                self.pages++;
            }else {
                [_tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_tableview reloadData];
    }];
}

- (void)setUpUI
{
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
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    headView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headView;
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    MJWeakSelf;
    _tableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArry removeAllObjects];
        weakSelf.pages = 1 ;
        [weakSelf getData];
    }];
    _tableview.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashRegisterCell * cell = [[CashRegisterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
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
