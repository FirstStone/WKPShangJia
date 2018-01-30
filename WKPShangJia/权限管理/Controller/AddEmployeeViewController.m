//
//  AddEmployeeViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/26.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AddEmployeeViewController.h"
#import "InPutViewController.h"
#import "WKPPickerViewController.h"
#import "PrivilegeManagement.h"
#import "MJExtension.h"
@interface AddEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource,InPutViewControllerDelegate,WKPPickerViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)NSArray * titleArry;
@property(nonatomic,strong)NSMutableArray * privilegeManagementArry;
@property(nonatomic,strong)NSMutableDictionary * dict;
@end

@implementation AddEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加员工";
    [self setUpUI];
    [self getData];
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
        
        _privilegeManagementArry = [[NSMutableArray alloc]init];
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                PrivilegeManagement * privilegeManagement = [PrivilegeManagement mj_objectWithKeyValues:dict];
                [_privilegeManagementArry addObject:privilegeManagement];
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
    _dataArry = [[NSMutableArray alloc]initWithArray:@[@"请填写",@"请填写",@"请选择"]];
    _titleArry = @[@"员工姓名",@"员工电话",@"员工职介"];
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
    _tableview.tableFooterView = [self setFooterView];
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"确定" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(addEmployee) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}

-(void)addEmployee
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    if ([_dataArry[0] isEqualToString:@"请填写"]) {
            [param setObject:@"" forKey:@"name"];
    }else
    {
            [param setObject:_dataArry[0] forKey:@"name"];
    }
    if ([_dataArry[1] isEqualToString:@"请填写"]) {
        [param setObject:@"" forKey:@"mobile"];
    }else
    {
        [param setObject:_dataArry[1] forKey:@"mobile"];
    }
    
    if([[_dict allKeys] containsObject:@"id"]){
        
        [param setObject:[_dict objectForKey:@"id"] forKey:@"jobid"];
    }
    else
    {
        [_dict setObject:@"" forKey:@"id"];
        
    }

    [WKPHttpRequest post:WKPAddShopMember param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
            if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
            }
            
        }];
        
    

}


-(UIView *)setFooterView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = WKPColor(238, 238, 238);

    UILabel * lbl  = [[UILabel alloc]initWithFrame:CGRectMake(20, 20 , SCREEN_WIDTH - 20, 20)];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont systemFontOfSize:15 ];
    lbl.textColor = [UIColor redColor];
    lbl.text = @"备注 ：";
    
    UILabel * lbl1  = [[UILabel alloc]initWithFrame:CGRectMake(lbl.frame.origin.x, CGRectGetMaxY(lbl.frame) , SCREEN_WIDTH - 20, 70)];
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = [UIFont systemFontOfSize:14 ];
    lbl1.textColor = [UIColor blackColor];
    lbl1.numberOfLines = 0;
    lbl1.text = [NSString stringWithFormat:@"1.添加员工后自动生成员工登录账号 ; \n2.员工账号为默认电话号码 , 密码默认为000000 , 之后员工\n可自行修改"];
    
    
    [footerView addSubview:lbl];
    [footerView addSubview:lbl1];
    return footerView;
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 60, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = _titleArry[indexPath.row];
    
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 15, 8, 10)];
    UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x - 160, 10 , 150, 20)];
    contentLbl.textAlignment = NSTextAlignmentRight;
    contentLbl.font = [UIFont systemFontOfSize:14 ];
    contentLbl.textColor = [UIColor blackColor];
    contentLbl.text = _dataArry[indexPath.row];
    
    iconImage.image = [UIImage imageNamed:@"you"];
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:contentLbl];
    [cell.contentView addSubview:iconImage];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 0 || indexPath.row == 1 ){
        
        InPutViewController * inPutVC  = [[InPutViewController alloc]init];
        inPutVC.contentStr = _dataArry[indexPath.row];
        inPutVC.title = _titleArry[indexPath.row];
        inPutVC.delegate = self;
        inPutVC.Tag = 100 + (int)indexPath.row;
        inPutVC.VCStyle = inputVCWithNomal;
        [self.navigationController pushViewController:inPutVC animated:YES];
    }
    if (indexPath.row == 2) {
        WKPPickerViewController * WKPPickerVC  = [[WKPPickerViewController alloc]init];
        WKPPickerVC.contentStr = _dataArry[indexPath.row];
        WKPPickerVC.title = _titleArry[indexPath.row];
        WKPPickerVC.Tag =  100 + (int)indexPath.row;
        WKPPickerVC.delegate = self;
        [WKPPickerVC setUpUIWithArry:_privilegeManagementArry];
        [self.navigationController pushViewController:WKPPickerVC animated:YES];

    }

}

- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict
{
    _dict = [[NSMutableDictionary alloc]init];
    if([[dict allKeys] containsObject:@"id"]){
    [_dict setObject:[dict objectForKey:@"id"] forKey:@"id"];
    }
    else
    {
    [_dict setObject:@"" forKey:@"id"];

    }
    _dataArry[Tag] = contentStr;
    [_tableview reloadData];
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
