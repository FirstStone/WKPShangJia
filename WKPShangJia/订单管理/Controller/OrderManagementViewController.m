//
//  OrderManagementViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "OrderManagementViewController.h"
#import "OrderManagementCell.h"
#import "MJExtension.h"
#import "WKPOrder.h"
@interface OrderManagementViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@end

@implementation OrderManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    //[self setUpUI];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)dataArry {
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

- (void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:@(self.Tag) forKey:@"type"];
    [WKPHttpRequest post:WKPListShopOrderInfo param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[obj objectForKey:@"ret"] intValue]) {
            for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                WKPOrder * wkpOrder = [WKPOrder mj_objectWithKeyValues:dict];
                [self.dataArry addObject:wkpOrder];
            }
            [self setUpUI];
            [_tableview reloadData];
        }
    }];
}
- (void)setUpUI
{
    _tableview = [[UITableView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    //   _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    headView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headView;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    [self.view addSubview:_tableview];
//    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
//    }];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view);
//        }else {
         make.top.equalTo(self.view).offset(40);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderManagementCell * cell = [[OrderManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:self.dataArry[indexPath.row]];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderManagementCell * cell = [[OrderManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:self.dataArry[indexPath.row]];
    return cell.cellHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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
