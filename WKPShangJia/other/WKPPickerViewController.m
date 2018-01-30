//
//  WKPPickerViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/29.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "WKPPickerViewController.h"
#import "PrivilegeManagement.h"
@interface WKPPickerViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UIPickerView * pickerView;
@property(nonatomic,strong)UITextField * contentField;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)NSMutableDictionary * dict;
@property(nonatomic,assign)int indexRow;

@end

@implementation WKPPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"noti1" object:nil];
    // Do any additional setup after loading the view.
}

- (void)setUpUIWithArry:(NSArray *)dataArry
{
    _dataArry = [[NSMutableArray alloc]initWithArray:dataArry];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableHeaderView = headerView;
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    footerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [footerView addGestureRecognizer:tapGestureRecognizer];
    _tableview.tableFooterView = footerView;
    [self.view addSubview:_tableview];
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"保存" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(onClickedOKbtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}

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

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    _contentField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
    _contentField.tag = 3340;
    [_contentField setFont:[UIFont systemFontOfSize:16]];
    [_contentField setTextColor:[UIColor blackColor]];
    _contentField.inputView = self.pickerView;
    if ([self.contentStr isEqualToString:@"请选择"]) {
        _contentField.placeholder = @"请选择";
    }
        else{
            
            _contentField.text = self.contentStr;
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
    return _dataArry.count;
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
    PrivilegeManagement * privilegeManagement = _dataArry[row];
    return privilegeManagement.title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _indexRow = (int)row;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    _dict = [[NSMutableDictionary alloc]init];
    PrivilegeManagement * privilegeManagement = _dataArry[_indexRow];
    _contentField.text = privilegeManagement.title;
    [_dict setObject:privilegeManagement.id forKey:@"id"];
    [self.contentField resignFirstResponder];

}

-(void)noti1
{
    _dict = [[NSMutableDictionary alloc]init];
    PrivilegeManagement * privilegeManagement = _dataArry[_indexRow];
    [_dict setObject:privilegeManagement.id forKey:@"id"];
    _contentField.text = privilegeManagement.title;

}

- (void)onClickedOKbtn {
    if ([_contentField.text isEqualToString:@""]) {
            [self.delegate backVC:@"请选择" andTag:(self.Tag - 100) andDict:_dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
        [self.delegate backVC:[NSString stringWithFormat:@"%@",_contentField.text] andTag:(self.Tag - 100) andDict:_dict];
        [self.navigationController popViewControllerAnimated:YES];
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
