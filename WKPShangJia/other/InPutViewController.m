//
//  InPutViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/21.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "InPutViewController.h"
#import "IQKeyboardManager.h"
#import "ChooseMapViewController.h"

@interface InPutViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
    NSInteger _firstIndex;  // 一级 记录
    NSInteger _secondIndex;  // 二级 记录
}
@property(nonatomic,strong)UITextField * contentField;
@property(nonatomic,strong)UITableView * tableview;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) NSArray * arrayDS;
@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSMutableDictionary * dict;
@property(nonatomic,strong)UITextField * addressfield;
@property(nonatomic,strong)UIPickerView * tradingAreadatePicker;
@property(nonatomic,strong)NSMutableArray * streetArry;
@property(nonatomic,strong)UITextField * streetfield;
@property(nonatomic,strong)UIView * backView;
@property(nonatomic,assign)int streetTag;
@end

@implementation InPutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     _dict = [[NSMutableDictionary alloc]init];
    _streetTag = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"noti1" object:nil];
    if(self.VCStyle == inputVCWithCityPicker  || self.VCStyle == inputVCWithStatePicker)
    {
        _streetArry = [[NSMutableArray alloc]init];
        [self initData];
    }
    if (self.VCStyle == inputVCWithDataPicker) {
        [self setDataPickerView];
    }
    [self setUpUI];

    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpUI
{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    [self.view addSubview:_tableview];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = [self footerView];
    _tableview.tableHeaderView = headerView;
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"保存" forState:normal];
        releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(onClickedOKbtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;


}

-(UIView *)footerView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    footerView.userInteractionEnabled = YES;
    if (self.VCStyle == inputVCWithCityPicker) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH , 50)];
        UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.numberOfLines=0;
        lbl.font = [UIFont systemFontOfSize:14 ];
        lbl.textColor = [UIColor blackColor];
        lbl.text = @"点击保存后进入地图界面查看位置";
        [backView addSubview:lbl];
        [footerView addSubview:backView];
        
        if (!_backView) {
            _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , 50)];
            _backView.backgroundColor = [UIColor whiteColor];
            _addressfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
            _addressfield.tag = 3338;
            [_addressfield setFont:[UIFont systemFontOfSize:16]];
            [_addressfield setTextColor:[UIColor blackColor]];
            if ([self.contentStr isEqualToString:@"请填写"]) {
                _addressfield.placeholder = @"请填写详细地址";
            }
            else
            {
                NSArray *array = [self.contentStr componentsSeparatedByString:@"-"];
                NSLog(@"array:%@",array);
                _addressfield.text = array[3];
            }
            [_backView addSubview:_addressfield];
        }
        [footerView addSubview:_backView];
        
        if (self.streetId !=0 && _streetArry.count != 0) {
            UIView * streetbackView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH , 50)];
            streetbackView.backgroundColor = [UIColor whiteColor];
            _streetfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
            _streetfield.tag = 3339;
            [_streetfield setFont:[UIFont systemFontOfSize:16]];
            [_streetfield setTextColor:[UIColor blackColor]];
            _streetfield.placeholder = @"请选择商圈(选填)";
            _streetfield.text = self.street;
            _streetfield.inputView = self.tradingAreadatePicker;
            [streetbackView addSubview:_streetfield];
            [footerView addSubview:streetbackView];
        }
        
        
    }
    if([self.title isEqualToString:@"营业时间"])
    {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH , 50)];
        UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 30)];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.font = [UIFont systemFontOfSize:15 ];
        lbl.textColor = [UIColor blackColor];
        lbl.text = @"格式为xx:xx-xx:xx 24小时制";
        [backView addSubview:lbl];
        [footerView addSubview:backView];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [footerView addGestureRecognizer:tapGestureRecognizer];
    
    return footerView;
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    _contentField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
    _contentField.tag = 3337;
    if (self.Tag == 103  || self.Tag == 101   || self.Tag == 104) {
        _contentField.keyboardType =UIKeyboardTypeNumberPad;
    }
    if (self.Tag == 110){
    _contentField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    [_contentField setFont:[UIFont systemFontOfSize:16]];
    [_contentField setTextColor:[UIColor blackColor]];
    [_contentField becomeFirstResponder];
    if (self.VCStyle == inputVCWithCityPicker) {
        _contentField.inputView = self.pickerView;
        
    }
     if (self.VCStyle == inputVCWithDataPicker) {
        _contentField.inputView = self.datePicker;
    }
    if (self.VCStyle == inputVCWithStatePicker) {
        _contentField.inputView = self.pickerView;
    }
    if (self.VCStyle == inputVCWithNomal)
    {
         _contentField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    if ([self.contentStr isEqualToString:@"请填写"]) {
        _contentField.placeholder = @"请填写";
    }
    else{
        if (self.VCStyle == inputVCWithCityPicker) {
            NSArray *array = [self.contentStr componentsSeparatedByString:@"-"];
            _contentField.text = [NSString stringWithFormat:@"%@-%@-%@", array[0],array[1],array[2]];
        }
        else{
    _contentField.text = self.contentStr;
        }
    }
    [cell.contentView addSubview:_contentField];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)onClickedOKbtn {
    if (self.VCStyle == inputVCWithCityPicker) {
        if (![[_dict allKeys] containsObject:@"province"]&&[_addressfield.text isEqualToString:@""] ) {
            [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
        if(![_addressfield.text isEqualToString:@""]){
         [_dict setObject:_addressfield.text forKey:@"address"];
         [self.delegate backVC:[NSString stringWithFormat:@"%@-%@",_contentField.text,_addressfield.text] andTag:(self.Tag - 100) andDict:_dict];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
        ChooseMapViewController * chooseMapVC = [[ChooseMapViewController alloc]init];
        chooseMapVC.address = [[NSString stringWithFormat:@"%@%@",_contentField.text,_addressfield.text] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.navigationController pushViewController:chooseMapVC animated:YES];
    }
    
    else{
        if (![_contentField.text isEqualToString:@""]) {
            [self.delegate backVC:_contentField.text andTag:(self.Tag - 100) andDict:_dict];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}
//时间选择器
- (void)setDataPickerView
{
    _datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    
    [_datePicker setMinimumDate:localeDate];
    
}

//省市区时间选择器
-(void)initData
{
    if(self.VCStyle == inputVCWithStatePicker)
    {
        
        [WKPHttpRequest post:WKPGetindustryall param:NULL finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
            
            self.arrayDS = [[NSArray alloc]initWithArray:[obj objectForKey:@"data"]];
            [self resetPickerSelectRow];
            _firstIndex = _secondIndex = 0;
        }];

    }else{
    [self getStreet];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"city.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filename] == NO) {
        [WKPHttpRequest post:WKPListArea param:NULL finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            //数据存本地沙盒
            self.arrayDS = [[NSArray alloc]initWithArray:[obj objectForKey:@"data"]];
            NSDictionary * dic = @{@"city":self.arrayDS};
            [fm createFileAtPath:filename contents:nil attributes:nil];
            [dic writeToFile:filename atomically:YES];
            
        }];
        
    }
    else{
        self.arrayDS =[[NSArray alloc]initWithArray:[[NSDictionary dictionaryWithContentsOfFile:filename]objectForKey:@"city"]]; 
    }
    [self resetPickerSelectRow];
    _provinceIndex = _cityIndex = _districtIndex = 0;
    }
}

-(void)resetPickerSelectRow
{
    //类型选择器
    if (self.VCStyle == inputVCWithStatePicker) {
        [self.pickerView selectRow:_firstIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:_secondIndex inComponent:1 animated:YES];
    }
    //城市选择器
    else{
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
         }
}
#pragma mark - Load DataSource


// 懒加载方式
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


// 懒加载方式
-(UIPickerView *)tradingAreadatePicker
{
    if(!_tradingAreadatePicker){
        _tradingAreadatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _tradingAreadatePicker.dataSource = self;
        _tradingAreadatePicker.delegate = self;
        _tradingAreadatePicker.backgroundColor = [UIColor whiteColor];
    }
    
    return _tradingAreadatePicker;
}

#pragma mark - PickerView Delegate

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _tradingAreadatePicker) {
        return 1;
    }
    
    if (self.VCStyle == inputVCWithStatePicker) {
        
        return 2;
        
    }
    
    else{
        
    return 3;
        
    }
}

// 每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _tradingAreadatePicker) {
        return _streetArry.count;
    }
     //类型选择器
    if (self.VCStyle == inputVCWithStatePicker) {
        if(component == 0){
            return self.arrayDS.count;
        }
        else{

            return [self.arrayDS[_firstIndex][@"second"] count];
        }
    }
     //城市选择器
    else{
         if(component == 0){
        return self.arrayDS.count;
                                     }
       else if (component == 1){
        return [self.arrayDS[_provinceIndex][@"cityList"] count];
        }
       else{
        return [self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"countyList"] count];
            }
    }
}

// 返回每一行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     _streetTag = (int)row;
    if (pickerView == _tradingAreadatePicker) {
        return [_streetArry[row] objectForKey:@"name"];
    }
    
     //类型选择器
    if (self.VCStyle == inputVCWithStatePicker) {
        if(component == 0){
            
            return self.arrayDS[row][@"name"];
        }
        else{
    
            return self.arrayDS[_provinceIndex][@"second"][row][@"name"];
        }
    }
     //城市选择器
    else{
    if(component == 0){
        
        return self.arrayDS[row][@"name"];
    }
    else if (component == 1){
        
        return self.arrayDS[_provinceIndex][@"cityList"][row][@"name"];
    }
    else{
        
        return self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"countyList"][row][@"name"];
    }
    }
}

// 滑动或点击选择，确认pickerView选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    if (pickerView == _tradingAreadatePicker) {
        _streetTag = (int)row;
        return;
    }
    
    //类型选择器
    if (self.VCStyle == inputVCWithStatePicker) {
         if (component == 0){
            _firstIndex = row;
            _secondIndex = 0;
            [self.pickerView reloadComponent:1];
        }
        else{
            _secondIndex = row;
        }
        
        // 重置当前选中项
        [self resetPickerSelectRow];
    
}
    //城市选择器
    else{
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
    }
    
    // 重置当前选中项
    [self resetPickerSelectRow];
    }
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    _dict = [[NSMutableDictionary alloc]init];
    if (self.VCStyle == inputVCWithCityPicker) {
        
        NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"name"], self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"name"], self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"countyList"][_districtIndex][@"name"]];
        
        [_dict setObject:self.arrayDS[_provinceIndex][@"id"] forKey:@"province"];
        [_dict setObject:self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"id"] forKey:@"city"];
        [_dict setObject:self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"countyList"][_districtIndex][@"id"] forKey:@"county"];

        [_dict setObject:_addressfield.text forKey:@"address"];
        if (![_contentField.text isEqualToString:address] || ![self.contentStr isEqualToString:address]) {
            self.contentField.text = address;
            self.contentStr = address;
            self.streetId = [[_dict objectForKey:@"county"] intValue];
            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
            [param setObject:@(self.streetId) forKey:@"city_id"];
            _streetTag = -1;
            _streetArry = [[NSMutableArray alloc]init];
            self.street = @"";
            [WKPHttpRequest post:WKPGetAreaStreet param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                
                if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]]isEqualToString:@"1"]) {

                    for (NSDictionary *dic in [obj objectForKey:@"data"]) {
                        [_streetArry addObject:dic];
                    }
                    _tableview.tableFooterView = [self footerView];
                    
                }
                
            }];
            
        }
        else{
            
            if (_streetTag != -1 && _streetArry.count!=0 ) {
                _streetfield.text = [_streetArry[_streetTag] objectForKey:@"name"];
                self.street = [_streetArry[_streetTag] objectForKey:@"name"];

                [_dict setObject:_streetfield.text forKey:@"street"];
                [_dict setObject: [_streetArry[_streetTag] objectForKey:@"id"] forKey:@"streetId"];
            }
        }
    }
    if (self.VCStyle == inputVCWithStatePicker) {
        
        NSString * state = [NSString stringWithFormat:@"%@-%@", self.arrayDS[_firstIndex][@"name"], self.arrayDS[_firstIndex][@"second"][_secondIndex][@"name"]];
        
        [_dict setObject:self.arrayDS[_firstIndex][@"second"][_secondIndex][@"id"] forKey:@"industryid"];
        self.contentField.text = state;
    }
    if (self.VCStyle == inputVCWithDataPicker) {
        NSDateFormatter *forma = [[NSDateFormatter alloc]init];
        [forma setDateFormat:@"YYYY-MM-dd"];
        NSString *time = [forma stringFromDate:_datePicker.date];
        self.contentField.text = time;
    }
    [self.addressfield resignFirstResponder];
    [self.contentField resignFirstResponder];
    
}


- (void )getStreet
{
    if (self.streetId == 0) {
        return;
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:@(self.streetId) forKey:@"city_id"];
    [WKPHttpRequest post:WKPGetAreaStreet param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]]isEqualToString:@"1"]) {
            _streetTag = -1;
            _streetArry = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in [obj objectForKey:@"data"]) {
                [_streetArry addObject:dic];
            }
            _tableview.tableFooterView = [self footerView];
            
        }
        
    }];

}

-(void)noti1
{
    _dict = [[NSMutableDictionary alloc]init];
    if (self.VCStyle == inputVCWithCityPicker) {
        NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"name"], self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"name"], self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"countyList"][_districtIndex][@"name"]];
        
        [_dict setObject:self.arrayDS[_provinceIndex][@"id"] forKey:@"province"];
        [_dict setObject:self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"id"] forKey:@"city"];
        [_dict setObject:self.arrayDS[_provinceIndex][@"cityList"][_cityIndex][@"countyList"][_districtIndex][@"id"] forKey:@"county"];
        [_dict setObject:_addressfield.text forKey:@"address"];
        
        if (![_contentField.text isEqualToString:address] || ![self.contentStr isEqualToString:address]) {
            self.contentField.text = address;
            self.contentStr = address;
            self.streetId = [[_dict objectForKey:@"county"] intValue];
            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
            [param setObject:@(self.streetId) forKey:@"city_id"];
            _streetTag = -1;
            _streetArry = [[NSMutableArray alloc]init];
            self.street = @"";
            [WKPHttpRequest post:WKPGetAreaStreet param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {

                if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]]isEqualToString:@"1"]) {
                
                    for (NSDictionary *dic in [obj objectForKey:@"data"]) {
                        [_streetArry addObject:dic];
                    }
                    _tableview.tableFooterView = [self footerView];
                    
                }
                
            }];

        }
        else{
            if (_streetTag != -1 && _streetArry.count!=0 ) {
                _streetfield.text = [_streetArry[_streetTag] objectForKey:@"name"];
                self.street = [_streetArry[_streetTag] objectForKey:@"name"];
                [_dict setObject:_streetfield.text forKey:@"street"];
                [_dict setObject: [_streetArry[_streetTag] objectForKey:@"id"] forKey:@"streetId"];
            }
        }
    }
    if (self.VCStyle == inputVCWithStatePicker) {
        
        NSString * state = [NSString stringWithFormat:@"%@-%@", self.arrayDS[_firstIndex][@"name"], self.arrayDS[_firstIndex][@"second"][_secondIndex][@"name"]];
        
        [_dict setObject:self.arrayDS[_firstIndex][@"second"][_secondIndex][@"id"] forKey:@"industryid"];
        self.contentField.text = state;
        
    }
    
    if (self.VCStyle == inputVCWithDataPicker) {
        NSDateFormatter *forma = [[NSDateFormatter alloc]init];
        [forma setDateFormat:@"YYYY-MM-dd"];
        NSString *time = [forma stringFromDate:_datePicker.date];
        self.contentField.text = time;
    }
    
    [self.addressfield resignFirstResponder];
    [self.contentField resignFirstResponder];
    
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
