//
//  CertificateViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "CertificateViewController.h"
#import "CertificateDiscount.h"
#import "MJExtension.h"
#import "CertificateDiscountCell.h"
#import "AddCertificateViewController.h"
@interface CertificateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)UITableView * tableview;
@end

@implementation CertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToAddCertificateVC) name:@"btn3" object:nil];
    [self setUpUI];
    
    // Do any additional setup after loading the view.
}

-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    
    [WKPHttpRequest post:WKPListShopCoinCertificate param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
                if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
                    _dataArry = [[NSMutableArray alloc]init];
                    for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                        CertificateDiscount *certificateDiscount = [[CertificateDiscount alloc]init];
                        certificateDiscount = [CertificateDiscount mj_objectWithKeyValues:dict];
                        [_dataArry addObject:certificateDiscount];
                    }
        
                    [_tableview reloadData];
                    
                }
                
    }];
    

}

- (void)setUpUI
{
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    
    
    UIButton * btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, SCREEN_HEIGHT - 144, SCREEN_WIDTH / 2, 40);
    [btnleft setTitle:@"输入兑换码" forState:UIControlStateNormal];
    btnleft.titleLabel.font = [UIFont systemFontOfSize:14];
 //   [btnleft addTarget:self action:@selector(goToAddGoodsVC) forControlEvents:UIControlEventTouchUpInside];
    btnleft.backgroundColor = WKPColor(250, 180, 65);
    [btnleft setTitleColor:[UIColor whiteColor] forState:0];
    
    UIButton * btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0, SCREEN_HEIGHT - 144, SCREEN_WIDTH , 40);
    [btnright setTitle:@"创建兑换券" forState:UIControlStateNormal];
    btnright.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnright addTarget:self action:@selector(goToAddCertificateVC) forControlEvents:UIControlEventTouchUpInside];
    btnright.backgroundColor = WKPColor(236,0,34);
    [btnright setTitleColor:[UIColor whiteColor] forState:0];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headerView;
    
  //  [self.view addSubview:btnleft];
  //  [self.view addSubview:btnright];
}


-(void)goToAddCertificateVC
{
    AddCertificateViewController * addCertificateVC = [[AddCertificateViewController alloc]init];
    [self.navigationController pushViewController:addCertificateVC animated:YES];
}



#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateDiscountCell * cell = [[CertificateDiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
   
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
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
