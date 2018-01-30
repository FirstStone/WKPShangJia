//
//  MemberPreferencesViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberPreferencesViewController.h"
#import "MemberDiscount.h"
#import "MemberDiscountCell.h"
#import "InPutViewController.h"
#import "MJExtension.h"
#import "ZYYBtn.h"
@interface MemberPreferencesViewController ()<UITableViewDelegate,UITableViewDataSource,MemberDiscountCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,InPutViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UITextField * priceField;
@property(nonatomic,strong)UITextField * numField;
@property(nonatomic,strong)UITextField * priceField1;
@property(nonatomic,strong)UITextField * numField1;
@property(nonatomic,strong)UILabel * frequencyLbl;
@property(nonatomic,strong)UITextField * frequencyField;
@property(nonatomic,strong)UITextField * weekTimeFieldL;
@property(nonatomic,strong)UITextField * weekTimeFieldR;
@property(nonatomic,strong)UITextField * timeFieldL;
@property(nonatomic,strong)UITextField * timeFieldR;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)UIPickerView * pickerView;
@property(nonatomic,assign)int indexRow;
@property(nonatomic,strong)NSArray *pickerWeekArry;
@property(nonatomic,strong)NSMutableArray * pickerDataArry;
@property(nonatomic,strong)NSArray *pickerTimeArry;
@property(nonatomic,assign)int fieldTag;
@property(nonatomic,strong)UIButton * btn;
@property(nonatomic,strong)UIButton * btn1;
@property(nonatomic,assign)int  lastBtnTag;
@property(nonatomic,strong)UITextField * someGoodsField;
@property(nonatomic,strong)UILabel *iswithLbl;
@property(nonatomic,strong)ZYYBtn *allGoodsBtn;
@property(nonatomic,strong)ZYYBtn *someGoodsBtn;
@property(nonatomic,strong)NSString * style;
@property(nonatomic,strong)ZYYBtn * canWithOtherBtn;
@property(nonatomic,strong)NSString * canwithStyle;
@end

@implementation MemberPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _pickerWeekArry = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    _pickerTimeArry = @[@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",
                        @"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",
                        @"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",
                        @"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",
                        @"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",
                        @"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",
                        @"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addDiscount) name:@"btn2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"noti1" object:nil];
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}


-(void)addDiscount
{
    
    if (_lastBtnTag == 10000) {
        if ([_priceField.text isEqualToString:@""] || [_numField.text isEqualToString:@""] || [_weekTimeFieldL.text isEqualToString:@""] || [_weekTimeFieldR.text isEqualToString:@""] || [_timeFieldL.text isEqualToString:@""] || [_timeFieldR.text isEqualToString:@""] ) {
            [SVProgressHUD showErrorWithStatus:@"请完善优惠券信息"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
    }
    else
    {
        if ([_priceField1.text isEqualToString:@""] || [_numField1.text isEqualToString:@""] || [_weekTimeFieldL.text isEqualToString:@""] || [_weekTimeFieldR.text isEqualToString:@""] || [_timeFieldL.text isEqualToString:@""] || [_timeFieldR.text isEqualToString:@""] ) {
            [SVProgressHUD showErrorWithStatus:@"请完善优惠券信息"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(2) forKey:@"type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    if (_lastBtnTag == 10000) {
        [param setObject:_priceField.text forKey:@"totalPrice"];
        [param setObject:_numField.text forKey:@"discount"];
        [param setObject:@(1) forKey:@"style"];
    }else
    {
        [param setObject:_priceField1.text forKey:@"totalPrice"];
        [param setObject:_numField1.text forKey:@"discount"];
        [param setObject:@(2) forKey:@"style"];
    }
    for (int i = 1; i<=7; i++) {
        if ([_weekTimeFieldL.text isEqualToString:weekArry[i-1]]) {
            [param setObject:@(i) forKey:@"begin_week"];
            break;
        }
    }
    for (int i = 1; i<=7; i++) {
        if ([_weekTimeFieldR.text isEqualToString:weekArry[i-1]]) {
            [param setObject:@(i) forKey:@"end_week"];
            break;
        }
    }
    if ([self.style isEqualToString:@"0"]) {
        [param setObject:@"全部商品可用" forKey:@"restrictions"];
    }
    else
    {
        [param setObject:[NSString stringWithFormat:@"限%@可用",_someGoodsField.text] forKey:@"restrictions"];
    }
    [param setObject:_timeFieldL.text forKey:@"begin_hour"];
    [param setObject:_timeFieldR.text forKey:@"end_hour"];
    if (![_frequencyLbl.text isEqualToString:@""]) {
            [param setObject:_frequencyField.text forKey:@"useTimes"];
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
    [param setObject:@(2) forKey:@"type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    
    [WKPHttpRequest post:WKPListShopCoupon param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
            _dataArry = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in [obj objectForKey:@"data"]) {
                MemberDiscount *memberDiscount = [[MemberDiscount alloc]init];
                memberDiscount = [MemberDiscount mj_objectWithKeyValues:dict];
                [_dataArry addObject:memberDiscount];
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
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    _tableview.tableHeaderView =  [self setUpHeadView];;
    
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberDiscountCell * cell = [[MemberDiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)indexPath.row ]);
    cell.cellTag = [NSString stringWithFormat:@"%ld",(long)indexPath.row ];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberDiscount *memberDiscount = [[MemberDiscount alloc]init];
    memberDiscount = [MemberDiscount mj_objectWithKeyValues:_dataArry[indexPath.row]];
    if ([memberDiscount.shared isEqualToString:@"0"]) {
        return 230;
    }
    return 210;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

- (UIView *)setUpHeadView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 370)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40 , 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"会员优惠使用条件 : ";
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLbl.frame) + 20, SCREEN_WIDTH - 40 , 1)];
    lineView.backgroundColor = WKPColor(238, 238, 238);
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(10, CGRectGetMaxY(titleLbl.frame)+ 27.5, 25, 25);
    _btn.tag = 10000;
    _lastBtnTag= 10000;
    
    [_btn setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(choosePayMode:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(titleLbl.frame) + 30, SCREEN_WIDTH - 40 , 20)];
    contentLbl.textAlignment = NSTextAlignmentLeft;
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.textColor = WKPColor(182, 182, 182);
    contentLbl.text = @"消费满            元,可抵用             微客币";
    _priceField = [[UITextField alloc]initWithFrame:CGRectMake(contentLbl.frame.origin.x + 45 , contentLbl.frame.origin.y - 2.5, 40, 25)];
    _priceField.layer.borderWidth=1.0f;
    _priceField.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _numField = [[UITextField alloc]initWithFrame:CGRectMake(contentLbl.frame.origin.x + 155, contentLbl.frame.origin.y - 2.5, 40, 25)];
    _numField.layer.borderWidth=1.0f;
    _numField.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _priceField.font = [UIFont systemFontOfSize:12];
    _numField.font = [UIFont systemFontOfSize:12];
    _numField.keyboardType = UIKeyboardTypeDecimalPad;
    _priceField.keyboardType = UIKeyboardTypeDecimalPad;
    _numField.textAlignment = NSTextAlignmentCenter;
    _priceField.textAlignment = NSTextAlignmentCenter;
    
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame = CGRectMake(10, CGRectGetMaxY(contentLbl.frame)+ 13.5, 25, 25);
    _btn1.tag = 10001;
    [_btn1 setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(choosePayMode:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * contentLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(contentLbl.frame) + 15, SCREEN_WIDTH - 40 , 20)];
    contentLbl1.textAlignment = NSTextAlignmentLeft;
    contentLbl1.font = [UIFont systemFontOfSize:14];
    contentLbl1.textColor = WKPColor(182, 182, 182);
    contentLbl1.text = @"消费每满            元,可抵用             微客币";
    _priceField1 = [[UITextField alloc]initWithFrame:CGRectMake(contentLbl1.frame.origin.x + 60, contentLbl1.frame.origin.y - 2.5, 40, 25)];
    _priceField1.layer.borderWidth=1.0f;
    _priceField1.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _numField1 = [[UITextField alloc]initWithFrame:CGRectMake(contentLbl1.frame.origin.x + 170,  contentLbl1.frame.origin.y - 2.5, 40, 25)];
    _numField1.layer.borderWidth=1.0f;
    _numField1.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _priceField1.font = [UIFont systemFontOfSize:12];
    _numField1.font = [UIFont systemFontOfSize:12];
    _numField1.keyboardType = UIKeyboardTypeDecimalPad;
    _priceField1.keyboardType = UIKeyboardTypeDecimalPad;
    _numField1.textAlignment = NSTextAlignmentCenter;
    _priceField1.textAlignment = NSTextAlignmentCenter;

    
    UILabel * frequencyLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(contentLbl1.frame) + 15, SCREEN_WIDTH - 40 , 20)];
    frequencyLbl.textAlignment = NSTextAlignmentLeft;
    frequencyLbl.font = [UIFont systemFontOfSize:14];
    frequencyLbl.textColor = WKPColor(182, 182, 182);
    frequencyLbl.text = @"可在店消费使用            次";
    _frequencyField = [[UITextField alloc]initWithFrame:CGRectMake(frequencyLbl.frame.origin.x + 102, frequencyLbl.frame.origin.y - 2.5, 40, 25)];
    _frequencyField.layer.borderWidth=1.0f;
    _frequencyField.font = [UIFont systemFontOfSize:12];
    _frequencyField.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _frequencyField.keyboardType = UIKeyboardTypeNumberPad;
    _frequencyField.textAlignment = NSTextAlignmentCenter;
    
    UILabel * weekTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(frequencyLbl.frame) + 15, SCREEN_WIDTH - 40 , 20)];
    weekTimeLbl.textAlignment = NSTextAlignmentLeft;
    weekTimeLbl.font = [UIFont systemFontOfSize:14];
    weekTimeLbl.textColor = WKPColor(182, 182, 182);
    weekTimeLbl.text = @"限时间            到            使用";
    _weekTimeFieldL = [[UITextField alloc]initWithFrame:CGRectMake(weekTimeLbl.frame.origin.x + 45, weekTimeLbl.frame.origin.y - 2.5, 40, 25)];
    _weekTimeFieldL.layer.borderWidth=1.0f;
    _weekTimeFieldL.font = [UIFont systemFontOfSize:12];
    _weekTimeFieldL.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _weekTimeFieldR = [[UITextField alloc]initWithFrame:CGRectMake(weekTimeLbl.frame.origin.x + 105, weekTimeLbl.frame.origin.y - 2.5, 40, 25)];
    _weekTimeFieldR.layer.borderWidth=1.0f;
    _weekTimeFieldR.font = [UIFont systemFontOfSize:12];
    _weekTimeFieldR.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _weekTimeFieldL.tag = 3333;
    _weekTimeFieldR.tag = 3334;
    _weekTimeFieldR.textAlignment = NSTextAlignmentCenter;
    _weekTimeFieldL.textAlignment = NSTextAlignmentCenter;
    _weekTimeFieldL.delegate = self;
    _weekTimeFieldR.delegate = self;
    
    UILabel * timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(weekTimeLbl.frame) + 15, SCREEN_WIDTH - 40 , 20)];
    timeLbl.textAlignment = NSTextAlignmentLeft;
    timeLbl.font = [UIFont systemFontOfSize:14];
    timeLbl.textColor = WKPColor(182, 182, 182);
    timeLbl.text = @"限时间            到            使用";
    _timeFieldL = [[UITextField alloc]initWithFrame:CGRectMake(timeLbl.frame.origin.x + 45, timeLbl.frame.origin.y - 2.5, 40, 25)];
    _timeFieldL.layer.borderWidth=1.0f;
    _timeFieldL.font = [UIFont systemFontOfSize:12];
    _timeFieldL.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    _timeFieldR = [[UITextField alloc]initWithFrame:CGRectMake(timeLbl.frame.origin.x + 105, timeLbl.frame.origin.y - 2.5, 40, 25)];
    _timeFieldR.layer.borderWidth=1.0f;
    _timeFieldR.font = [UIFont systemFontOfSize:12];
    _timeFieldR.layer.borderColor=WKPColor(182, 182, 182).CGColor;
    
    _timeFieldL.tag = 3335;
    _timeFieldR.tag = 3336;
    
    _timeFieldL.delegate = self;
    _timeFieldR.delegate = self;
    
    _timeFieldR.textAlignment = NSTextAlignmentCenter;
    _timeFieldL.textAlignment = NSTextAlignmentCenter;
    NSLog(@"%f",CGRectGetMaxY(_timeFieldL.frame));
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeLbl.frame) + 10, SCREEN_WIDTH - 40 , 1)];
    lineView1.backgroundColor = WKPColor(238, 238, 238);
    
    _allGoodsBtn = [ZYYBtn buttonWithType:UIButtonTypeCustom];
        [_allGoodsBtn addTarget:self action:@selector(touchesAll) forControlEvents:UIControlEventTouchUpInside];
    _allGoodsBtn.frame = CGRectMake(20, CGRectGetMaxY(timeLbl.frame)+ 20, 20, 20);
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
    [view addSubview:lineView];
    [view addSubview:_btn];
    [view addSubview:contentLbl];
    [view addSubview:_priceField];
    [view addSubview:_numField];
    
    [view addSubview:_btn1];
    [view addSubview:contentLbl1];
    [view addSubview:_priceField1];
    [view addSubview:_numField1];
    
    [view addSubview:frequencyLbl];
    [view addSubview:_frequencyField];
    
    [view addSubview:weekTimeLbl];
    [view addSubview:_weekTimeFieldL];
    [view addSubview:_weekTimeFieldR];
    
    [view addSubview:timeLbl];
    [view addSubview:_timeFieldL];
    [view addSubview:_timeFieldR];
    
    [view addSubview:lineView1];
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
- (void)choosePayMode:(UIButton *)btn
{
    if (_lastBtnTag !=0 ) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:(NSInteger)_lastBtnTag];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    }
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:btn.tag];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    _lastBtnTag = (int)btn.tag;
}


-(UIPickerView *)pickerView
{
    if(_fieldTag == 3333 || _fieldTag == 3334){
        _pickerDataArry = [[NSMutableArray alloc]initWithArray:_pickerWeekArry];
    }
    else
    {
        _pickerDataArry = [[NSMutableArray alloc]initWithArray:_pickerTimeArry];
    }

        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    
    
    return _pickerView;
}

#pragma mark - uipickerview
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行

    
    return _pickerDataArry.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    _indexRow = (int)row;
    return _pickerDataArry[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _indexRow = (int)row;
}

-(void)noti1
{
   
    if(_fieldTag == 3333 || _fieldTag == 3334)
    {
         UITextField *textField = (UITextField *)[self.view viewWithTag:(_fieldTag)];
         textField.text = _pickerWeekArry[_indexRow];
    }
    if(_fieldTag == 3335 || _fieldTag == 3336)
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:(_fieldTag)];
        textField.text = _pickerTimeArry[_indexRow];
    }
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
                                   MemberDiscount * memberDiscount = _dataArry[cellTag];
                                   [param setObject:memberDiscount.couponid forKey:@"couponid"];
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
//- (void)textFieldDidEndEditing:(UITextField *)textField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _fieldTag = (int)textField.tag;
    if (textField == _weekTimeFieldL || textField == _weekTimeFieldR) {
        _pickerDataArry = [[NSMutableArray alloc]initWithArray:_pickerWeekArry];
        _weekTimeFieldL.inputView = self.pickerView;
        _weekTimeFieldR.inputView = self.pickerView;
        //InPutViewController *inputVC = [[InPutViewController alloc] init];
        //inputVC.VCStyle = inputVCWithStatePicker;
        
    }
    if (textField == _timeFieldL || textField == _timeFieldR) {
        _pickerDataArry = [[NSMutableArray alloc]initWithArray:_pickerTimeArry];
        _timeFieldL.inputView = self.pickerView;
        _timeFieldR.inputView = self.pickerView;
    }
     UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.pickerView addGestureRecognizer:tapGestureRecognizer];
}
// return NO to disallow editing.
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)keyboardHide:(UITapGestureRecognizer *)tap {
    NSLog(@"111111111");
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
