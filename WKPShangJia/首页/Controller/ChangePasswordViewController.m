//
//  ChangePasswordViewController.m
//  WeiKePaiShangJia
//
//  Created by JIN CHAO on 2017/8/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel * oldPasswordLbl;
@property(nonatomic,strong)UILabel * codeLbl;

@property(nonatomic,strong)UITextField * oldPasswordField;
@property(nonatomic,strong)UITextField * codeField;

@property(nonatomic,strong)UILabel * passWordLbl;
@property(nonatomic,strong)UITextField * passWordField;

@property(nonatomic,strong)UILabel * passWordLbl2;
@property(nonatomic,strong)UITextField * passWordField2;

@property(nonatomic,strong)UITableView * tableview;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    // Do any additional setup after loading the view.
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
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor whiteColor];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,40, SCREEN_WIDTH - 40, 40);
    [btn setTitle:@"确认修改" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0];
    [footerView addSubview:btn];
    _tableview.tableFooterView = footerView;
    
}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    if (indexPath.row == 0) {
        _oldPasswordLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
        _oldPasswordLbl.text = @"原密码";
        _oldPasswordLbl.textAlignment = NSTextAlignmentLeft;
        _oldPasswordLbl.font = [UIFont systemFontOfSize:14];
        _oldPasswordLbl.textColor = [UIColor blackColor];
        
        _oldPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_oldPasswordLbl.frame) + 15, _oldPasswordLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_oldPasswordLbl.frame) - 35 , _oldPasswordLbl.frame.size.height)];
        _oldPasswordField.placeholder = @"请输入原密码";
         _oldPasswordField.secureTextEntry = YES;
        [_oldPasswordField setFont:[UIFont systemFontOfSize:14]];
        [_oldPasswordField setTextColor:[UIColor blackColor]];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_oldPasswordLbl.frame.origin.x, CGRectGetMaxY(_oldPasswordLbl.frame) + 9, + SCREEN_WIDTH  - _oldPasswordLbl.frame.origin.x * 2 ,1)];
        lineView.backgroundColor = WKPColor(244, 244, 244);
        [cell.contentView addSubview:lineView];
        [cell.contentView addSubview:_oldPasswordLbl];
        [cell.contentView addSubview:_oldPasswordField];
    }
        if (indexPath.row == 1) {
        _passWordLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
        _passWordLbl.text = @"新密码";
        _passWordLbl.textAlignment = NSTextAlignmentLeft;
        _passWordLbl.font = [UIFont systemFontOfSize:14];
        _passWordLbl.textColor = [UIColor blackColor];
          
        _passWordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_passWordLbl.frame) + 15, _passWordLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_oldPasswordLbl.frame) - 35 , _passWordLbl.frame.size.height)];
        _passWordField.placeholder = @"请输入6-18位新登录密码";
        [_passWordField setFont:[UIFont systemFontOfSize:14]];
        [_passWordField setTextColor:[UIColor blackColor]];
        _passWordField.secureTextEntry = YES;
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_passWordLbl.frame.origin.x, CGRectGetMaxY(_passWordLbl.frame) + 9, + SCREEN_WIDTH  - _oldPasswordLbl.frame.origin.x * 2 ,1)];
        lineView.backgroundColor = WKPColor(244, 244, 244);
        [cell.contentView addSubview:_passWordLbl];
        [cell.contentView addSubview:_passWordField];
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.row == 2) {
        _passWordLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
        _passWordLbl2.text = @"确认密码";
        _passWordLbl2.textAlignment = NSTextAlignmentLeft;
        _passWordLbl2.font = [UIFont systemFontOfSize:14];
        _passWordLbl2.textColor = [UIColor blackColor];
        
        _passWordField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_passWordLbl.frame) + 15, _passWordLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_oldPasswordLbl.frame) - 35 , _passWordLbl.frame.size.height)];
        _passWordField2.placeholder = @"再次输入新登录密码";
        [_passWordField2 setFont:[UIFont systemFontOfSize:14]];
        [_passWordField2 setTextColor:[UIColor blackColor]];
        _passWordField2.secureTextEntry = YES;
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_passWordLbl2.frame.origin.x, CGRectGetMaxY(_passWordLbl2.frame) + 9, + SCREEN_WIDTH  - _passWordLbl2.frame.origin.x * 2 ,1)];
        lineView.backgroundColor = WKPColor(244, 244, 244);
        [cell.contentView addSubview:_passWordLbl2];
        [cell.contentView addSubview:_passWordField2];
        [cell.contentView addSubview:lineView];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)changePassword
{
    
    if(![_passWordField.text isEqualToString:_passWordField2.text])
    {
        [SVProgressHUD showErrorWithStatus:@"2次原密码不一致"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:_oldPasswordField.text forKey:@"oldpsw"];
    [param setObject:_passWordField.text forKey:@"newpsw"];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [WKPHttpRequest post:WKPEdituserpsw param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SVProgressHUD dismissWithDelay:1.0f];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else{
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }];

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
