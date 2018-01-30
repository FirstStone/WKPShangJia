//
//  AddCertificateViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/9/9.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AddCertificateViewController.h"
#import "InPutViewController.h"
#import "ChooseMembersViewController.h"
@interface AddCertificateViewController ()<InPutViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,ChooseMembersViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSArray * titleArry;
@property(nonatomic,strong)NSMutableArray * dataArry;
@end

@implementation AddCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建兑换券";
   
    [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    _dataArry = [[NSMutableArray alloc]initWithArray: @[@"请填写",@"",@"请填写",@"请填写",@"请填写",@"",@"请选择"]];
    _titleArry = @[@"兑换券名称",@"",@"兑换开始时间",@"兑换结束时间",@"创建量(张)",@"",@"推送用户"];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = WKPColor(238, 238, 238);

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;

    [self.view addSubview:_tableview];
    UIButton  *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton setTitle:@"保存" forState:0];
    [releaseButton addTarget:self action:@selector(addTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    [self.view addSubview:_tableview];

    
}

-(void)addTo
{


    if ([_dataArry[0]isEqualToString:@"请填写"] || [_dataArry[2]isEqualToString:@"请填写"] || [_dataArry[3]isEqualToString:@"请填写"] || [_dataArry[4]isEqualToString:@"请填写"] || [_dataArry[6] isKindOfClass:[NSString class]]) {
        [SVProgressHUD showErrorWithStatus:@"请完善兑换券信息"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSUserDefaults * defaulsts = [NSUserDefaults standardUserDefaults];
    [param setObject:_dataArry[0] forKey:@"name"];
    [param setObject:_dataArry[4] forKey:@"number"];
    [param setObject:_dataArry[6][@"memberArry"] forKey:@"user"];
    [param setObject:[defaulsts objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaulsts objectForKey:@"shopid"] forKey:@"shopid"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [param setObject:[NSString stringWithFormat:@"%ld", (long)[[dateFormatter dateFromString:_dataArry[2]] timeIntervalSince1970]] forKey:@"begin_time"];
    [param setObject:[NSString stringWithFormat:@"%ld", (long)[[dateFormatter dateFromString:_dataArry[3]] timeIntervalSince1970]] forKey:@"end_time"];
    
    [WKPHttpRequest post:WKPAddShopCoinCertificate param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
         if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
             [SVProgressHUD showSuccessWithStatus:@"添加成功"];
             [SVProgressHUD dismissWithDelay:1.0f];
             [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    if (indexPath.row == 1 || indexPath.row == 5) {
        cell.backgroundColor = WKPColor(238, 238, 238);
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 120, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = _titleArry[indexPath.row];
    
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 15, 8, 10)];
    UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x - 160, 10 , 150, 20)];
    contentLbl.textAlignment = NSTextAlignmentRight;
    contentLbl.font = [UIFont systemFontOfSize:14 ];
    contentLbl.textColor = [UIColor blackColor];
    if ([_dataArry[indexPath.row] isKindOfClass:[NSDictionary class]]) {
         contentLbl.text = @"已选择";
    }else{
    contentLbl.text = _dataArry[indexPath.row];
}
    iconImage.image = [UIImage imageNamed:@"you"];
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:contentLbl];
    [cell.contentView addSubview:iconImage];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 5) {
        return 10;
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 0 || indexPath.row == 4 ){
        
        InPutViewController * inPutVC  = [[InPutViewController alloc]init];
        inPutVC.contentStr = _dataArry[indexPath.row];
        inPutVC.title = _titleArry[indexPath.row];
        inPutVC.delegate = self;
        inPutVC.Tag = 100 + (int)indexPath.row;
        inPutVC.VCStyle = inputVCWithNomal;
        [self.navigationController pushViewController:inPutVC animated:YES];
    }
    if (indexPath.row == 2 || indexPath.row == 3) {
        InPutViewController * inPutVC  = [[InPutViewController alloc]init];
        inPutVC.contentStr = _dataArry[indexPath.row];
        inPutVC.title = _titleArry[indexPath.row];
        inPutVC.delegate = self;
        inPutVC.Tag = 100 + (int)indexPath.row;
        inPutVC.VCStyle = inputVCWithDataPicker;
         [self.navigationController pushViewController:inPutVC animated:YES];
    }
    if(indexPath.row == 6)
    {
        ChooseMembersViewController * chooseMembersVC = [[ChooseMembersViewController alloc]init];
        if ([_dataArry[6] isKindOfClass:[NSDictionary class]]) {
            chooseMembersVC.chooseMember = _dataArry[6][@"memberArry"];
       
        }
        
        chooseMembersVC.delegate = self;
        [self.navigationController pushViewController:chooseMembersVC animated:YES];
    }
}

- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict
{
    if (Tag == 10086) {
            _dataArry[6] = dict;
            [_tableview reloadData];
        return;
    }
    if (Tag == 10087) {
        _dataArry[6] = @"请选择";
        [_tableview reloadData];
        return;
    }
    _dataArry[Tag] = contentStr;
    [_tableview reloadData];
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
