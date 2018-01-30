//
//  AddBanckCardViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/9/23.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AddBanckCardViewController.h"
#import "MJExtension.h"
#import "MyBankCard.h"
@interface AddBanckCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIPickerView *typePickerView;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)NSMutableArray * typeArry;
@property(nonatomic,strong)NSMutableArray * placeArry;
@property(nonatomic,strong)NSArray * titleArry;

@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)UITextField * textField1;
@property(nonatomic,strong)UITextField * textField2;
@property(nonatomic,strong)UITextField * textField3;
@property(nonatomic,strong)NSMutableArray  * cardIdArry;
@property(nonatomic,assign)int index1;
@property(nonatomic,assign)int index2;
@end

@implementation AddBanckCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"添加银行卡";
    [self getData];
    _index1 = -1;
    _index2 = -1;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"noti1" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


-(void)getData
{
    _dataArry = [[NSMutableArray alloc]init];
    _cardIdArry = [[NSMutableArray alloc]init];
    [WKPHttpRequest post:WKPGetBankList param:@{@"mid":[[NSUserDefaults standardUserDefaults] objectForKey:@"mid"]} finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
            for (NSDictionary *dic in [obj objectForKey:@"data"]) {
                MyBankCard * myBankCard = [[MyBankCard alloc]init];
                myBankCard = [MyBankCard mj_objectWithKeyValues:dic];
                [_dataArry addObject:myBankCard.name];
                [_cardIdArry addObject:myBankCard.id];
            }
             [self setUpUI];
        }
        
    }];

}


-(void)setUpUI
{
    _typeArry = [[NSMutableArray alloc]initWithArray:@[@"借记卡",@"信用卡"]];
    _placeArry = [[NSMutableArray alloc]initWithArray:@[@"请填写",@"请选择",@"请填写",@"请选择"]];
    _titleArry = @[@"持卡人",@"银行名",@"卡号",@"类别"];
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 , SCREEN_WIDTH, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"    请绑定持卡人本人的银行卡";
    [headerView addSubview:titleLbl];
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,40, SCREEN_WIDTH - 40, 40);
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    [btn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0];
    [footerView addSubview:btn];
    _tableview.tableFooterView = footerView;
    _tableview.tableHeaderView = headerView;

    _tableview.backgroundColor = WKPColor(238, 238, 238);

}

-(void)addBankCard
{
    if ([_textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人信息"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    if ([_textField1.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择银行卡"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    if ([_textField2.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡卡号"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    if ([_textField3.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择卡的类别"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(_index2 - 1) forKey:@"type"];
    [param setObject:_textField.text forKey:@"cardholder"];
    [param setObject:_textField2.text forKey:@"cardNumber"];
    [param setObject:_cardIdArry[_index1] forKey:@"bank_id"];
     [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mid"] forKey:@"mid"];
    [WKPHttpRequest post:WKPAddMyCard param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [SVProgressHUD dismissWithDelay:1.0f];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 20 , 60, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:15 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = _titleArry[indexPath.row];

    if (indexPath.row == 0) {
        _textField  = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 20 , 160, 20)];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [UIFont systemFontOfSize:15 ];
        _textField.textColor = [UIColor blackColor];
        _textField.placeholder = _placeArry[indexPath.row];
        [cell.contentView addSubview:_textField];
}
    if (indexPath.row == 1) {
        _textField1  = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 20 , 160, 20)];
        _textField1.textAlignment = NSTextAlignmentRight;
        _textField1.font = [UIFont systemFontOfSize:15 ];
        _textField1.textColor = [UIColor blackColor];
        _textField1.placeholder = _placeArry[indexPath.row];
        [cell.contentView addSubview:_textField1];
        _textField1.inputView = self.pickerView;
    }
    if (indexPath.row == 2) {
        _textField2  = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 20 , 160, 20)];
        _textField2.textAlignment = NSTextAlignmentRight;
        _textField2.font = [UIFont systemFontOfSize:15 ];
        _textField2.textColor = [UIColor blackColor];
        _textField2.placeholder = _placeArry[indexPath.row];
          _textField2.keyboardType = UIKeyboardTypeNumberPad;
          [cell.contentView addSubview:_textField2];
      
    }

    if (indexPath.row == 3) {
        _textField3  = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 20 , 160, 20)];
        _textField3.textAlignment = NSTextAlignmentRight;
        _textField3.font = [UIFont systemFontOfSize:15 ];
        _textField3.textColor = [UIColor blackColor];
        _textField3.placeholder = _placeArry[indexPath.row];
        _textField3.inputView = self.typePickerView;
        [cell.contentView addSubview:_textField3];
    }
    [cell.contentView addSubview:titleLbl];

    return cell;

}

-(UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _pickerView;
}

-(UIPickerView *)typePickerView
{
    if(!_typePickerView){
        _typePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _typePickerView.dataSource = self;
        _typePickerView.delegate = self;
        _typePickerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _typePickerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


#pragma mark pickerview function

//返回有几列

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 1;
    
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _typePickerView) {
        return [_typeArry count];
    }
        return  [_dataArry count];

}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 20.0f;
    
}

//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    if (pickerView == _typePickerView) {
       
       str  = [_typeArry objectAtIndex:row];
        _index2 = 0;

    }
    else{
     _index1 = 0;
       str = [_dataArry objectAtIndex:row];
    }
    return str;
    
}




//被选择的行

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _typePickerView) {
        
         NSLog(@"HANG%@",[_typeArry objectAtIndex:row]);
        _index2 = (int)row;
    }
    else{
    NSLog(@"HANG%@",[_dataArry objectAtIndex:row]);
        _index1 = (int)row;
    
    }
}

-(void)noti1
{
   if(_index1 != -1)
   {
       _textField1.text = _dataArry[_index1];
   }
    if(_index2 != -1)
    {
        _textField3.text = _typeArry[_index2];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
