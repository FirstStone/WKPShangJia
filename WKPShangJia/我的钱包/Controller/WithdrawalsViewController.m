//
//  WithdrawalsViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/3.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "DrawMoneyViewController.h"
@interface WithdrawalsViewController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSArray * iconArry;
@property(nonatomic,strong)NSArray * titleArry;
@property(nonatomic,assign)int  lastBtnTag;
@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"提现";
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    _titleArry = @[@"支付宝",@"银行卡",@"微信"];
    _iconArry = @[@"tixiandaozhifubao",@"tixiandaoyinhangka",@"tixiandaoweixin"];
    
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
    _tableview.tableHeaderView = [self setHeadView];
    _tableview.tableFooterView = [self setFooterView];
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    
    UIImage * image = [UIImage imageNamed:_iconArry[indexPath.row]];
    UIImageView*  imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20 , 30 -  image.size.height/2 , image.size.width,  image.size.height)];
    imgView.image = image;
    
    
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 10, 20 , 190, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = _titleArry[indexPath.row];
    
    if (indexPath.row == 2) {
        titleLbl.frame = CGRectMake(SCREEN_WIDTH - 205, 20 , 190, 20);
        titleLbl.text = @"微信提现暂未开通，敬请期待";
        titleLbl.textAlignment = NSTextAlignmentRight;
        titleLbl.textColor = [UIColor lightGrayColor];
//        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        cell.contentView.userInteractionEnabled = NO;
    }else {
        UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame = CGRectMake(SCREEN_WIDTH - 30, 20, 15, 15);
        chooseBtn.tag = indexPath.row + 1000;
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"tixianxuan"] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(choosePayMode:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:chooseBtn];
    }
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:titleLbl];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_lastBtnTag !=0 ) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:(NSInteger)_lastBtnTag];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"tixianxuan"] forState:UIControlStateNormal];
    }
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:(indexPath.row + 1000)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tixianxuanzhong"] forState:UIControlStateNormal];
    _lastBtnTag = (int)(indexPath.row + 1000);
}

- (void)choosePayMode:(UIButton *)btn
{
    if (_lastBtnTag !=0 ) {
         UIButton *btn1 = (UIButton *)[self.view viewWithTag:(NSInteger)_lastBtnTag];
         [btn1 setBackgroundImage:[UIImage imageNamed:@"tixianxuan"] forState:UIControlStateNormal];
    }
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:btn.tag];
     [btn2 setBackgroundImage:[UIImage imageNamed:@"tixianxuanzhong"] forState:UIControlStateNormal];
    _lastBtnTag = (int)btn.tag;
}


- (UIView *)setFooterView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15 , 100  ,SCREEN_WIDTH - 30, 40);
    [btn setTitle:@"提现后3个工作日内到账，确认提现" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    [btn addTarget:self action:@selector(goToDetailVC) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:2.5];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    [footerView addSubview:btn];
    return footerView;
}

-(void)goToDetailVC
{

    switch (_lastBtnTag) {
        case 0:
            [SVProgressHUD showInfoWithStatus:@"请选择提现方式"];
            [SVProgressHUD dismissWithDelay:1.0f];
            break;
        case 1000:
        {
                DrawMoneyViewController * drawMoneyVC = [[DrawMoneyViewController alloc]init];
                  drawMoneyVC.drawStyle = @"1";
            [self.navigationController pushViewController:drawMoneyVC animated:YES];
        }
            break;
        case 1001:
        {
            DrawMoneyViewController * drawMoneyVC = [[DrawMoneyViewController alloc]init];
            drawMoneyVC.drawStyle = @"2";
            [self.navigationController pushViewController:drawMoneyVC animated:YES];
        }
            break;
        case 1002:
        {
            [SVProgressHUD showErrorWithStatus:@"微信提现暂未开通，敬请期待"];
            [SVProgressHUD dismissWithDelay:1.0f];
            break;
//            DrawMoneyViewController * drawMoneyVC = [[DrawMoneyViewController alloc]init];
//            drawMoneyVC.drawStyle = @"2";
//            [self.navigationController pushViewController:drawMoneyVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (UIView *)setHeadView
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 , 150, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"提现方式";
    headView.backgroundColor = WKPColor(238, 238, 238);
    [headView addSubview:titleLbl];
    return headView;
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
