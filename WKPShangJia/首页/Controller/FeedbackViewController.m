//
//  FeedbackViewController.m
//  WeiKePaiShangJia
//
//  Created by JIN CHAO on 2017/8/8.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "FeedbackViewController.h"
#import "YMTextView.h"
#import "InPutViewController.h"
@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,InPutViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)YMTextView * myTextView;
@property(nonatomic,strong)UILabel *contentLbl;
@property(nonatomic,strong)NSMutableArray * dataArry;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"意见反馈";
    _dataArry = [[NSMutableArray alloc]initWithArray:@[@"请填写"]];
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
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    headerView.backgroundColor = WKPColor(238, 238, 238);

    _myTextView = [[YMTextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 90)];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 90)];
    backView.backgroundColor  = [UIColor whiteColor];
    _myTextView.placeholder = @"您好,请详细描述您遇到的问题,或者给我们建议,我们会认真讨论解决";
    _myTextView.delegate  = self;
    _myTextView.textColor = [UIColor blackColor];
    _myTextView.font = [UIFont systemFontOfSize:14];
    [backView addSubview: _myTextView];
    [headerView addSubview:backView];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    _tableview.tableHeaderView = headerView;
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"提交" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 , 60, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14 ];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"联系电话";
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 15, 8, 10)];
     _contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x - 160, 10 , 150, 20)];
    _contentLbl.textAlignment = NSTextAlignmentRight;
    _contentLbl.font = [UIFont systemFontOfSize:14 ];
    _contentLbl.textColor = [UIColor blackColor];
    _contentLbl.text = _dataArry[indexPath.row];
    iconImage.image = [UIImage imageNamed:@"you"];
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:_contentLbl];
    [cell.contentView addSubview:iconImage];

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    InPutViewController * inPutVC  = [[InPutViewController alloc]init];
    inPutVC.contentStr = _dataArry[indexPath.row];
    inPutVC.title = @"意见反馈";
    inPutVC.delegate = self;
    inPutVC.Tag = 100 + (int)indexPath.row;
    inPutVC.VCStyle = inputVCWithNomal;
    [self.navigationController pushViewController:inPutVC animated:YES];
}

- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict
{
    _dataArry[Tag] = contentStr;
    [_tableview reloadData];
}

- (void)feedBack
{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:_myTextView.text forKey:@"content"];
    if (![_contentLbl isEqual:@"请填写"]) {
        [param setObject:_contentLbl.text forKey:@"mobile"];
    }
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [WKPHttpRequest post:WKPUserfeedback param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
            
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }];

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
