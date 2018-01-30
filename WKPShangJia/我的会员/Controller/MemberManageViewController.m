//
//  MemberManageViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberManageViewController.h"
#import "MemberManageCell.h"
#import "MJExtension.h"
@interface MemberManageViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;

@end

@implementation MemberManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的会员";
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}


-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [WKPHttpRequest post:WKPListShopAllVIPInfo param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
            _dataArry = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in [obj objectForKey:@"data"]) {
                Member * member = [[Member alloc]init];
                [member mj_setKeyValues:dic];
                [_dataArry addObject:member];
                
            }
            [_tableview reloadData];

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
    MemberManageCell * cell = [[MemberManageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"123"];
    cell.delegate = self;
    [cell setData:_dataArry[indexPath.row]];
 
   
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//
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
