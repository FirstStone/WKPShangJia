//
//  NewUserViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "NewUserViewController.h"
#import "NewUserCell.h"
#import "MJExtension.h"
#import "NewUserDiscount.h"
#import "ZYYBtn.h"
@interface NewUserViewController ()<UITableViewDelegate,UITableViewDataSource,NewUserCellDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UITextField * priceField;
@property(nonatomic,strong)UITextField * numField;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)NSString * style;

@property(nonatomic,strong)UITextField * someGoodsField;
@property(nonatomic,strong)UILabel *iswithLbl;
@property(nonatomic,strong)ZYYBtn *allGoodsBtn;
@property(nonatomic,strong)ZYYBtn *someGoodsBtn;
@property(nonatomic,strong)ZYYBtn * canWithOtherBtn;
@property(nonatomic,strong)NSString * canwithStyle;
@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addDiscount) name:@"btn1" object:nil];
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)addDiscount
{
    if ([_priceField.text isEqualToString:@""] || [_numField.text isEqualToString:@""] ) {
        [SVProgressHUD showErrorWithStatus:@"请完善优惠券信息"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
  
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(1) forKey:@"type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:_priceField.text forKey:@"totalPrice"];
    [param setObject:_numField.text forKey:@"discount"];
    [param setObject:@"1" forKey:@"begin_week"];
    [param setObject:@"7" forKey:@"end_week"];
    [param setObject:@"0:00" forKey:@"begin_hour"];
    [param setObject:@"24:00" forKey:@"end_hour"];
    [param setObject:@(1) forKey:@"useTimes"];
    [param setObject:@(1) forKey:@"style"];
    if ([self.style isEqualToString:@"0"]) {
        [param setObject:@"全部商品可用" forKey:@"restrictions"];
    }
    else
    {
        [param setObject:[NSString stringWithFormat:@"限%@可用",_someGoodsField.text] forKey:@"restrictions"];
    }
    if ([self.canwithStyle isEqualToString:@"0"]) {
        [param setObject:@(1) forKey:@"shared"];
    }
    else
    {
        [param setObject:@(0) forKey:@"shared"];
    }
    [WKPHttpRequest post:WKPAddShopCoupon param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [SVProgressHUD dismissWithDelay:1.0f];
            [self getData];
            
        }
  
    }];

}




- (void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(1) forKey:@"type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    
    [WKPHttpRequest post:WKPListShopCoupon param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            _dataArry = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                NewUserDiscount *newUserDiscount = [[NewUserDiscount alloc]init];
                newUserDiscount = [NewUserDiscount mj_objectWithKeyValues:dict];
                [_dataArry addObject:newUserDiscount];
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
//    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headerView;
 

}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewUserCell * cell = [[NewUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setData:_dataArry[indexPath.row]];
    cell.delegate = self;
    cell.cellTag = [NSString stringWithFormat:@"%ld",(long)indexPath.row ];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewUserDiscount *newUserDiscount = [[NewUserDiscount alloc]init];
    newUserDiscount = [NewUserDiscount mj_objectWithKeyValues:_dataArry[indexPath.row]];
    if ([newUserDiscount.shared isEqualToString:@"0"]) {
        return 140;
    }
    return 120;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setUpHeadView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 230;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UIView *)setUpHeadView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel* titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40 , 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"APP新用户优惠使用条件 : ";
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLbl.frame) + 10, SCREEN_WIDTH - 40 , 1)];
    lineView.backgroundColor = WKPColor(238, 238, 238);
    
    UILabel * contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLbl.frame) + 30, SCREEN_WIDTH - 40 , 20)];
    contentLbl.textAlignment = NSTextAlignmentLeft;
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.textColor = WKPColor(182, 182, 182);
    contentLbl.text = @"消费满            元,可抵用             微客币";
    _priceField = [[UITextField alloc]initWithFrame:CGRectMake(65, contentLbl.frame.origin.y - 2.5, 40, 25)];
    _priceField.layer.borderWidth=1.0f;
    _priceField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _priceField.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _numField = [[UITextField alloc]initWithFrame:CGRectMake(175, contentLbl.frame.origin.y - 2.5, 40, 25)];
    _numField.layer.borderWidth=1.0f;
    _numField.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _numField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _numField.keyboardType = UIKeyboardTypeDecimalPad;
    _priceField.keyboardType = UIKeyboardTypeDecimalPad;
    _priceField.font = [UIFont systemFontOfSize:12];
    _numField.font = [UIFont systemFontOfSize:12];
    _numField.textAlignment = NSTextAlignmentCenter;
    _priceField.textAlignment = NSTextAlignmentCenter;
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_priceField.frame) + 10, SCREEN_WIDTH - 40 , 1)];
    lineView1.backgroundColor = WKPColor(238, 238, 238);
    
    _allGoodsBtn = [ZYYBtn buttonWithType:UIButtonTypeCustom];
    [_allGoodsBtn addTarget:self action:@selector(touchesAll) forControlEvents:UIControlEventTouchUpInside];
    _allGoodsBtn.frame = CGRectMake(20, CGRectGetMaxY(contentLbl.frame)+ 20, 20, 20);
    [_allGoodsBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    UILabel * allGoodslbL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_allGoodsBtn.frame) +10, _allGoodsBtn.frame.origin.y, SCREEN_WIDTH - 65 , 20)];
    allGoodslbL.textAlignment = NSTextAlignmentLeft;
    allGoodslbL.font = [UIFont systemFontOfSize:14];
    allGoodslbL.textColor = WKPColor(182, 182, 182);
    allGoodslbL.text = @"全部商品可用";
    
    _someGoodsBtn = [ZYYBtn buttonWithType:UIButtonTypeCustom];
    _someGoodsBtn.frame = CGRectMake(20, CGRectGetMaxY(allGoodslbL.frame)+ 15, 20, 20);
    [_someGoodsBtn addTarget:self action:@selector(touchesSome) forControlEvents:UIControlEventTouchUpInside];
    [_someGoodsBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    
    UILabel * someGoodsLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_allGoodsBtn.frame) +10, _someGoodsBtn.frame.origin.y, SCREEN_WIDTH - 55 , 20)];
    someGoodsLbl.textAlignment = NSTextAlignmentLeft;
    someGoodsLbl.font = [UIFont systemFontOfSize:14];
    someGoodsLbl.textColor = WKPColor(182, 182, 182);
    someGoodsLbl.text = @"限                                                 商品可用";
    
     _someGoodsField = [[UITextField alloc]initWithFrame:CGRectMake(66, someGoodsLbl.frame.origin.y - 2.5, 180, 25)];
    _someGoodsField.layer.borderWidth=1.0f;
    _someGoodsField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _someGoodsField.placeholder = @"如酒水除外/原价";
    _someGoodsField.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _someGoodsField.font = [UIFont systemFontOfSize:12];
    _someGoodsField.textAlignment = NSTextAlignmentCenter;
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_someGoodsField.frame) + 10, SCREEN_WIDTH - 40 , 1)];
    lineView2.backgroundColor = WKPColor(238, 238, 238);
    
    _canWithOtherBtn = [ZYYBtn buttonWithType:UIButtonTypeCustom];
    [_canWithOtherBtn addTarget:self action:@selector(touchesCanWith) forControlEvents:UIControlEventTouchUpInside];
    _canwithStyle = @"0";
    _canWithOtherBtn.frame = CGRectMake(20, CGRectGetMaxY(_someGoodsField.frame)+ 20, 20, 20);
    [_canWithOtherBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    
    UILabel * canWithOtherlbL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_canWithOtherBtn.frame) +10, _canWithOtherBtn.frame.origin.y, SCREEN_WIDTH - 65 , 20)];
    canWithOtherlbL.textAlignment = NSTextAlignmentLeft;
    canWithOtherlbL.font = [UIFont systemFontOfSize:14];
    canWithOtherlbL.textColor = WKPColor(182, 182, 182);
    canWithOtherlbL.text = @"不与店内其他优惠同享";
    
    [view addSubview:titleLbl];
    [view addSubview:contentLbl];
    [view addSubview:lineView];
    [view addSubview:lineView1];
    [view addSubview:_priceField];
    [view addSubview:_numField];
    [view addSubview:_allGoodsBtn];
    [view addSubview:allGoodslbL];
    [view addSubview:_someGoodsBtn];
    [view addSubview:someGoodsLbl];
    [view addSubview:_someGoodsField];
    
    [view addSubview:lineView2];
    [view addSubview:_canWithOtherBtn];
    [view addSubview:canWithOtherlbL];
    [headerView addSubview:view];
    [self touchesAll];
    return headerView;
    
}

-(void)touchesCanWith
{
    if ([_canwithStyle isEqualToString:@"0"]) {
        _canwithStyle = @"1";
        [_canWithOtherBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    }
    else
    {
        _canwithStyle = @"0";
        [_canWithOtherBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    }
}
- (void)touchesAll
{
    self.style = @"0";
    [_allGoodsBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
     [_someGoodsBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
}
- (void)touchesSome
{
    self.style = @"1";
    [_allGoodsBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    [_someGoodsBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
}
-(void)deleteDiscount:(int)cellTag
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"优惠删除" message:@"确定要删除该优惠吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                   NewUserDiscount * newUserDiscount = _dataArry[cellTag];
                                   [param setObject:newUserDiscount.couponid forKey:@"couponid"];
                                   [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
                                   [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
                                   [WKPHttpRequest post:WKPDelshopcoupon param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                                       if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
                                           [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                           [SVProgressHUD dismissWithDelay:1.0f];
                                           [self getData];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
