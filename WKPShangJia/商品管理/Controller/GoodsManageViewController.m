//
//  GoodsManageViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "GoodsManageViewController.h"
#import "WKPButton.h"
#import "WKPSButton.h"
#import "AddGoodsViewController.h"
#import "GoodsManageCell.h"
#import "GoodsInformation.h"
#import "MJExtension.h"
@interface GoodsManageViewController ()<UITableViewDelegate,UITableViewDataSource,GoodsManageCellDelegate,AddGoodsViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)WKPSButton * bottomBtn;
@property(nonatomic,assign)int page;
@end

@implementation GoodsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getDate];
    _page = 0;
    self.title = @"商品管理";
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)dataArry {
    if (!_dataArry) {
        _dataArry = [[NSMutableArray alloc]init];
    }
    return _dataArry;
}

//获取店铺数据
- (void)getDate
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:@(_page) forKey:@"page"];
    [param setObject:@(10) forKey:@"pagesize"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [WKPHttpRequest post:WKPGetshopproductlist param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[obj objectForKey:@"ret"] intValue]) {
                self.dataArry = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in [obj objectForKey:@"data"]) {
                GoodsInformation* goodsInformation = [[GoodsInformation alloc]init];
                goodsInformation = [GoodsInformation mj_objectWithKeyValues:dic];
                [self.dataArry addObject:goodsInformation];
  
            }
            [self setUpTableView];
            //[self setUpUI];
        }
        else{
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
     
    }];
    
}

- (void)setUpTableView
{
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    [self setUpUI];
   

}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsManageCell * cell = [[GoodsManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDataWitGoods:_dataArry[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)deleteGoods:(int)cellTag
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"商品删除" message:@"确定要删除该商品吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                      
                                   }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                   GoodsInformation * goodsInformation = _dataArry[cellTag];
                                   [param setObject:goodsInformation.id forKey:@"productid"];
                                   [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
                                   [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
                                   [WKPHttpRequest post:WKPDelshopproduct param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                                       if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
                                                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                                    [SVProgressHUD dismissWithDelay:1.0f];
                                                    [self getDate];
                                       }
                                       else{
                                           [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                                           [SVProgressHUD dismissWithDelay:1.0f];
                                       }
                                       
                                   }];

                               }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)editGoods:(int)cellTag
{
    AddGoodsViewController * addGoodsVC = [[AddGoodsViewController alloc]init];
    addGoodsVC.delegate = self;
    addGoodsVC.goodsInformation = _dataArry[cellTag];
    [self.navigationController pushViewController:addGoodsVC animated:YES];
    
}

- (void)goToAddGoodsVC
{
    AddGoodsViewController * addGoodsVC = [[AddGoodsViewController alloc]init];
    addGoodsVC.delegate = self;
    [self.navigationController pushViewController:addGoodsVC animated:YES];
}

-(void)backToGoodsManage
{
    [self getDate];

}

- (void)setUpUI
{
   
    if (_dataArry.count == 0) {
        
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
        headView.backgroundColor = [UIColor whiteColor];
        WKPButton * btn = [WKPButton buttonWithType:UIButtonTypeCustom];
        if (is_IPhone_X) {
            btn.frame = CGRectMake(SCREEN_WIDTH/2 - 80,80, 160, 83);
        }else {
            btn.frame = CGRectMake(SCREEN_WIDTH/2 - 80,80, 160, 80);
        }
        [btn setTitle:@"添加新商品" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goToAddGoodsVC) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setImage: [UIImage imageNamed:@"tianjiada"] forState:0];
        [headView addSubview:btn];
        _tableview.tableHeaderView = headView;
        
         if (_bottomBtn)
         {
             [_bottomBtn removeFromSuperview];
             _bottomBtn = NULL;
             [_tableview reloadData];
         }
    }
    
    else  {
        if (!_bottomBtn) {
            UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
            headView.backgroundColor = WKPColor(238, 238, 238);
            _tableview.tableHeaderView = headView;
            _bottomBtn = [WKPSButton buttonWithType:UIButtonTypeCustom];
            if (is_IPhone_X) {
                _bottomBtn.frame = CGRectMake(0, self.view.frame.size.height - 83, SCREEN_WIDTH, 83);
            }else {
             _bottomBtn.frame = CGRectMake(0, self.view.frame.size.height - 40, SCREEN_WIDTH, 40);
            }
            [_bottomBtn setTitle:@"添加新商品" forState:UIControlStateNormal];
            [_bottomBtn setImage: [UIImage imageNamed:@"tianjia"] forState:0];
            _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_bottomBtn addTarget:self action:@selector(goToAddGoodsVC) forControlEvents:UIControlEventTouchUpInside];
            _bottomBtn.backgroundColor = [UIColor whiteColor];
            [_bottomBtn setTitleColor:[UIColor redColor] forState:0];
            [self.view addSubview:_bottomBtn];
        }
        [_tableview reloadData];
       
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"%@",_bottomBtn);
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
