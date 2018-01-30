//
//  EmployeeInforViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/9/1.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "EmployeeInforViewController.h"
#import "UIImageView+WebCache.h"
#import "Employee.h"
#import "MJExtension.h"
#import "WKPButton.h"
@interface EmployeeInforViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)UILabel * recommendMemberNumLbl;
@property(nonatomic,strong)UILabel * incomeNumLbl;
@property(nonatomic,strong)Employee* employee;
@property(nonatomic,strong)WKPButton * leftBtn;
@property(nonatomic,strong)WKPButton * rightBtn;
@property(nonatomic,strong)UILabel * jurisdictionLbl;
@end

@implementation EmployeeInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工详情";
    [self setUpUI];
    [self getDate];
    // Do any additional setup after loading the view.
}

//获取店员工详细数据
- (void)getDate
{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
    [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
    [param setObject:self.userId forKey:@"userID"];
    [WKPHttpRequest post:WKPGetShopMemberInfo param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
             _employee = [[Employee alloc]init];
            _employee = [Employee mj_objectWithKeyValues:[obj objectForKey:@"data"]];
            [self UIreloadWithData];
        }
    }];
    
}


- (void)UIreloadWithData
{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_employee.uface]] ;
    _nameLbl.text = _employee.realname;
    _recommendMemberNumLbl.text = @"99";
    _incomeNumLbl.text = @"10";
    [_leftBtn setTitle:_employee.jobName forState:0];
    [_rightBtn setTitle:_employee.mobile forState:0];
  
 
    
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
    _tableview.tableHeaderView = [self setUpHead];
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    _tableview.tableFooterView = [self setUpFooter];

}

-(UIView *)setUpFooter
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIView * verticalView = [[UIView alloc]initWithFrame:CGRectMake(9, 13, 1.5, 14)];
    verticalView.backgroundColor = [UIColor blackColor];
    
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 20, 20)];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"基本信息";
    
    _leftBtn = [WKPButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame  = CGRectMake(0, CGRectGetMaxY(titleLbl.frame), SCREEN_WIDTH/ 2, 60);
    [_leftBtn setImage: [UIImage imageNamed:@"zhiwei"] forState:0];
    [_leftBtn setTitleColor:[UIColor blackColor] forState:0];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _rightBtn = [WKPButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame  = CGRectMake(SCREEN_WIDTH/ 2, CGRectGetMaxY(titleLbl.frame), SCREEN_WIDTH/ 2, 60);
    [_rightBtn setImage: [UIImage imageNamed:@"dianhua"] forState:0];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:0];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_rightBtn.frame)+20, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(9, CGRectGetMaxY(lineView.frame) +13 , 1.5, 14)];
    verticalView1.backgroundColor = [UIColor blackColor];
    
    _jurisdictionLbl= [[UILabel alloc]initWithFrame:CGRectMake(titleLbl.frame.origin.x, verticalView1.frame.origin.y - 1, SCREEN_WIDTH - 40, 0)];
    _jurisdictionLbl.font = [UIFont systemFontOfSize:14];
    _jurisdictionLbl.textColor = [UIColor blackColor];
    _jurisdictionLbl.numberOfLines = 0;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.jurisdiction];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.jurisdiction length])];
    [_jurisdictionLbl setAttributedText:attributedString1];
    [_jurisdictionLbl sizeToFit];
 
    CGSize size = [_jurisdictionLbl sizeThatFits:CGSizeMake(_jurisdictionLbl.frame.size.width, MAXFLOAT)];
    _jurisdictionLbl.frame = CGRectMake(_jurisdictionLbl.frame.origin.x, _jurisdictionLbl.frame.origin.y, _jurisdictionLbl.frame.size.width,  size.height);
    
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_jurisdictionLbl.frame)+ 10);
    
    [footerView addSubview:verticalView];
    [footerView addSubview:titleLbl];
    [footerView addSubview:_rightBtn];
    [footerView addSubview:_leftBtn];
    [footerView addSubview:lineView];
    [footerView addSubview:verticalView1];
    [footerView addSubview:_jurisdictionLbl];
    return footerView;
    
    
}

- (UIView *)setUpHead
{
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 250-52)];
    headView.backgroundColor = WKPColor(255, 0, 30);
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2  - 40 , 30, 80, 80)];
    _headImgView.layer.cornerRadius=_headImgView.frame.size.width/2;//裁成圆角
    _headImgView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headImgView.layer.borderColor = [WKPColor(244, 127, 133) CGColor ];
    _headImgView.layer.borderWidth = 1.0f;
    
    _nameLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImgView.frame) + 10, SCREEN_WIDTH, 20)];
    _nameLbl.textAlignment = NSTextAlignmentCenter;
    _nameLbl.font = [UIFont systemFontOfSize:14];
    _nameLbl.textColor = [UIColor whiteColor];
    
    //推荐会员
    UIView * recommendMembersAllView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLbl.frame) + 20, SCREEN_WIDTH / 2, 80)];
    recommendMembersAllView.backgroundColor = WKPRColor(40, 43, 52, 0.2);
    
    _recommendMemberNumLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 , SCREEN_WIDTH / 2, 30)];
    _recommendMemberNumLbl.textAlignment = NSTextAlignmentCenter;
    _recommendMemberNumLbl.font = [UIFont systemFontOfSize:18];
    _recommendMemberNumLbl.textColor = [UIColor whiteColor];
    UILabel * recommendMemberLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_recommendMemberNumLbl.frame) , SCREEN_WIDTH / 2, 30)];
    recommendMemberLbl.textAlignment = NSTextAlignmentCenter;
    recommendMemberLbl.font = [UIFont systemFontOfSize:14];
    recommendMemberLbl.textColor = [UIColor whiteColor];
    recommendMemberLbl.text = @"推荐会员(个)";
    [recommendMembersAllView addSubview:_recommendMemberNumLbl];
    [recommendMembersAllView addSubview:recommendMemberLbl];
    
    UIView * verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5,recommendMembersAllView.frame.origin.y + recommendMembersAllView.frame.size.height  / 2 - 25, 1, 50)];
    verticalLineView.backgroundColor = WKPColor(210, 210, 210);

    
    //收入
    UIView * incomeAllView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(_nameLbl.frame) + 20 , SCREEN_WIDTH/2, 80)];
    incomeAllView.backgroundColor = WKPRColor(40, 43, 52, 0.2);
    
    _incomeNumLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 , SCREEN_WIDTH / 2, 30)];
    _incomeNumLbl.textAlignment = NSTextAlignmentCenter;
    _incomeNumLbl.font = [UIFont systemFontOfSize:18];
    _incomeNumLbl.textColor = [UIColor whiteColor];
    
    UILabel * incomeLbl  = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_recommendMemberNumLbl.frame) , SCREEN_WIDTH / 2, 30)];
    incomeLbl.textAlignment = NSTextAlignmentCenter;
    incomeLbl.font = [UIFont systemFontOfSize:14];
    incomeLbl.textColor = [UIColor whiteColor];
    incomeLbl.text = @"所得收入(元)";
    
    [incomeAllView addSubview:_incomeNumLbl];
    [incomeAllView addSubview:incomeLbl];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(recommendMembersAllView.frame), SCREEN_WIDTH, 10)];
    lineView.backgroundColor = WKPColor(238, 238, 238);


    [headView addSubview:lineView];
//    [headView addSubview:recommendMembersAllView];
//    [headView addSubview:verticalLineView];
//    [headView addSubview:incomeAllView];
    [headView addSubview:_headImgView];
    [headView addSubview:_nameLbl];

    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
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
