//
//  LogViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/7/31.
//  Copyright © 2017年 zengyangyang. All rights reserved.
//

#import "LogViewController.h"
#import "ForGotViewController.h"
#import "RegisterViewController.h"
#import "MyNavViewController.h"
#import "HomeViewController.h"


@interface LogViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UILabel * phoneLbl;
@property(nonatomic,strong)UITextField * phoneField;

@property(nonatomic,strong)UILabel * passWordLbl;
@property(nonatomic,strong)UITextField * passWordField;

@property(nonatomic,strong)UILabel * codeLbl;
@property(nonatomic,strong)UITextField * codeField;

@property(nonatomic,strong)UIButton *codeBtn;
@property(nonatomic,strong)UITableView * tableview;
@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getCityList];
    [self setUpUI];

    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
//    if (@available(iOS 11.0,*)) {
//        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    }else {
//        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    }
    self.tableview = [[UITableView alloc] init];
    [self.view addSubview:_tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (is_IPhone_X) {
            make.top.equalTo(self.view).mas_offset(88);
        }else {
            make.top.equalTo(self.view);
        }
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor whiteColor];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,20, SCREEN_WIDTH - 40, 40);
    [btn setTitle:@"确认登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    [btn addTarget:self action:@selector(goToHomeVC) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0];
    [footerView addSubview:btn];
    _tableview.tableFooterView = footerView;
    
}

-(void)getCityList
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"city.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filename] == NO) {
        [WKPHttpRequest post:WKPListArea param:NULL finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            //数据存本地沙盒
            NSDictionary * dic = @{@"city":[obj objectForKey:@"data"]};
            [fm createFileAtPath:filename contents:nil attributes:nil];
            [dic writeToFile:filename atomically:YES];
            }
        }];
        
    }
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        _phoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
        _phoneLbl.text = @"手机号";
        _phoneLbl.textAlignment = NSTextAlignmentLeft;
        _phoneLbl.font = [UIFont systemFontOfSize:16];
        _phoneLbl.textColor = [UIColor blackColor];
        
        _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneLbl.frame) + 15, _phoneLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_phoneLbl.frame) - 35 , _phoneLbl.frame.size.height)];
        _phoneField.placeholder = @"请输入手机号";
        [_phoneField setFont:[UIFont systemFontOfSize:16]];
        [_phoneField setTextColor:[UIColor blackColor]];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_phoneLbl.frame.origin.x, CGRectGetMaxY(_phoneLbl.frame) + 9, + SCREEN_WIDTH  - _phoneLbl.frame.origin.x * 2 ,1)];
        lineView.backgroundColor = WKPColor(244, 244, 244);
        [cell.contentView addSubview:lineView];
        [cell.contentView addSubview:_phoneLbl];
        [cell.contentView addSubview:_phoneField];
    }
    if (indexPath.row == 1) {
        if (_tag == 0) {
            _passWordLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
            _passWordLbl.text = @"密码";
            _passWordLbl.textAlignment = NSTextAlignmentLeft;
            _passWordLbl.font = [UIFont systemFontOfSize:16];
            _passWordLbl.textColor = [UIColor blackColor];
            
            _passWordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_passWordLbl.frame) + 15, _passWordLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_phoneLbl.frame) - 35 , _passWordLbl.frame.size.height)];
            _passWordField.placeholder = @"请输入6-18位登录密码";
            [_passWordField setFont:[UIFont systemFontOfSize:16]];
            [_passWordField setTextColor:[UIColor blackColor]];
            _passWordField.secureTextEntry = YES;
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_passWordLbl.frame.origin.x, CGRectGetMaxY(_passWordLbl.frame) + 9, + SCREEN_WIDTH  - _phoneLbl.frame.origin.x * 2 ,1)];
            lineView.backgroundColor = WKPColor(244, 244, 244);
            [cell.contentView addSubview:_passWordLbl];
            [cell.contentView addSubview:_passWordField];
            [cell.contentView addSubview:lineView];

        }
        else
        {
            _codeLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
            _codeLbl.text = @"验证码";
            _codeLbl.textAlignment = NSTextAlignmentLeft;
            _codeLbl.font = [UIFont systemFontOfSize:16];
            _codeLbl.textColor = [UIColor blackColor];
            
            _codeField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_codeLbl.frame) + 15, _codeLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_codeLbl.frame) - 115 , _codeLbl.frame.size.height)];
            _codeField.placeholder = @"请输入验证码";
            [_codeField setFont:[UIFont systemFontOfSize:16]];
            [_codeField setTextColor:[UIColor blackColor]];
              _codeField.keyboardType = UIKeyboardTypeNumberPad;
            _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _codeBtn.frame = CGRectMake(CGRectGetMaxX(_codeField.frame), 10, 80, 30);
            [_codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:1];
            [_codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
            _codeBtn.backgroundColor = [UIColor redColor];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:0];
            [_codeBtn.layer setMasksToBounds:YES];
            [_codeBtn.layer setCornerRadius:5.0];
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_codeLbl.frame.origin.x, CGRectGetMaxY(_codeLbl.frame) + 9, + SCREEN_WIDTH  - _phoneLbl.frame.origin.x * 2 ,1)];
            lineView.backgroundColor = WKPColor(244, 244, 244);
            [cell.contentView addSubview:_codeLbl];
            [cell.contentView addSubview:_codeField];
            [cell.contentView addSubview:_codeBtn];
            [cell.contentView addSubview:lineView];
        }
            }
    if (indexPath.row == 2) {
        UIButton * forGotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forGotBtn.frame = CGRectMake(20, 0, 70, 40);
        [forGotBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        forGotBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [forGotBtn addTarget:self action:@selector(goToForGotVC) forControlEvents:UIControlEventTouchUpInside];
        forGotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [forGotBtn setTitleColor:WKPColor(80, 140, 205) forState:0];
        
        UIButton * registerbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerbBtn.frame = CGRectMake(SCREEN_WIDTH - _phoneLbl.frame.origin.x - 70, forGotBtn.frame.origin.y,  70, 40);
        [registerbBtn setTitle:@"账号注册" forState:UIControlStateNormal];
        [registerbBtn addTarget:self action:@selector(goToRegisterVC) forControlEvents:UIControlEventTouchUpInside];
        registerbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        registerbBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [registerbBtn setTitleColor:WKPColor(80, 140, 205) forState:0];
        
        [cell.contentView addSubview:forGotBtn];
        [cell.contentView addSubview:registerbBtn];
        
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



- (void)goToForGotVC
{
    ForGotViewController * forGotVC = [[ForGotViewController alloc]init];
    [self.navigationController pushViewController:forGotVC animated:YES];
    
}

- (void)goToRegisterVC
{
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)getCode
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneField.text forKey:@"mobile"];
    [param setObject:@(2) forKey:@"identity"];
    [param setObject:@(3) forKey:@"smstype"];
    [param setObject:@(1) forKey:@"source"];
    
    
    [WKPHttpRequest post:WKPCode param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if([[obj objectForKey:@"msg"] isEqualToString:@"发送成功"]){
             [self openCountdown];
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
    }];
}

-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [_codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
                [_codeBtn setBackgroundColor:[UIColor whiteColor]];
                _codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_codeBtn setTitle:[NSString stringWithFormat:@"%.2d", seconds] forState:UIControlStateNormal];
                [_codeBtn setBackgroundColor:[UIColor grayColor]];
                _codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
}


- (void)goToHomeVC
{
    if (self.tag == 1) {
        
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        [param setObject:_phoneField.text forKey:@"mobile"];
        [param setObject:_codeField.text forKey:@"code"];
        [param setObject:@(2) forKey:@"identity"];
        [param setObject:@(1) forKey:@"source"];
        [WKPHttpRequest post:WKPLoginSmsCode param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            
            if([[obj objectForKey:@"msg"] isEqualToString:@"登陆成功"]){
                
                [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[obj objectForKey:@"shopStatus"] forKey:@"shopStatus"];
                [defaults setObject:[obj objectForKey:@"mid"] forKey:@"mid"];
                
                HomeViewController * homeVC = [[HomeViewController alloc]init];
                
                MyNavViewController * homeNav = [[MyNavViewController alloc]initWithRootViewController:homeVC];
                
                if ([[obj objectForKey:@"isLogin"] isEqualToString:@"2"]) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else{
                    [self presentViewController:homeNav animated:YES completion:nil];
                    [SVProgressHUD dismiss];
                }
            }
            else{
                
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
                
            }
        }];

    }
    else
    {
        if ([_phoneField.text isEqualToString:@""] || [_passWordField.text isEqualToString:@""] || _phoneField.text == nil || _passWordField.text == nil) {
            [SVProgressHUD showErrorWithStatus:@"请填写账号密码"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneField.text forKey:@"mobile"];
    [param setObject:_passWordField.text forKey:@"password"];
    [param setObject:@(2) forKey:@"identity"];
        
    [WKPHttpRequest post:WKPLogin param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
       
        if([[obj objectForKey:@"msg"] isEqualToString:@"登陆成功"]){
            
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[obj objectForKey:@"shopStatus"] forKey:@"shopStatus"];
            [defaults setObject:[obj objectForKey:@"mid"] forKey:@"mid"];
            [defaults setObject:[obj objectForKey:@"shopid"] forKey:@"shopid"];
            
            HomeViewController * homeVC = [[HomeViewController alloc]init];
      
            MyNavViewController * homeNav = [[MyNavViewController alloc]initWithRootViewController:homeVC];
            
         if ([[obj objectForKey:@"isLogin"] isEqualToString:@"2"]) {
             
                [self dismissViewControllerAnimated:YES completion:nil];
            }
         else{
            [self presentViewController:homeNav animated:YES completion:nil];
            [SVProgressHUD dismiss];
         }
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
            
        }
    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    self.navigationController.navigationBar.hidden = YES;
}
//+ (BOOL) is_IPhone_X{
//
//    float height = [[UIScreen mainScreen] bounds].size.height;
//    if (height == 812) {
//        return YES;
//    }
//    return NO;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
