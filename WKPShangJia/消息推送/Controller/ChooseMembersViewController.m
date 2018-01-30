//
//  ChooseMembersViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/14.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "ChooseMembersViewController.h"
#import "ChooseMembersCell.h"
#import "Member.h"
#import "MJExtension.h"
@interface ChooseMembersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * dataArry;
@property(nonatomic,strong)NSMutableArray * chooseMembersArry;
@end

@implementation ChooseMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员选择";
    _chooseMembersArry = [[NSMutableArray alloc]init];
    NSArray *chooseArry = [self.chooseMember componentsSeparatedByString:@","];
    for (int i = 0; i<chooseArry.count; i++) {
        [_chooseMembersArry addObject:[NSString stringWithFormat:@"%d",[chooseArry[i] intValue] + 1000]];
    }
    
    [self setUpUI];
    [self getData];
    // Do any additional setup after loading the view.
}


-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [WKPHttpRequest post:WKPListShopAllVIPInfo param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
            _dataArry = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in [obj objectForKey:@"data"]) {
                Member * member = [[Member alloc]init];
                [member mj_setKeyValues:dic];
                [_dataArry addObject:member];
                
            }
            [_tableview reloadData];
            
        }
        
        
    }];
    
    
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
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    UIButton  *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton setTitle:@"保存" forState:0];
    [releaseButton addTarget:self action:@selector(addTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}

-(void)addTo
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString * str;

    for (int i = 0; i<_chooseMembersArry.count; i++) {
        if (i == 0) {
            str = [NSString stringWithFormat:@"%d",[_chooseMembersArry[i] intValue] - 1000];
           
        }else{
        str = [NSString stringWithFormat:@"%@,%@",str,[NSString stringWithFormat:@"%d",[_chooseMembersArry[i] intValue] - 1000]];
        }
    }
    
    if(_chooseMembersArry.count !=0){
    [dic setObject:str forKey:@"memberArry"];
    [self.delegate backVC:nil andTag:10086 andDict:dic];
    }
    else
    {
    [self.delegate backVC:nil andTag:10087 andDict:nil];
    }

    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseMembersCell * cell = [[ChooseMembersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    [cell setData:_dataArry[indexPath.row]];
    Member * member = [[Member alloc]init];
    member = _dataArry[indexPath.row];
    UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.userInteractionEnabled = NO;
    chooseBtn.tag = [member.userID intValue] +1000;
    chooseBtn.frame = CGRectMake(10, 30 - 10, 20, 20);
    
    if ([_chooseMembersArry containsObject:[NSString stringWithFormat:@"%d", [member.userID intValue] +1000]]) {
           [chooseBtn setBackgroundImage:[UIImage imageNamed:@"tixianxuanzhong"] forState:UIControlStateNormal];
    }
    else{
            [chooseBtn setBackgroundImage:[UIImage imageNamed:@"tixianxuan"] forState:UIControlStateNormal];
    }
    [cell.contentView addSubview:chooseBtn];

    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    sectionView.backgroundColor = WKPColor(238, 238, 238);
//    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 20)];
//    titleLbl.textAlignment = NSTextAlignmentLeft;
//    titleLbl.font = [UIFont systemFontOfSize:14];
//    titleLbl.textColor = [UIColor blackColor];
//    titleLbl.text = @"A";
//    [sectionView addSubview:titleLbl];
//    return sectionView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Member * member = [[Member alloc]init];
    member = _dataArry[indexPath.row];

    if ([_chooseMembersArry containsObject:[NSString stringWithFormat:@"%d", [member.userID intValue] +1000]]) {
           [_chooseMembersArry removeObject:[NSString stringWithFormat:@"%d", [member.userID intValue] +1000]];
    }
    else{
          [_chooseMembersArry addObject:[NSString stringWithFormat:@"%d", [member.userID intValue] +1000]];
    }

 
    [tableView reloadData];
    
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
