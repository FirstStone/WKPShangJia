//
//  MemberCardViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MemberCardViewController.h"
#import "MemberCardView.h"
#import "MemberCardMode.h"
#import "MemberCardCell.h"
#import <UIImageView+WebCache.h>

#define memberCardCellID    @"MemberCardCellID"
#define headViewID          @"headViewID"
#define footViewID          @"footViewID"
@interface MemberCardViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)MemberCardView * headMemberCardView;
@property(nonatomic,assign)int i;
@property (nonatomic, assign) NSInteger VIP_Number;
@property (nonatomic, strong) NSMutableArray *VIPDataSoureArray;
@property (nonatomic, strong) UICollectionView *colectionview;
@property (nonatomic, strong) UICollectionReusableView *headView;
@property (nonatomic, strong) UICollectionReusableView *footerView;
@property (nonatomic, strong) UIImageView *hearderImageView;
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation MemberCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员卡设置";
    _i = 0;
    self.VIPDataSoureArray = [[NSMutableArray alloc] init];
    self.VIP_Number = 0;
    [self setUpUI];
    [self VIPSampleDataSoureServer];
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    //_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 220);//头部大小
    flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 205);
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3 - 40 /3, 80);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    self.colectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    [self.view addSubview:_colectionview];
    self.colectionview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //_tableview.delegate = self;
    //_tableview.dataSource = self;
    self.colectionview.delegate = self;
    self.colectionview.dataSource = self;
    //UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    self.headView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    _headView.backgroundColor = [UIColor whiteColor];
    _headMemberCardView = [[MemberCardView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 200) andImageName:@"moban1"];
    self.hearderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 200)];
    [_headView addSubview:_hearderImageView];
    //[_headView addSubview:_headMemberCardView];
    _colectionview.backgroundColor = [UIColor whiteColor];
    //_tableview.backgroundColor = [UIColor whiteColor];
    //_tableview.tableHeaderView = headView;
    
    //UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205)];
    self.footerView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205)];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = WKPColor(238, 238, 238);
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_headMemberCardView.frame) + 10, SCREEN_WIDTH -10, 20)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"可选会员卡样式";
    [_headView addSubview:titleLbl];
    
    [backView addSubview:[self backimageName:@"moban1" andTitle:@"样式1" andFrame:CGRectMake(10, 40, SCREEN_WIDTH / 3 - 40 /3, 80)]];
    
    [backView addSubview:[self backimageName:@"moban2" andTitle:@"样式2" andFrame:CGRectMake(20 + SCREEN_WIDTH / 3 - 40 /3 , 40, SCREEN_WIDTH / 3 - 40 /3, 80)]];
    
    [backView addSubview:[self backimageName:@"moban3" andTitle:@"样式3" andFrame:CGRectMake(30 + (SCREEN_WIDTH / 3 - 40 /3 ) * 2, 40, SCREEN_WIDTH / 3 - 40 /3, 80)]];
    //UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backView.frame) + 20, SCREEN_WIDTH - 20, 40)];
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 40)];
    [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [_sureButton setBackgroundColor:[UIColor redColor]];
    _sureButton.layer.cornerRadius = 10.0;
    [_sureButton addTarget:self action:@selector(sureButtonChange) forControlEvents:UIControlEventTouchUpInside];
    [_colectionview registerClass:[MemberCardCell class] forCellWithReuseIdentifier:memberCardCellID];
    [_colectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewID];
    [_colectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID];

    
    [_footerView addSubview:_sureButton];
    //[_footerView addSubview:backView];
    _footerView.backgroundColor =  [UIColor whiteColor];
    //_tableview.tableFooterView = footerView;
    //[self.view addSubview:_tableview];
}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    //self.tabBarController.tabBar.hidden = YES;
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)changeMemberCardBackImage:(UITapGestureRecognizer *)tapGes
{
    switch (tapGes.view.tag - 1000) {
        case 0:
            if (_VIPDataSoureArray[0]) {
                [_headMemberCardView setBackViewImage:_VIPDataSoureArray[0]];
                //self.VIP_Number = [[_VIPDataSoureArray[0] VIP_image_id] integerValue];
            }else {
                [_headMemberCardView setBackViewImage:@"moban1"];
                //self.VIP_Number = -1;
            }
            break;
        case 1:
            if (_VIPDataSoureArray[1]) {
                [_headMemberCardView setBackViewImage:_VIPDataSoureArray[1]];
                //self.VIP_Number = [[_VIPDataSoureArray[1] VIP_image_id] integerValue];
            }else {
                [_headMemberCardView setBackViewImage:@"moban2"];
                //self.VIP_Number = -1;
            }

            break;
        default:
            if (_VIPDataSoureArray[2]) {
                [_headMemberCardView setBackViewImage:_VIPDataSoureArray[2]];
                //self.VIP_Number = [[_VIPDataSoureArray[2] VIP_image_id] integerValue];
            }else {
                [_headMemberCardView setBackViewImage:@"moban3"];
                //self.VIP_Number = -1;
            }

            break;
    }
}
- (UIView *)backimageName:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame
{
    
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.tag = _i+1000;
    _i++;
    //UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeMemberCardBackImage:)];
    //[view addGestureRecognizer:tapGesturRecognizer];
    MemberCardView * memberCardView = [[MemberCardView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 15) andImageName:imageName];
   
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(memberCardView.frame) + 5, frame.size.width, 15)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = title;
    [view addSubview:titleLbl];
    [view addSubview:memberCardView];
    return view;
}

#pragma mark ---- 自定方法
- (void)sureButtonChange {
    _sureButton.userInteractionEnabled = NO;
    _sureButton.backgroundColor = [UIColor lightGrayColor];
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置为会员卡样式？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //成功返回Block
        [self VIPDataSoureGoBackground:_VIP_Number];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sureButton.userInteractionEnabled = YES;
        _sureButton.backgroundColor = [UIColor redColor];
        return;
    }];
    [alertV addAction:noAction];
    [alertV addAction:okAction];
    [self presentViewController:alertV animated:YES completion:nil];
}
//上传会员卡样式
- (void)VIPDataSoureGoBackground:(NSInteger)cardid {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *card_id = [_VIPDataSoureArray[cardid] VIP_image_id];
    [dic setObject:card_id forKey:@"cardid"];
    [dic setObject:@([[defaults objectForKey:@"shopid"] intValue]) forKey:@"shopid"];
     [dic setObject:@([[defaults objectForKey:@"mid"] intValue]) forKey:@"mid"];
    [WKPHttpRequest post:Add_VIPData_Background_URL param:dic finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[obj objectForKey:@"ret"] intValue]) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }else {
            [SVProgressHUD showErrorWithStatus:@"设置失败"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        _sureButton.userInteractionEnabled = YES;
        _sureButton.backgroundColor = [UIColor redColor];
    }];
    
}
//获取会员卡全部样式
- (void)VIPSampleDataSoureServer {
    [WKPHttpRequest post:Get_VIP_Sample_URL param:nil finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([[obj objectForKey:@"ret"] intValue]) {
            for (NSDictionary *dic in obj[@"data"]) {
                MemberCardMode *memberCardModel = [MemberCardMode memberCardModelWithDictionary:dic];
                [self.VIPDataSoureArray addObject:memberCardModel];
            }
            [self.hearderImageView sd_setImageWithURL:[NSURL URLWithString:[_VIPDataSoureArray[0] vipCenter]]];
            [self.colectionview reloadData];
        }
    }];
}
- (void)setVIPImageToHeaderImageView:(NSURL *)url {
    [self.hearderImageView sd_setImageWithURL:url];
}

#pragma mark --- collectionViewDelegate dataSource
//cell 的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _VIPDataSoureArray.count;
}
//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//cell赋值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MemberCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:memberCardCellID forIndexPath:indexPath];
    [cell sizeToFit];
    [cell setupUI:_VIPDataSoureArray[indexPath.row]];
    return cell;
}
//头部显示内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewID forIndexPath:indexPath];
        [headerView addSubview:_headView];
        return headerView;
    }else if ([kind isEqual:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID forIndexPath:indexPath];
        [footView addSubview:_footerView];
        return footView;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //self.VIP_Number = [[_VIPDataSoureArray[indexPath.row] VIP_image_id] integerValue];
    self.VIP_Number = indexPath.row;
    [self.hearderImageView sd_setImageWithURL:[NSURL URLWithString:[_VIPDataSoureArray[indexPath.row] vipCenter]]];
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
