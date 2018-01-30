//
//  SMSEditorViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "SMSEditorViewController.h"
#import "YMTextView.h"
#import "ChooseMembersViewController.h"
@interface SMSEditorViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)YMTextView * myTextView;

@end

@implementation SMSEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _tableview.tableFooterView = footerView;
    _tableview.tableHeaderView = headerView;
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 , 200, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = @"剩余短信条数:1000条";
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 70,12.5, 60 ,25);
        [btn setTitle:@"购买" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 ];
    //    [btn addTarget:self action:@selector(goToWithdrawalsVC) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitleColor:[UIColor whiteColor] forState:0];

        [cell.contentView addSubview:titleLbl];
        [cell.contentView addSubview:btn];
        
        return cell;
    }
    if (indexPath.row == 1 || indexPath.row == 3) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.backgroundColor = WKPColor(238, 238, 238);
        cell.userInteractionEnabled = NO;
        return cell;
    }
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 , 120, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = (int)indexPath.row == 2? @"推送会员": @"推送短信模版";
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 20, 8, 10)];
    UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x - 160, 15 , 150, 20)];
    contentLbl.textAlignment = NSTextAlignmentRight;
    contentLbl.font = [UIFont systemFontOfSize:14 ];
    contentLbl.textColor = [UIColor blackColor];
    contentLbl.text = @"请选择";
    iconImage.image = [UIImage imageNamed:@"you"];
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:contentLbl];
    [cell.contentView addSubview:iconImage];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 3) {
        return 10;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2) {
        ChooseMembersViewController * chooseMembersVC = [[ChooseMembersViewController alloc]init];
        [self.navigationController pushViewController:chooseMembersVC animated:YES];
    }
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
