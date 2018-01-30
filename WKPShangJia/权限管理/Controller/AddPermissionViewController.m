//
//  AddPermissionViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AddPermissionViewController.h"
#import "InPutViewController.h"
#import "Permission.h"
#import "MJExtension.h"
@interface AddPermissionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,InPutViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * jurisdictionArry;
@property(nonatomic,strong)UILabel *contentLbl;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)NSMutableArray * btnArry;

@end

@implementation AddPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加权限";
    [self setUpUI];
    [self getDate];
    self.view.backgroundColor = [UIColor whiteColor];
    _jurisdictionArry = [[NSMutableArray alloc]init];
    _btnArry = [[NSMutableArray alloc]init];
    if (self.privilegeManagement) {
         _dataArry = [[NSMutableArray alloc]initWithArray:@[self.privilegeManagement.title]];
    }
   else
   {
        _dataArry = [[NSMutableArray alloc]initWithArray:@[@"请填写"]];
   }
    // Do any additional setup after loading the view.
}

- (void)getDate
    {
        
        [WKPHttpRequest post:WKPGetshopmenu param:NULL finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            
            if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {

                for (NSDictionary * dic in [obj objectForKey:@"data"]) {
                    Permission * permission = [[Permission alloc]init];
                    permission = [Permission mj_objectWithKeyValues:dic];
                    [_jurisdictionArry addObject:permission];
                }
                [_tableview reloadData];
                [self setUpTabFooter];
            }
        }];
        
    }


-(void)setUpTabFooter
{
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 60, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"权限范围";
    [footerView addSubview:titleLbl];
    
    if (_jurisdictionArry.count == 0) {
        return;
    }
    NSArray *array = [self.privilegeManagement.menuid componentsSeparatedByString:@","];
    int b = (int)_jurisdictionArry.count  % 3;
    int a = (int)_jurisdictionArry.count / 3 ;
    if (b != 0 || a ==0) {
        a = (int)_jurisdictionArry.count / 3 + 1;
    }
    
    double btnXY = (SCREEN_WIDTH - 50) /3;
    for (int i = 1; i <= _jurisdictionArry.count; i++) {
        int x;
        int y;
        if (i < 3) {
            x = i;
            y = 0;
        }
        else if(i % 3 == 0) {
            y = i / 3 - 1;
            x = 3;
        }
        else{
            y = i / 3 ;
            x = i % 3;
        }
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+ i;
        Permission * permission = _jurisdictionArry[i - 1];
        [btn setTitle:permission.title forState:0];
        btn.frame = CGRectMake(10 + (x - 1) * (btnXY + 10) ,40 + y * 50 ,btnXY,40);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(choooseJurisdiction:) forControlEvents:UIControlEventTouchUpInside];
        if ([array containsObject:[NSString stringWithFormat:@"%d",i]]) {
            btn.layer.borderColor = [[UIColor redColor] CGColor ];
            btn.layer.borderWidth = 1.0f;
            [btn setTitleColor:[UIColor redColor] forState:0];
            [_btnArry addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        }
        else{
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.layer.borderColor = [WKPColor(238, 238, 238) CGColor ];
        btn.layer.borderWidth = 1.0f;
        }
        [footerView addSubview:btn];
    }
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"确定" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(addTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

    _tableview.tableFooterView = footerView;

}

-(void)setUpUI
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
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    
    _tableview.tableHeaderView = headerView;
}


- (void)addTo
{

    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * idStr = @"";
    for (int i = 0; i < (int)_btnArry.count;  i++) {
        Permission * permission = [[Permission alloc]init];
        permission = _jurisdictionArry[[_btnArry[i] intValue] -1001];
        if (i == 0) {
            idStr = [NSString stringWithFormat:@"%@",permission.id];
        }
        else{
        idStr = [NSString stringWithFormat:@"%@,%@",idStr,permission.id];
        }
    }
    
    [param setObject:idStr forKey:@"power"];
    if (![_dataArry[0] isEqualToString:@"请填写"]) {
            [param setObject:_dataArry[0] forKey:@"title"];
    }
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    
    if (self.privilegeManagement) {
        [param setObject:self.privilegeManagement.id forKey:@"jobid"];
        [WKPHttpRequest post:WKPEditshopjob param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
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
    else{
    [WKPHttpRequest post:WKPAddshopjob param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
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
}

- (void)choooseJurisdiction:(UIButton *)btn
{
    if ([_btnArry containsObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]]) {
        UIButton *myBtn = (UIButton *)[self.view viewWithTag:btn.tag];
        myBtn.layer.borderColor = [WKPColor(238, 238, 238) CGColor ];
        myBtn.layer.borderWidth = 1.0f;
        [myBtn setTitleColor:[UIColor blackColor] forState:0];
        [_btnArry removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    else{
        UIButton *myBtn = (UIButton *)[self.view viewWithTag:btn.tag];
        myBtn.layer.borderColor = [[UIColor redColor] CGColor ];
        myBtn.layer.borderWidth = 1.0f;
        [myBtn setTitleColor:[UIColor redColor] forState:0];
        [_btnArry addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 10;
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    if (indexPath.row ==1) {
        cell.backgroundColor = WKPColor(238, 238, 238);
        return cell;
    }
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 60, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"员工职介";
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 15, 8, 10)];
    _contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x - 160, 10 , 150, 20)];
    _contentLbl.textAlignment = NSTextAlignmentRight;
    _contentLbl.font = [UIFont systemFontOfSize:14 ];
    _contentLbl.textColor = [UIColor blackColor];
    _contentLbl.text = _dataArry[indexPath.row];
    iconImage.image = [UIImage imageNamed:@"you"];
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:_contentLbl];
    [cell.contentView addSubview:iconImage];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 0){
  
    InPutViewController * inPutVC  = [[InPutViewController alloc]init];
    inPutVC.contentStr = _dataArry[indexPath.row];
    inPutVC.title = @"员工职介";
    inPutVC.delegate = self;
    inPutVC.Tag = 100 + (int)indexPath.row;
    inPutVC.VCStyle = inputVCWithNomal;
    [self.navigationController pushViewController:inPutVC animated:YES];
    }
}



- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict
{
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
