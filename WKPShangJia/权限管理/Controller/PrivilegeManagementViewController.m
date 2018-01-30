//
//  PrivilegeManagementViewController.m
//  WeiKePaiShangJia
//
//  Created by JIN CHAO on 2017/8/9.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "PrivilegeManagementViewController.h"
#import "PrivilegeManagementCell.h"
#import "PrivilegeManagement.h"
#import "MJExtension.h"
#import "AddPermissionViewController.h"
@interface PrivilegeManagementViewController ()<UITableViewDelegate,UITableViewDataSource,PrivilegeManagementDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@end

@implementation PrivilegeManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
    // Do any additional setup after loading the view.
}


- (void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(10) forKey:@"pagesize"];
    [WKPHttpRequest post:WKPGetshopjoblist param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        _dataArry = [[NSMutableArray alloc]init];
 
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                PrivilegeManagement * privilegeManagement = [PrivilegeManagement mj_objectWithKeyValues:dict];
                [_dataArry addObject:privilegeManagement];
            }
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
 //   _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headView;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"添加" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(sumMitQualification) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    PrivilegeManagementCell * cell = [[PrivilegeManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
    cell.delegate = self;
    return cell;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivilegeManagementCell *cell = [self tableView:_tableview cellForRowAtIndexPath:indexPath];
    [cell setData:_dataArry[indexPath.row]];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)editPrivilegeMangement:(int)cellTag
{
    AddPermissionViewController * addPermissionVC = [[AddPermissionViewController alloc]init];
    for (PrivilegeManagement *PM in _dataArry) {
        if ([PM.id intValue] == cellTag) {
            addPermissionVC.privilegeManagement = PM;
            break;
        }
    }
    [self.navigationController pushViewController:addPermissionVC animated:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
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
