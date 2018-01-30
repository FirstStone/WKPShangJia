//
//  MyWalletViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WithdrawalsViewController.h"
#import "DetailedViewController.h"
#import "CashRegisterViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel *walletNubLbl;
@property(nonatomic,strong)UILabel *numLbl2;
@property(nonatomic,strong)UILabel *numLbl;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];

    
    [WKPHttpRequest post:WKPGetshopwalletinfo param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
            
            _walletNubLbl.text = [NSString stringWithFormat:@"￥%.2f",[[obj objectForKey:@"balance"] floatValue ]];
            _numLbl.text = [NSString stringWithFormat:@"%.2f",[[obj objectForKey:@"recharge"] floatValue ]];
            _numLbl2.text = [NSString stringWithFormat:@"%.2f",[[obj objectForKey:@"rebate"] floatValue ]];
            

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
    _tableview.tableHeaderView = [self setUpheadView];
  
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    
}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 120, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
           titleLbl.text = @"收入明细";
    }
   else
   {
          titleLbl.text = @"提现记录";
   }
    
    UIImage * tagImage =  [UIImage imageNamed:@"you"];
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - tagImage.size.width, 25 - tagImage.size.height/2, tagImage.size.width, tagImage.size.height)];
    iconImage.image = tagImage;
    
    [cell.contentView addSubview:iconImage];
    [cell.contentView addSubview:titleLbl];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        DetailedViewController * detailedVC = [[DetailedViewController alloc]init];
        [self.navigationController pushViewController:detailedVC animated:YES];
    }
    if (indexPath.row == 1) {
        CashRegisterViewController * cashRegisterVC = [[CashRegisterViewController alloc]init];
        [self.navigationController pushViewController:cashRegisterVC animated:YES];
    }

}



- (UIView *)setUpheadView
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView * withdrawalsView =  [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];
    withdrawalsView.backgroundColor = [UIColor whiteColor];
    UILabel * walletBalanceLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    walletBalanceLbl.textAlignment = NSTextAlignmentLeft;
    walletBalanceLbl.font = [UIFont systemFontOfSize:14 ];
    walletBalanceLbl.textColor = [UIColor blackColor];
    walletBalanceLbl.text = @"钱包余额 : ";
    
    _walletNubLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(walletBalanceLbl.frame), 15, 200, 20)];
    _walletNubLbl.textAlignment = NSTextAlignmentLeft;
    _walletNubLbl.font = [UIFont systemFontOfSize:14 ];
    _walletNubLbl.textColor = [UIColor redColor];
    _walletNubLbl.text = @"￥0";
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH - 70,12.5, 60 ,25);
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 ];
    [btn addTarget:self action:@selector(goToWithdrawalsVC) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:3.0];

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(walletBalanceLbl.frame)+15, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = WKPColor(238, 238,238 );
    
 //   UILabel * numLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+15, SCREEN_WIDTH/3, 20)];
    _numLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+15, SCREEN_WIDTH/2, 20)];
    _numLbl.textAlignment = NSTextAlignmentCenter;
    _numLbl.font = [UIFont systemFontOfSize:14 ];
    _numLbl.textColor = [UIColor blackColor];
    _numLbl.text = @"0元";
    
//    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(numLbl.frame.origin.x, CGRectGetMaxY(numLbl.frame)+10, SCREEN_WIDTH/3, 20)];
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_numLbl.frame)+10, SCREEN_WIDTH/2, 20)];
    
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"充值返利";
    
    
  //  UIView * verticalView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLbl.frame) - 0.5,CGRectGetMaxY(lineView.frame)+10, 1, 60)];
    UIView * verticalView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2,CGRectGetMaxY(lineView.frame)+10, 1, 60)];

    verticalView.backgroundColor = WKPColor(238, 238,238 );
    
 /*   UILabel * numLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, CGRectGetMaxY(lineView.frame)+15, SCREEN_WIDTH/3, 20)];
     UILabel * numLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, CGRectGetMaxY(lineView.frame)+15, SCREEN_WIDTH/3, 20)];
    numLbl1.textAlignment = NSTextAlignmentCenter;
    numLbl1.font = [UIFont systemFontOfSize:14 ];
    numLbl1.textColor = [UIColor blackColor];
    numLbl1.text = @"99元";
    
    UILabel * titleLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(numLbl1.frame.origin.x, CGRectGetMaxY(numLbl1.frame)+10, SCREEN_WIDTH/3, 20)];
    titleLbl1.textAlignment = NSTextAlignmentCenter;
    titleLbl1.font = [UIFont systemFontOfSize:14 ];
    titleLbl1.textColor = [UIColor blackColor];
    titleLbl1.text = @"推荐会员";
    
    
    UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLbl1.frame) - 0.5,CGRectGetMaxY(lineView.frame)+10, 1, 60)];
    verticalView1.backgroundColor = WKPColor(238, 238,238 );
    */
   
    //UILabel * numLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, CGRectGetMaxY(lineView.frame)+15, SCREEN_WIDTH/3, 20)];
    _numLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(lineView.frame)+15, SCREEN_WIDTH/2, 20)];
    _numLbl2.textAlignment = NSTextAlignmentCenter;
    _numLbl2.font = [UIFont systemFontOfSize:14 ];
    _numLbl2.textColor = [UIColor blackColor];
    _numLbl2.text = @"0元";
    
 //   UILabel * titleLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(numLbl2.frame.origin.x, CGRectGetMaxY(numLbl2.frame)+10, SCREEN_WIDTH/3, 20)];
    UILabel * titleLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(_numLbl2.frame.origin.x, CGRectGetMaxY(_numLbl2.frame)+10, SCREEN_WIDTH/2, 20)];
    titleLbl2.textAlignment = NSTextAlignmentCenter;
    titleLbl2.font = [UIFont systemFontOfSize:14 ];
    titleLbl2.textColor = [UIColor blackColor];
    titleLbl2.text = @"跨店收益";
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLbl2.frame)+15, SCREEN_WIDTH, 10)];
    lineView1.backgroundColor = WKPColor(238, 238,238 );
    
    [headView addSubview:walletBalanceLbl];
    [headView addSubview:_walletNubLbl];
    [headView addSubview:btn];
    [headView addSubview:lineView];
    [headView addSubview:_numLbl];
    [headView addSubview:titleLbl];
//  [headView addSubview:numLbl1];
//   [headView addSubview:titleLbl1];
    [headView addSubview:_numLbl2];
    [headView addSubview:titleLbl2];
    [headView addSubview:verticalView];
//   [headView addSubview:verticalView1];
    [headView addSubview:lineView1];
    
    return headView;
}


- (void)goToWithdrawalsVC
{
    WithdrawalsViewController * withDrawalsVC = [[WithdrawalsViewController alloc]init];
    [self.navigationController pushViewController:withDrawalsVC animated:YES];
    
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
