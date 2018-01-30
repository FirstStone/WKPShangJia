//
//  HomeViewController.m
//  WeiKePaiShangJia
//
//  Created by JIN CHAO on 2017/8/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "HomeViewController.h"
#import "RatingBar.h"
#import "WKPButton.h"
#import "NewsViewController.h"
#import "SetUpViewController.h"
#import "MerchantInforViewController.h"
#import "PrivilegeManagementCBSSViewController.h"
#import "GoodsManageViewController.h"
#import "MyWalletViewController.h"
#import "MemberManageViewController.h"
#import "ConsumersViewController.h"
#import "MemberCardViewController.h"
#import "OrderManagementCBSSViewController.h"
#import "MessagePushCBSSViewController.h"
#import "PreferencesSettingsViewController.h"
#import "SubmitQualificationViewController.h"
#import "LoginCBSSViewController.h"
#import "MyNavViewController.h"
#import "Store.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "MyBankcardViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,RatingBarDelegate>
@property(nonatomic,strong)UIView * navView ;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)NSMutableArray * iconArry;
@property(nonatomic,strong)NSMutableArray * titleArry;
@property (nonatomic, strong) NSMutableArray *jobMenu_array;
@property(nonatomic,strong)UILabel * saleNumLbl;
@property(nonatomic,strong)UILabel * orderNumLbl;
@property(nonatomic,strong)RatingBar * ratingBar;
@property(nonatomic,strong)Store * store;
@property(nonatomic,strong)NSString *onOff;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPrivacy];
    //self.view.backgroundColor = WKPColor(255, 0, 30);
    // Do any additional setup after loading the view.
}

- (void)setDataSoure {
        [WKPHttpRequest post:WKPOnOff param:NULL finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([[obj objectForKey:@"ret"] isEqualToString:@"1"]) {
                if ([[obj objectForKey:@"data"] isEqualToString:@"1"]) {
                    NSArray * array_1 = @[@"商品管理",@"权限管理",@"订单管理",@"优惠设置",@"银行卡",@"商家信息",@"我的钱包",@"我的会员",@"会员卡",@"已消费客户"];
                    self.titleArry  = [NSMutableArray arrayWithArray:array_1];
                    NSArray * array_icon = @[@"shangpinguanli",@"quanxianguanli",@"dingdanguanli",@"youhuishezhi",@"yinhangkaguanli",@"xiaoxituisong",@"wodeqianbao",@"wodehuiyuan",@"huiyuankashezhi",@"yixiaofeikehu"];
                    self.iconArry = [NSMutableArray arrayWithArray:array_icon];
                    _onOff = @"1";
                }
                if ([[obj objectForKey:@"data"] isEqualToString:@"0"])
                {
                    NSArray * array_1 = @[@"商品管理",@"权限管理",@"订单管理",@"银行卡",@"商家信息",@"我的钱包",@"已消费客户"];
                    NSArray * array_icon = @[@"shangpinguanli",@"quanxianguanli",@"dingdanguanli",@"yinhangkaguanli",@"xiaoxituisong",@"wodeqianbao",@"yixiaofeikehu"];
                    self.titleArry = [NSMutableArray arrayWithArray:array_1];
                    self.iconArry = [NSMutableArray arrayWithArray:array_icon];
                    _onOff = @"0";
                }
                [self setUpUI];
            }
        }];
}


- (void)getPrivacy
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [WKPHttpRequest post:WKPListShopMember param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[obj objectForKey:@"ret"] intValue]) {
            NSArray *data_array = [obj objectForKey:@"data"];
            for (int i = 0; i < data_array.count; i++) {
                NSDictionary *dic = data_array[i];
                if ([[dic objectForKey:@"userid"] intValue] == [[defaults objectForKey:@"mid"] intValue]) {
                    self.jobMenu_array = [dic objectForKey:@"jobMenu"];
                    for (int j = 0; j < self.jobMenu_array.count; j++) {
                        switch ([self.jobMenu_array[j] intValue]) {
                            case 1:
                                [self.titleArry addObject:@"商品管理"];
                                [self.iconArry addObject:@"shangpinguanli"];
                                break;
                            case 2:
                                [self.titleArry addObject:@"权限管理"];
                                [self.iconArry addObject:@"quanxianguanli"];
                                break;
                            case 3:
                                [self.titleArry addObject:@"订单管理"];
                                [self.iconArry addObject:@"dingdanguanli"];
                                break;
                            case 4:
                                [self.titleArry addObject:@"优惠设置"];
                                [self.iconArry addObject:@"youhuishezhi"];
                                break;
                            case 5:
                                [self.titleArry addObject:@"银行卡"];
                                [self.iconArry addObject:@"yinhangkaguanli"];
                                break;
                            case 6:
                                [self.titleArry addObject:@"商家信息"];
                                [self.iconArry addObject:@"xiaoxituisong"];
                                break;
                            case 7:
                                [self.titleArry addObject:@"我的钱包"];
                                [self.iconArry addObject:@"wodeqianbao"];
                                break;
                            case 8:
                                [self.titleArry addObject:@"我的会员"];
                                [self.iconArry addObject:@"wodehuiyuan"];
                                break;
                            case 9:
                                [self.titleArry addObject:@"会员卡"];
                                [self.iconArry addObject:@"huiyuankashezhi"];
                                break;
                            case 10:
                                [self.titleArry addObject:@"已消费客户"];
                                [self.iconArry addObject:@"yixiaofeikehu"];
                                break;
                            default:
                                break;
                        }
                    }
                    _onOff = @"2";
                    [self setUpUI];
                    break;
                }
            }
            if (!_titleArry.count) {
                [self setDataSoure];
            }
        }
    }];
    
    
    
    
//    [WKPHttpRequest post:WKPOnOff param:NULL finish:^(NSData *data, NSDictionary *obj, NSError *error) {
//        if ([[obj objectForKey:@"ret"] isEqualToString:@"1"]) {
//            if ([[obj objectForKey:@"data"] isEqualToString:@"1"]) {
//                self.titleArry = @[@"商品管理",@"权限管理",@"订单管理",@"优惠设置",@"银行卡",@"商家信息",@"我的钱包",@"我的会员",@"会员卡",@"已消费客户"];
//                self.iconArry = @[@"shangpinguanli",@"quanxianguanli",@"dingdanguanli",@"youhuishezhi",@"yinhangkaguanli",@"xiaoxituisong",@"wodeqianbao",@"wodehuiyuan",@"huiyuankashezhi",@"yixiaofeikehu"];
//                _onOff = @"1";
//            }
//            if ([[obj objectForKey:@"data"] isEqualToString:@"0"])
//            {
//                self.titleArry = @[@"商品管理",@"权限管理",@"订单管理",@"银行卡",@"商家信息",@"我的钱包",@"已消费客户"];
//                self.iconArry = @[@"shangpinguanli",@"quanxianguanli",@"dingdanguanli",@"yinhangkaguanli",@"xiaoxituisong",@"wodeqianbao",@"yixiaofeikehu"];
//                _onOff = @"0";
//            }
//            [self setUpUI];
//        }
//    }];
}
- (NSMutableArray *)jobMenu_array {
    if (!_jobMenu_array) {
        _jobMenu_array = [NSMutableArray array];
    }
    return _jobMenu_array;
}
- (NSMutableArray *)titleArry {
    if (!_titleArry) {
        _titleArry = [NSMutableArray array];
    }
    return _titleArry;
}
- (NSMutableArray *)iconArry {
    if (!_iconArry) {
        _iconArry = [NSMutableArray array];
    }
    return _iconArry;
}

//获取店铺数据
- (void)getDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [parm setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [WKPHttpRequest post:WKGetusershopinfo param:parm finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
        _store = [[Store alloc]init];
        _store = [Store mj_objectWithKeyValues:[obj objectForKey:@"data"]];
            NSMutableArray * imgArry = [[NSMutableArray alloc]init];
            if (![self.store.banner isEqualToString:@""]) {
                NSArray *array = [self.store.banner componentsSeparatedByString:@","];
//                if (![defaults valueForKey:@"imageArr"]) {
                    for (int i = 0 ; i<array.count; i++) {
                        //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]];
//                        UIImage *image = [UIImage imageWithData:data];
                        NSString *str = array[i];
                        [imgArry addObject:str];
                    }
//                }else {
//                    NSLog(@"11111");
//                    imgArry = [defaults objectForKey:@"imageArray"];
//                }
//                NSLog(@"%@",imgArry);
            }
            
        _store.bannerImage = imgArry;
        [self UIreloadWithData];
        }
    }];
}


- (void)UIreloadWithData
{
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_store.logo]] ;
    _nameLbl.text = _store.title;
    _orderNumLbl.text = _store.totalorder;
    _saleNumLbl.text = _store.totalpay;
     [_ratingBar displayRating:[_store.score intValue]];
    //[SVProgressHUD dismiss];
}

#pragma 创建UI
- (void)setUpUI
{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_tableview];
//    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    _tableview.delegate = self;
    
    _tableview.dataSource = self;
    _tableview.tableHeaderView = [self setUpHead];
    _tableview.backgroundColor = WKPColor(255, 0, 30);
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;

    
}


- (void)setAleartWithState
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"shopStatus"]] isEqualToString:@"0"]) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未添加店铺请去添加店铺" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * backVC = [UIAlertAction actionWithTitle:@"换账号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goToLogVC];
        }];
        UIAlertAction * goToSubmit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SubmitQualificationViewController * submitQualificationVC = [[SubmitQualificationViewController alloc]init];
            [self.navigationController pushViewController:submitQualificationVC animated:YES];
        }];
        [alertVC addAction:backVC];
        [alertVC addAction:goToSubmit];
        [self presentViewController:alertVC animated:NO completion:nil];
    }else if ([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"shopStatus"]] isEqualToString:@"1"]) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"店铺正在审核中" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * backVC = [UIAlertAction actionWithTitle:@"换账号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goToLogVC];
        }];
        [alertVC addAction:backVC];
        [self presentViewController:alertVC animated:NO completion:nil];
    }else if ([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"shopStatus"]] isEqualToString:@"3"] ) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的审核被拒绝请前往重新提交" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * backVC = [UIAlertAction actionWithTitle:@"换账号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goToLogVC];
        }];
        UIAlertAction * goToSubmit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SubmitQualificationViewController * submitQualificationVC = [[SubmitQualificationViewController alloc]init];
            [self.navigationController pushViewController:submitQualificationVC animated:YES];
        }];
        [alertVC addAction:backVC];
        [alertVC addAction:goToSubmit];
        [self presentViewController:alertVC animated:NO completion:nil];
    }else {
        _tableview.userInteractionEnabled = YES;
        [self getDate];
    }
}


- (void)goToLogVC
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"isLogin"] isEqualToString:@"0"]) {
        [defaults setObject:@"0" forKey:@"mid"];
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [defaults setObject:@"0" forKey:@"mid"];
        LoginCBSSViewController *logVC = [[LoginCBSSViewController alloc] init];
        MyNavViewController * nav = [[MyNavViewController alloc]initWithRootViewController:logVC];
        [defaults setObject:@"0" forKey:@"isLogin"];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}


- (UIView *)setUpHead
{
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 180)];
    headView.backgroundColor = WKPColor(255, 0, 30);
    
    UIView * headTagBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 80)];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addButtonClick_MerchantInforVC:)];
    [headTagBackView addGestureRecognizer:tapGesturRecognizer];
    headTagBackView.backgroundColor = [UIColor redColor];
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20 , 0, 50, 50)];
    _headImgView.layer.cornerRadius=_headImgView.frame.size.width/2;//裁成圆角
    _headImgView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headImgView.layer.borderColor = [WKPColor(244, 127, 133) CGColor ];
    _headImgView.layer.borderWidth = 1.0f;

    _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 10, _headImgView.frame.origin.y + 5 , 150, 20)];
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    _nameLbl.font = [UIFont systemFontOfSize:14 weight:1];
    _nameLbl.textColor = [UIColor whiteColor];
    
    _ratingBar = [[RatingBar alloc] initWithFrame:CGRectMake(_nameLbl.frame.origin.x - 4, CGRectGetMaxY(_nameLbl.frame) + 5, 100, 15)];
    _ratingBar.isIndicator = YES;
    _ratingBar.userInteractionEnabled = NO;
    [_ratingBar setImageDeselected:@"xingh" halfSelected:NULL fullSelected:@"xing" andDelegate:self];
   
    
    UIImage * headTagBackImage = [UIImage imageNamed:@"youyou"];
    UIImageView * tagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - headTagBackImage.size.width - 10, 25 - headTagBackImage.size.height / 2, headTagBackImage.size.width, headTagBackImage.size.height)];
    tagImageView.image = headTagBackImage;
    
 //营业额
    UIView * salesAllView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headTagBackView.frame), SCREEN_WIDTH/2, 80)];
    
    
    _saleNumLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 , SCREEN_WIDTH / 2, 30)];
    _saleNumLbl.textAlignment = NSTextAlignmentCenter;
    _saleNumLbl.font = [UIFont systemFontOfSize:18];
    _saleNumLbl.textColor = [UIColor redColor];
  
    
    UILabel * saleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_saleNumLbl.frame) , SCREEN_WIDTH / 2, 30)];
    saleLbl.textAlignment = NSTextAlignmentCenter;
    saleLbl.font = [UIFont systemFontOfSize:14];
    saleLbl.textColor = [UIColor blackColor];
    saleLbl.text = @"今日营业总额(元)";
    
    [salesAllView addSubview:_saleNumLbl];
    [salesAllView addSubview:saleLbl];
    
    UIView * verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5,salesAllView.frame.origin.y + salesAllView.frame.size.height  / 2 - 25, 1, 50)];
    verticalLineView.backgroundColor = WKPColor(210, 210, 210);
    salesAllView.backgroundColor = [UIColor whiteColor];
 
//订单
    UIView * orderAllView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(headTagBackView.frame) , SCREEN_WIDTH/2, 80)];
    orderAllView.backgroundColor = [UIColor whiteColor];
    
    _orderNumLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 , SCREEN_WIDTH / 2, 30)];
    _orderNumLbl.textAlignment = NSTextAlignmentCenter;
    _orderNumLbl.font = [UIFont systemFontOfSize:18];
    _orderNumLbl.textColor = [UIColor redColor];

    UILabel * orderLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_saleNumLbl.frame) , SCREEN_WIDTH / 2, 30)];
    orderLbl.textAlignment = NSTextAlignmentCenter;
    orderLbl.font = [UIFont systemFontOfSize:14];
    orderLbl.textColor = [UIColor blackColor];
    orderLbl.text = @"今日有效订单(单)";
    
    [orderAllView addSubview:_orderNumLbl];
    [orderAllView addSubview:orderLbl];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(salesAllView.frame), SCREEN_WIDTH, 10)];
    lineView.backgroundColor = WKPColor(248, 248, 248);
    

    [headView addSubview:lineView];
    [headView addSubview:salesAllView];
    [headView addSubview:verticalLineView];
    [headView addSubview:orderAllView];
    [headTagBackView addSubview:_ratingBar];
    [headTagBackView addSubview:_headImgView];
    [headTagBackView addSubview:_nameLbl];
    [headTagBackView addSubview:tagImageView];
    [headView addSubview:headTagBackView];
    return headView;
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    if ([_onOff isEqualToString:@"0"]) {
        for (int i = 0; i < 3; i++) {
            if (((indexPath.row == 2) && (i == 1)) || (indexPath.row == 2 && i == 2)) {
                return cell;
            }
            WKPButton * wkpBtn = [WKPButton buttonWithType:UIButtonTypeCustom];
            wkpBtn.frame  = CGRectMake(SCREEN_WIDTH/3 * i, 0, SCREEN_WIDTH/3, 120);
            [wkpBtn setTitle:_titleArry[indexPath.row * 3 + i] forState:0];
            wkpBtn.tag = 1000 + indexPath.row * 3 + i;
            [wkpBtn addTarget:self action:@selector(goToChiledVC:) forControlEvents:UIControlEventTouchUpInside];
            [wkpBtn setImage: [UIImage imageNamed:_iconArry[indexPath.row * 3 + i]] forState:0];
            [wkpBtn setTitleColor:[UIColor blackColor] forState:0];
            wkpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:wkpBtn];
        }
    }else if ([_onOff intValue] == 2){
        for (int i = 0; i < 3; i++) {
            
            if (indexPath.row * 3 + i == _titleArry.count) {
                return cell;
            }else {
                NSLog(@"%ld", indexPath.row);
                WKPButton * wkpBtn = [WKPButton buttonWithType:UIButtonTypeCustom];
                wkpBtn.frame  = CGRectMake(SCREEN_WIDTH/3 * i, 0, SCREEN_WIDTH/3, 120);
                [wkpBtn setTitle:_titleArry[indexPath.row * 3 + i] forState:0];
                NSInteger k = indexPath.row * 3 + i;
                wkpBtn.tag = 1000 + [self.jobMenu_array[k] intValue] - 1;
                [wkpBtn addTarget:self action:@selector(goToChiledVC:) forControlEvents:UIControlEventTouchUpInside];
                [wkpBtn setImage: [UIImage imageNamed:_iconArry[indexPath.row * 3 + i]] forState:0];
                [wkpBtn setTitleColor:[UIColor blackColor] forState:0];
                wkpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:wkpBtn];
                if (indexPath.row == 3) {
                    return cell;
                }
            }
        }
        
    }else {
        for (int i = 0; i < 3; i++) {
            WKPButton * wkpBtn = [WKPButton buttonWithType:UIButtonTypeCustom];
        wkpBtn.frame  = CGRectMake(SCREEN_WIDTH/3 * i, 0, SCREEN_WIDTH/3, 120);
        [wkpBtn setTitle:_titleArry[indexPath.row * 3 + i] forState:0];
        wkpBtn.tag = 1000 + indexPath.row * 3 + i;
        [wkpBtn addTarget:self action:@selector(goToChiledVC:) forControlEvents:UIControlEventTouchUpInside];
        [wkpBtn setImage: [UIImage imageNamed:_iconArry[indexPath.row * 3 + i]] forState:0];
        [wkpBtn setTitleColor:[UIColor blackColor] forState:0];
        wkpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:wkpBtn];
        if (indexPath.row == 3) {

            return cell;
            
        }
    }
}
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_onOff isEqualToString:@"0"])
    {
        return 3;
    }else if ([_onOff intValue] == 2) {
        return (_titleArry.count % 3) > 0 ? (_titleArry.count/3) + 1 : (_titleArry.count/3);
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)addButtonClick_goToSetUpVC:(UIButton *)btn {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToSetUpVC) object:btn];
    [self performSelector:@selector(goToSetUpVC) withObject:btn afterDelay:0.2f];
}
- (void)goToSetUpVC
{
    SetUpViewController * setUpVC = [[SetUpViewController alloc]init];
    [self.navigationController pushViewController:setUpVC animated:YES];
    
}

- (void)addButtonClick_goToNewsVC:(UIButton *)btn {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToNewsVC) object:btn];
    [self performSelector:@selector(goToNewsVC) withObject:btn afterDelay:0.3f];
}
- (void)goToNewsVC
{
    NewsViewController * newsVC = [[NewsViewController alloc]init];
    [self.navigationController pushViewController:newsVC animated:YES];
    
}
- (void)addButtonClick_MerchantInforVC:(UIButton *)btn {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToMerchantInforVC) object:btn];
    [self performSelector:@selector(goToMerchantInforVC) withObject:btn afterDelay:0.3f];
}

- (void)goToMerchantInforVC
{
    MerchantInforViewController * merChantInforVC = [[MerchantInforViewController alloc]init];
    merChantInforVC.store = _store;
    [self.navigationController pushViewController:merChantInforVC animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    _navView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    //[SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    //多线程调用
    dispatch_queue_t _prepraerQueue = dispatch_queue_create("text.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_prepraerQueue, ^{
        [self getShopStatus];
    });
    //设置移除黑线
    self.navigationController.navigationBar.clipsToBounds = YES;
    if (!_navView) {
        [self setUpNavView];
    }
    _navView.hidden = NO;
}

- (void)getShopStatus
{
    //[SVProgressHUD showWithStatus:nil];
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [WKPHttpRequest post:WKPGetShopInforByMid param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        NSLog(@"%@",obj);
        if ([[obj objectForKey:@"ret"] intValue]) {
            [defaults setObject:[obj objectForKey:@"shopid"] forKey:@"shopid"];
            [defaults setObject:[obj objectForKey:@"shopStatus"] forKey:@"shopStatus"];
            [self setAleartWithState];
        }
        else{
            
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录异常请重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * backVC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self goToLogVC];
            }];
            [alertVC addAction:backVC];
            [self presentViewController:alertVC animated:NO completion:nil];
        }
    }];
}

- (void)addButtonClick:(WKPButton *)btn {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToChiledVC:) object:btn];
    [self performSelector:@selector(goToChiledVC:) withObject:btn afterDelay:0.2f];
}

- (void)goToChiledVC:(WKPButton *)btn
{
    btn.userInteractionEnabled = NO;
    switch (btn.tag - 1000) {
        case 0:
        {
            GoodsManageViewController * goodsManageVC = [[GoodsManageViewController alloc]init];
            [self.navigationController pushViewController:goodsManageVC animated:YES];
        }
            btn.userInteractionEnabled = YES;
            break;
        case 1:
        {
            PrivilegeManagementCBSSViewController * privilegeManagementCBSSVC = [[PrivilegeManagementCBSSViewController alloc]init];
            [self.navigationController pushViewController:privilegeManagementCBSSVC animated:YES];
        }
            btn.userInteractionEnabled = YES;
            break;
        case 2:
        {
            OrderManagementCBSSViewController * orderManagementCBSSVC = [[OrderManagementCBSSViewController alloc]init];
            [self.navigationController pushViewController:orderManagementCBSSVC animated:YES];
        }
            btn.userInteractionEnabled = YES;
            break;
        case 3:
        {
            if ([_onOff isEqualToString:@"0"]) {
                MyBankcardViewController * myBankcardVC = [[MyBankcardViewController alloc]init];
                [self.navigationController pushViewController:myBankcardVC animated:YES];
            }
            else{
            PreferencesSettingsViewController * preferencesSettingsVC = [[PreferencesSettingsViewController alloc]init];
            [self.navigationController pushViewController:preferencesSettingsVC animated:YES];
            }
        }
            btn.userInteractionEnabled = YES;
            break;
        case 4:
        {
            if ([_onOff isEqualToString:@"0"]) {
            MerchantInforViewController * merChantInforVC = [[MerchantInforViewController alloc]init];
            merChantInforVC.store = _store;
            [self.navigationController pushViewController:merChantInforVC animated:YES];
        }
            else{
            MyBankcardViewController * myBankcardVC = [[MyBankcardViewController alloc]init];
            [self.navigationController pushViewController:myBankcardVC animated:YES];
           }
        }
            btn.userInteractionEnabled = YES;
            break;
        case 5:
        {
          //  MessagePushCBSSViewController * messagePushCBSSVC = [[MessagePushCBSSViewController alloc]init];
           // [self.navigationController pushViewController:messagePushCBSSVC animated:YES];
            if ([_onOff isEqualToString:@"0"]) {
                MyWalletViewController * myWalletVC = [[MyWalletViewController alloc]init];
                [self.navigationController pushViewController:myWalletVC animated:YES];
            }
            else{
            MerchantInforViewController * merChantInforVC = [[MerchantInforViewController alloc]init];
            merChantInforVC.store = _store;
            [self.navigationController pushViewController:merChantInforVC animated:YES];
        }
        }
            btn.userInteractionEnabled = YES;
            break;
        case 6:
        {
            if ([_onOff isEqualToString:@"0"]) {
                ConsumersViewController * consumersVC = [[ConsumersViewController alloc]init];
                [self.navigationController pushViewController:consumersVC animated:YES];
            }
            else{
            MyWalletViewController * myWalletVC = [[MyWalletViewController alloc]init];
            [self.navigationController pushViewController:myWalletVC animated:YES];
            }
        }
            btn.userInteractionEnabled = YES;
            break;
        case 7:
        {
            if ([_onOff isEqualToString:@"0"]) {
                ConsumersViewController * consumersVC = [[ConsumersViewController alloc]init];
                [self.navigationController pushViewController:consumersVC animated:YES];
            }
            else{
            MemberManageViewController * memberManageVC = [[MemberManageViewController alloc]init];
            [self.navigationController pushViewController:memberManageVC animated:YES];
        }
        }
            btn.userInteractionEnabled = YES;
            break;
        case 8:
        {
            if ([_onOff isEqualToString:@"0"]) {
                MerchantInforViewController * merChantInforVC = [[MerchantInforViewController alloc]init];
                merChantInforVC.store = _store;
                [self.navigationController pushViewController:merChantInforVC animated:YES];

            }
            else{
            MemberCardViewController * memberCardVC = [[MemberCardViewController alloc]init];
            [self.navigationController pushViewController:memberCardVC animated:YES];
            }
        }
            btn.userInteractionEnabled = YES;
            break;
        case 9:
        {
            ConsumersViewController * consumersVC = [[ConsumersViewController alloc]init];
            [self.navigationController pushViewController:consumersVC animated:YES];
        }
            btn.userInteractionEnabled = YES;
            break;
        case 10:
        {
            MerchantInforViewController * merChantInforVC = [[MerchantInforViewController alloc]init];
            merChantInforVC.store = _store;
            [self.navigationController pushViewController:merChantInforVC animated:YES];

        }
            btn.userInteractionEnabled = YES;
            break;
        default:
            btn.userInteractionEnabled = YES;
            break;
    }
}



-(void)ratingBar:(RatingBar *)ratingBar ratingChanged:(float)newRating{
    
}



-(void)setUpNavView
{
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor = WKPColor(255, 0, 30);
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusBarView.frame), SCREEN_WIDTH, 44)];
    _navView.backgroundColor = WKPColor(255, 0, 30);
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(20, 16, 20, 20);
    [setBtn addTarget:self action:@selector(addButtonClick_goToSetUpVC:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    
    UIButton * newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newsBtn.frame = CGRectMake(SCREEN_WIDTH - 45, setBtn.frame.origin.y, 20, 20);
    [newsBtn setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [newsBtn addTarget:self action:@selector(addButtonClick_goToNewsVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [_navView addSubview:setBtn];
    [_navView addSubview:newsBtn];
    [self.view addSubview:statusBarView];
    [self.view addSubview:_navView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _tableview.contentSize =CGSizeMake(0,690);
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
