//
//  DrawMoneyViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/11/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "DrawMoneyViewController.h"

@interface DrawMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * titleArry;
@end

@implementation DrawMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.drawStyle isEqualToString:@"0"]) {
        self.title = @"提现到微信";
    }
    if ([self.drawStyle isEqualToString:@"1"]) {
        self.title = @"提现到支付宝";
    }
    if ([self.drawStyle isEqualToString:@"2"]) {
        self.title = @"提现到银行卡";
    }
    [self setUpUI];
    // Do any additional setup after loading the view.
}
- (void)setUpUI
{
    if ([self.drawStyle isEqualToString:@"0"]) {
        _titleArry = [[NSMutableArray alloc]initWithArray:@[@"提现金额 : ",@"提现人姓名 : ",@"微信账号 : "]];
    }
    if ([self.drawStyle isEqualToString:@"1"]) {
           _titleArry = [[NSMutableArray alloc]initWithArray:@[@"提现金额 : ",@"提现人姓名 : ",@"支付宝账号 : "]];
    }
    if ([self.drawStyle isEqualToString:@"2"]) {
            _titleArry = [[NSMutableArray alloc]initWithArray:@[@"提现金额 : ",@"提现人姓名 : ",@"开户行 : ",@"开户行名称 : ",@"银行卡号 : "]];
    }
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    //解决莫名偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    UIButton * logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    if (@available(iOS 8.2, *)) {
        logBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    } else {
        // Fallback on earlier versions
    }
    [logBtn addTarget:self action:@selector(drawMoney) forControlEvents:UIControlEventTouchUpInside];
    logBtn.backgroundColor = [UIColor redColor];
    [logBtn setTitleColor:[UIColor whiteColor] forState:0];
    [logBtn.layer setMasksToBounds:YES];
    [logBtn.layer setCornerRadius:5.0];
    [footerView addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).with.offset(20);
        make.bottom.equalTo(footerView).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    _tableview.tableFooterView = footerView;
}

#pragma tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * titleLbl  = [[UILabel alloc]init];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = _titleArry[indexPath.row];
    
    UITextField* contentField = [[UITextField alloc]init];
    [contentField setFont:[UIFont systemFontOfSize:14]];
    [contentField setTextColor:[UIColor blackColor]];
    if (indexPath.row == 0) {
        contentField.keyboardType =  UIKeyboardTypeDecimalPad;
    }
    if (indexPath.row == 4) {
        contentField.keyboardType =  UIKeyboardTypeNumberPad;;
    }

    contentField.tag = 1000 + indexPath.row;
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = WKPColor(238, 238, 238);
    
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:contentField];
    [cell.contentView addSubview:lineView];

    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(10);
        make.centerY.equalTo(cell.contentView);
//        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    [contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).with.offset(-10);
        make.height.mas_equalTo(20);
         make.width.mas_equalTo(SCREEN_WIDTH - 110);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentField).with.offset(5);
        make.centerX.equalTo(contentField);
        make.height.mas_equalTo(1);
        make.width.equalTo(contentField);
    }];
    return cell;
}

- (void)drawMoney
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(1) forKey:@"type"];
    UITextField *textfield = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textfield1 = (UITextField *)[self.view viewWithTag:1001];
    UITextField *textfield2 = (UITextField *)[self.view viewWithTag:1002];
    if ([self.drawStyle isEqualToString:@"0"]) {
        if ([textfield.text isEqualToString:@""] || [textfield1.text isEqualToString:@""] || [textfield2.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请完善提现信息"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
        else
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
           [param setObject:[defaults objectForKey:@"shopid"] forKey:@"id"];
           [param setObject:textfield.text forKey:@"price"];
            [param setObject:@(2) forKey:@"way"];
            [param setObject:textfield1.text forKey:@"name"];
            [param setObject:textfield2.text forKey:@"number"];
            [WKPHttpRequest post:WKPaskForDrawMoney param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                 if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
                     [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                     [SVProgressHUD dismissWithDelay:1.0f];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }
    if ([self.drawStyle isEqualToString:@"1"]) {
        if ([textfield.text isEqualToString:@""] || [textfield1.text isEqualToString:@""] || [textfield2.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请完善提现信息"];
            [SVProgressHUD dismissWithDelay:1.0f];
             return;
        }
        else
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [param setObject:[defaults objectForKey:@"shopid"] forKey:@"id"];
            [param setObject:textfield.text forKey:@"price"];
            [param setObject:@(1) forKey:@"way"];
            [param setObject:textfield1.text forKey:@"name"];
            [param setObject:textfield2.text forKey:@"number"];
            [WKPHttpRequest post:WKPaskForDrawMoney param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                    [SVProgressHUD dismissWithDelay:1.0f];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }
    if ([self.drawStyle isEqualToString:@"2"]) {
        UITextField *textfield3 = (UITextField *)[self.view viewWithTag:1003];
        UITextField *textfield4 = (UITextField *)[self.view viewWithTag:1004];
        if ([textfield.text isEqualToString:@""] || [textfield1.text isEqualToString:@""] || [textfield2.text isEqualToString:@""]  || [textfield3.text isEqualToString:@""]
             || [textfield4.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请完善提现信息"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
        else
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [param setObject:[defaults objectForKey:@"shopid"] forKey:@"id"];
            [param setObject:textfield.text forKey:@"price"];
            [param setObject:@(3) forKey:@"way"];
            [param setObject:textfield1.text forKey:@"name"];
            [param setObject:textfield2.text forKey:@"bank"];
            [param setObject:textfield3.text forKey:@"bankName"];
            [param setObject:textfield4.text forKey:@"number"];
            [WKPHttpRequest post:WKPaskForDrawMoney param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                    [SVProgressHUD dismissWithDelay:1.0f];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }

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
