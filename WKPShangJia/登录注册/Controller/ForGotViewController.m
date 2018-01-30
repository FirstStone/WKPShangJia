//
//  ForGotViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/7/31.
//  Copyright © 2017年 zengyangyang. All rights reserved.
//

#import "ForGotViewController.h"

@interface ForGotViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel * phoneLbl;
@property(nonatomic,strong)UILabel * codeLbl;

@property(nonatomic,strong)UITextField * phoneField;
@property(nonatomic,strong)UITextField * codeField;

@property(nonatomic,strong)UILabel * passWordLbl;
@property(nonatomic,strong)UITextField * passWordField;

@property(nonatomic,strong)UILabel * passWordLbl2;
@property(nonatomic,strong)UITextField * passWordField2;
@property(nonatomic,strong)UIButton * codeBtn;
@property(nonatomic,strong)UITableView * tableview;
@end

@implementation ForGotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableview];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,40, SCREEN_WIDTH - 40, 40);
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(wkpResetpassword) forControlEvents:UIControlEventTouchUpInside];
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
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneField setFont:[UIFont systemFontOfSize:16]];
        [_phoneField setTextColor:[UIColor blackColor]];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(_phoneLbl.frame.origin.x, CGRectGetMaxY(_phoneLbl.frame) + 9, + SCREEN_WIDTH  - _phoneLbl.frame.origin.x * 2 ,1)];
        lineView.backgroundColor = WKPColor(244, 244, 244);
        [cell.contentView addSubview:lineView];
        [cell.contentView addSubview:_phoneLbl];
        [cell.contentView addSubview:_phoneField];
    }
    if(indexPath.row ==1)
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
    if (indexPath.row == 2) {
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
    if (indexPath.row == 3) {
        _passWordLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
        _passWordLbl2.text = @"密码";
        _passWordLbl2.textAlignment = NSTextAlignmentLeft;
        _passWordLbl2.font = [UIFont systemFontOfSize:16];
        _passWordLbl2.textColor = [UIColor blackColor];
        
        _passWordField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_passWordLbl.frame) + 15, _passWordLbl.frame.origin.y, SCREEN_WIDTH - CGRectGetMaxX(_phoneLbl.frame) - 35 , _passWordLbl.frame.size.height)];
        _passWordField2.placeholder = @"请输入6-18位登录密码";
        [_passWordField2 setFont:[UIFont systemFontOfSize:16]];
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
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)getCode
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneField.text forKey:@"mobile"];
    [param setObject:@(2) forKey:@"identity"];
    [param setObject:@(2) forKey:@"smstype"];
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

- (void)wkpResetpassword
{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneField.text forKey:@"mobile"];
    [param setObject:_codeField.text forKey:@"code"];
    [param setObject:_passWordField.text forKey:@"password"];
    [param setObject:@(2) forKey:@"identity"];
    [param setObject:@(1) forKey:@"source"];
    
    [WKPHttpRequest post:WKPResetpassword param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if([[obj objectForKey:@"msg"] isEqualToString:@"修改成功"]){
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
