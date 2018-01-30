//
//  ConsumersViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "ConsumersViewController.h"
#import "ConsumersCell.h"
#import "MJExtension.h"
#import <MJRefresh.h>

@interface ConsumersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property (nonatomic, assign) NSInteger pages;

@end

@implementation ConsumersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pages = 1;
    self.title = @"已消费客户";
    [self setUpUI];
    //[self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(self.pages) forKey:@"page"];
    [param setObject:@(10) forKey:@"pagesize"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [WKPHttpRequest post:WKPGetconsumeuserlist param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        if ([[obj objectForKey:@"ret"] intValue]) {
            NSArray *dataSoure = [obj objectForKey:@"data"];
            if (dataSoure.count) {
                for (NSDictionary * dic in dataSoure) {
                    Consumers * consumers = [[Consumers alloc]init];
                    [consumers mj_setKeyValues:dic];
                    [self.dataArry addObject:consumers];
                    
                }
                self.pages++;
            }else {
                [_tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_tableview reloadData];
    }];

    
}

- (NSMutableArray *)dataArry {
    if (!_dataArry) {
        _dataArry = [[NSMutableArray alloc]init];
    }
    return _dataArry;
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
    ConsumersCell * cell = [[ConsumersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    sectionView.backgroundColor = WKPColor(238, 238, 238);
//    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 20)];
//    titleLbl.textAlignment = NSTextAlignmentLeft;
//    titleLbl.font = [UIFont systemFontOfSize:14];
//    titleLbl.textColor = [UIColor blackColor];
//    titleLbl.text = @"A";
//    [sectionView addSubview:titleLbl];
//    return sectionView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    [_tableview.mj_header beginRefreshing];
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
