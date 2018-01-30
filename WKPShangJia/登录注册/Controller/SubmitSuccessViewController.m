//
//  SubmitSuccessViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/23.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "SubmitSuccessViewController.h"

@interface SubmitSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;

@end

@implementation SubmitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"提交成功";
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
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    
    UIImage * image = [UIImage imageNamed:@"chenggong"];
    UIImageView*  imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - image.size.width/2 , 50  , image.size.width,  image.size.height)];
    imgView.image = image;
    
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+ 10, SCREEN_WIDTH, 20)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = WKPColor(0, 186, 65);
    lbl.text = @"提交成功";
    
    UILabel * lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbl.frame) + 20, SCREEN_WIDTH, 20)];
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.font = [UIFont systemFontOfSize:14];
    lbl1.textColor = [UIColor blackColor];
    lbl1.text = @"注册申请提交成功,请等待后台审核";
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH/2 - 40,CGRectGetMaxY(lbl1.frame) + 10, 80, 20);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(goToHomeOrLogVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blueColor] forState:0];
    
    [headerView addSubview:imgView];
    [headerView addSubview:lbl];
    [headerView addSubview:lbl1];
    [headerView addSubview:btn];
    _tableview.tableFooterView = footerView;
    _tableview.tableHeaderView = headerView;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}



- (void)goToHomeOrLogVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
