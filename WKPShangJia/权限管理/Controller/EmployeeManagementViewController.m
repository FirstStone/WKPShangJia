//
//  EmployeeManagementViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "EmployeeManagementViewController.h"
#import "EmployeeManageCell.h"
#import "Employee.h"
#import "MJExtension.h"
#import "EditEmployeeViewController.h"
#import "EmployeeInforViewController.h"
@interface EmployeeManagementViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;

@end

@implementation EmployeeManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArry = [[NSMutableArray alloc]init];
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];

    [WKPHttpRequest post:WKPListShopMember param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        _dataArry = [[NSMutableArray alloc]init];
        
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                Employee * employee = [Employee mj_objectWithKeyValues:dict];
                [_dataArry addObject:employee];
            }
            [_tableview reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }];
}

- (void)deleteMember:(int)Tag
{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Employee * employee = _dataArry[Tag];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:employee.userid forKey:@"delUserID"];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [WKPHttpRequest post:WKPDeleteShopMember param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {

        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [SVProgressHUD dismissWithDelay:1.0f];
            [self getData];
            [_tableview reloadData];
        }
        else{
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
        make.top.equalTo(self.view).offset(40);
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
    EmployeeManageCell * cell = [[EmployeeManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    cell.delegate = self;
    [cell setDataWith:_dataArry[indexPath.row]];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除"backgroundColor:WKPColor(250, 180, 65)
                                                callback:^BOOL(MGSwipeTableCell *sender) {
                                                    [self deleteMember:(int)indexPath.row];
                                                    return 0;
                                                }],
                          [MGSwipeButton buttonWithTitle:@"编辑"backgroundColor:[UIColor redColor]
                                                callback:^BOOL(MGSwipeTableCell *sender) {
                                                    EditEmployeeViewController *editEmployeeVC = [[EditEmployeeViewController alloc]init];
                                                    editEmployeeVC.employee = _dataArry[indexPath.row];
                                                    [self.navigationController pushViewController:editEmployeeVC animated:YES];
                                                    return 0;
                                                }]
                          ];
    
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeInforViewController * employeeInforVC = [[EmployeeInforViewController alloc]init];
    Employee * employee = [[Employee alloc]init];
    employee = _dataArry[indexPath.row];
    employeeInforVC.userId = employee.userid;
      employeeInforVC.jurisdiction = [NSString stringWithFormat:@"权限范围 : 商品管理,权限管理,订单管理,兑换券设置,消息推送,已消费客户"];
    [self.navigationController pushViewController:employeeInforVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
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
