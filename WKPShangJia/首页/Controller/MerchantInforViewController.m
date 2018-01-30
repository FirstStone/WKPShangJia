//
//  MerchantInforViewController.m
//  WeiKePaiShangJia
//
//  Created by JIN CHAO on 2017/8/9.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MerchantInforViewController.h"
#import "AddExhibitionPlanViewController.h"
#import "UIImageView+WebCache.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "InPutViewController.h"
#import "AFNetworking.h"
#import "StoreQRCodeViewController.h"
@interface MerchantInforViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,InPutViewControllerDelegate,AddExhibitionPlanViewControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)NSArray * titleArry;
@property(nonatomic,strong)UIImageView * headImageView;
@property(nonatomic,strong)NSMutableArray * contentArry;
@property(strong, nonatomic) CLLocation *location;
@property(nonatomic, strong) UIImagePickerController *imagePickerVc;
@property(nonatomic,strong)NSMutableDictionary * stateIdDict;
@property(nonatomic,strong)NSMutableDictionary * addressIdDict;
@property(nonatomic,strong)UIButton * releaseButton;
@end

@implementation MerchantInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家信息";
    [self setUpUI];
   
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
  
    _titleArry = @[@"头像",@"手机号",@"店铺名称",@"商家电话",@"商家二维码",@"商家地址",@"所属分类",@"商家展示图",@"",@"营业时间",@"人均消费",@"", [NSString stringWithFormat:@"http://gxhy.vkepai.com/?weikepai/shopdetail&shop_id=%@",self.store.id],@"",@"营业执照编号",@"营业执照结束时间",@"营业执照照片",@"",@"行业资质证结束时间",@"行业资质证照片"];
    _addressIdDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"province":self.store.provinceid,
                                                                                                       @"city":self.store.cityid,
                                                                                                       @"county":self.store.countyid,
                                                                                                       @"address":self.store.address}];
    
    if (self.store.districtname) {
        [_addressIdDict setObject:self.store.districtname forKey:@"street"];
        [_addressIdDict setObject:self.store.bus_district_id forKey:@"streetId"];
    }
    
    _stateIdDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"industryid":self.store.industryid}];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
     [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr ;
    if ([[NSString stringWithFormat:@"%@-%@",self.store.service_begin_time,self.store.service_end_time] isEqualToString:@"-"]) {
        timeStr = @"请填写";
    }
    else{
         timeStr = [NSString stringWithFormat:@"%@-%@",self.store.service_begin_time,self.store.service_end_time];
    }
    NSArray * arry = @[self.store.logo,self.store.usermobile,self.store.title,self.store.mobile,@"",[NSString stringWithFormat:@"%@-%@-%@-%@",self.store.provicncename,self.store.cityname,self.store.countyname,self.store.address],self.store.industryname,@"",@"",timeStr,self.store.average,@"",@"",@"",self.store.bus_license_code,
                     [objDateformat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.store.bus_end_time doubleValue]]],
                     self.store.bus_license,@"",
                     [objDateformat stringFromDate: [NSDate dateWithTimeIntervalSince1970:[self.store.indu_end_time doubleValue]]],
                     self.store.indu_license];
    _contentArry = [[NSMutableArray alloc]initWithArray:arry];
    _contentArry[7] = _store.bannerImage;

    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    _releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_releaseButton setTitle:@"保存" forState:normal];
    _releaseButton.frame = CGRectMake(20,20, 30, 30);
    _releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [_releaseButton addTarget:self action:@selector(modifyInformation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}

- (void)backVC:(NSArray *)imageArry andTag:(int)Tag
{
    
    _contentArry[Tag] = imageArry;
    [self.tableview reloadData];
    
}
- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict
{
    if (Tag == 5) {
        
        _addressIdDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    }
    if (Tag == 6) {
        _stateIdDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    }
    _contentArry[Tag] = contentStr;
    [self.tableview reloadData];
}

- (void)modifyInformation
{
    if (![_contentArry[9] containsString:@"-"] && ![_contentArry[9] containsString:@":"]) {
        [SVProgressHUD showErrorWithStatus:@"营业时间格式不对"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    for (int i = 0; i < _contentArry.count; i++) {
        NSLog(@"%d，== %@", i, _contentArry[i]);
        if ([_contentArry[i] isKindOfClass:[UIImage class]] || [_contentArry[i] isKindOfClass:[NSArray class]] ) {
            
        }
        else if(i != 4 && i != 8 && i !=11 &&  i !=12 && i != 13 && i != 14 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19){
            if([_contentArry[i] isEqualToString:@""] || _contentArry[i] == NULL ) {
            [SVProgressHUD showErrorWithStatus:@"请完善商家信息"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
             }
        }
        if (![_contentArry[9] containsString:@"-"] && ![_contentArry[9] containsString:@":r"]) {
            [SVProgressHUD showErrorWithStatus:@"营业时间格式不对"];
            [SVProgressHUD dismissWithDelay:1.0f];
            return;
        }
    }
    
    [_releaseButton setTitleColor:[UIColor grayColor] forState:0];
    _releaseButton.userInteractionEnabled = NO;
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [SVProgressHUD showWithStatus:@"上传中"];
    [WKPHttpRequest postUpload:UpLoadImg param:NULL uploadImageData:UIImageJPEGRepresentation(_contentArry[0], 0.5) finish:^(NSData *data, NSDictionary *objct, NSError *error) {
        
        if([[objct objectForKey:@"msg"] isEqualToString:@"上传成功"])
        {
            [param setObject:[objct objectForKey:@"file_url"] forKey:@"logo"];
            
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *stringurl = [NSString stringWithFormat:@"%@uploadManyImg%@",WKPhttpHeader,WKPhttpTail];
    manager.requestSerializer.timeoutInterval = 30.0f;
    
    [manager POST:stringurl parameters:NULL constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 多张图片
        NSArray * imaArry = _contentArry[7];
        for (int i = 0; i < imaArry.count; i++) {
//        UIImage *image = imaArry[i];
        NSData *data_image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imaArry[i]]];
        UIImage *image = [UIImage imageWithData:data_image];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@%d.jpg", dateString,i];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"]; //
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD dismiss];
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *footStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * footdata = [footStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *footDict = [NSJSONSerialization JSONObjectWithData:footdata options:NSJSONReadingMutableLeaves error:nil];
        NSString * imgStr;
        if ([[NSString stringWithFormat:@"%@",[footDict objectForKey:@"ret"] ]isEqualToString:@"1"]) {
            NSArray * imageArry =  [[NSArray alloc]initWithArray:[footDict objectForKey:@"imgUrlArr"]];
            imgStr = imageArry[0];
            for (int i = 1; i<imageArry.count; i++) {
                imgStr = [NSString stringWithFormat:@"%@,%@",imgStr,imageArry[i]];
            }
        }
    
     else{
         imgStr = @"";
     }
             [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
             [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
             [param setObject:imgStr forKey:@"banner"];
             [param setObject:_addressIdDict[@"province"] forKey:@"province"];
             [param setObject:_addressIdDict[@"county"] forKey:@"county"];
             [param setObject:_addressIdDict[@"city"] forKey:@"city"];
             [param setObject:_addressIdDict[@"address"] forKey:@"address"];
             [param setObject:_stateIdDict[@"industryid"] forKey:@"industryid"];

        if ([[_addressIdDict allKeys] containsObject:@"street"]) {
            if (![[_addressIdDict objectForKey:@"street"]isEqualToString:@""]) {
                [param setObject:_addressIdDict[@"streetId"] forKey:@"bus_district_id"];
                
            }
        }
             [param setObject:_contentArry[3] forKey:@"mobile"];
             NSArray *array = [_contentArry[9] componentsSeparatedByString:@"-"];
            
             [param setObject:array[0] forKey:@"service_begin_time"];
             [param setObject:array[1] forKey:@"service_end_time"];
            
             [param setObject:_contentArry[10] forKey:@"average"];
             [param setObject:_contentArry[14] forKey:@"bus_license_code"];
             [param setObject:_contentArry[16] forKey:@"bus_license"];
             [param setObject:_contentArry[19] forKey:@"indu_license"];
        //
        id obj=[[NSUserDefaults standardUserDefaults] objectForKey:@"lon"];
        if (obj)
        {
            [param setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"lon"] forKey:@"lon"];
            [param setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"] forKey:@"lat"];
        }

             [WKPHttpRequest post:WKPEditusershop param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"] ]isEqualToString:@"1"]) {
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                        [SVProgressHUD dismissWithDelay:2.0f];
                    [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
                    _releaseButton.userInteractionEnabled = YES;
                    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
                    self.navigationItem.rightBarButtonItem = releaseButtonItem;

                      [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                    [SVProgressHUD dismissWithDelay:2.0f];
                    [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
                    _releaseButton.userInteractionEnabled = YES;
                    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
                    self.navigationItem.rightBarButtonItem = releaseButtonItem;

                }
                 [SVProgressHUD dismiss];
            }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         [SVProgressHUD showWithStatus:@"上传失败"];
         [SVProgressHUD dismissWithDelay:1.0f];
        [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
        _releaseButton.userInteractionEnabled = YES;
        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
        self.navigationItem.rightBarButtonItem = releaseButtonItem;


    }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:[objct objectForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
            [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
            _releaseButton.userInteractionEnabled = YES;
            UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
            self.navigationItem.rightBarButtonItem = releaseButtonItem;

        }
        
    }];

}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    
    if(indexPath.row == 0 || indexPath.row == 7 || indexPath.row == 16 || indexPath.row == 19)
    {
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 30 , 150, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = _titleArry[indexPath.row];
         _headImgView  = [[UIImageView alloc]init];
        if (indexPath.row == 0) {
            _headImgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUpLoadImage)];
            [_headImgView addGestureRecognizer:tapGesturRecognizer];
          
        }
        
         if(indexPath.row == 0 || indexPath.row == 7)
         {
             UIImage * tagImage =  [UIImage imageNamed:@"you"];
             UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - tagImage.size.width,  40 - tagImage.size.height/2, tagImage.size.width, tagImage.size.height)];
             iconImage.image = tagImage;
               _headImgView.frame  = CGRectMake(iconImage.frame.origin.x - 70, 10, 60, 60);
             [cell.contentView addSubview:iconImage];
         }
         else{
             _headImgView.frame  = CGRectMake(SCREEN_WIDTH - 70, 10, 60, 60);
         }
        if ([_contentArry[indexPath.row] isKindOfClass:[UIImage class]]) {
             _headImgView.image =  _contentArry[indexPath.row];
        }
        else if([_contentArry[indexPath.row] isKindOfClass:[NSArray class]]){
            NSArray * arry = [[NSArray alloc]initWithArray:_contentArry[indexPath.row]];
            if (arry.count == 0) {
            }
            else{
            //_headImgView.image =  _contentArry[indexPath.row][0];
                [_headImgView sd_setImageWithURL:_contentArry[indexPath.row][0]];
            }
        }
        else{
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_contentArry[indexPath.row]]];
        if(indexPath.row == 0){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: _contentArry[0]]];
        UIImage *image = [UIImage imageWithData:data];
            if(image)
            {
                        _contentArry[0] = image;
            }

            }
        }
        
        if(indexPath.row == 0){
        _headImgView.layer.cornerRadius=_headImgView.frame.size.width/2;//裁成圆角
        _headImgView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
        _headImgView.layer.borderColor = [WKPColor(239, 239, 239) CGColor ];
        _headImgView.layer.borderWidth = 1.0f;
        }
        [cell.contentView addSubview:titleLbl];
        [cell.contentView addSubview:_headImgView];
        return cell;
    }
    
    if ( indexPath.row == 1 ||  indexPath.row == 2 ||  indexPath.row == 14 ||  indexPath.row == 15 ||  indexPath.row == 18  )
    {
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 200, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = _titleArry[indexPath.row];
        
        UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10  - ( SCREEN_WIDTH - titleLbl.frame.size.width ), 15 , SCREEN_WIDTH - titleLbl.frame.size.width , 20)];
        contentLbl.textAlignment = NSTextAlignmentRight;
        contentLbl.font = [UIFont systemFontOfSize:14 ];
        contentLbl.textColor = [UIColor blackColor];
        contentLbl.text = _contentArry[indexPath.row];

        [cell.contentView addSubview:contentLbl];
        [cell.contentView addSubview:titleLbl];
        return cell;

    }
    if (indexPath.row == 4) {
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 120, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = _titleArry[indexPath.row];
   
        UIImage * contImage =  [UIImage imageNamed:@"erweima"];
        UIImageView * contentImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - contImage.size.width, 25 - contImage.size.height/2, contImage.size.width, contImage.size.height)];
        contentImage.image = contImage;
        [cell.contentView addSubview:titleLbl];
        [cell.contentView addSubview:contentImage];
        return cell;
    }
    if (indexPath.row == 12) {
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 250, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text =  _titleArry[indexPath.row];
        
        UIButton * copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        copyBtn.frame = CGRectMake(SCREEN_WIDTH -  40,15, 30, 20);
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [copyBtn addTarget:self action:@selector(copyText) forControlEvents:UIControlEventTouchUpInside];
        copyBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:1];
        [copyBtn setTitleColor:WKPColor(121, 164, 215) forState:0];
        [cell.contentView addSubview:titleLbl];
        [cell.contentView addSubview:copyBtn];
        return cell;
    }
    if ( indexPath.row == 3 ||  indexPath.row == 5 ||  indexPath.row == 6 ||  indexPath.row == 9 ||  indexPath.row == 10 || indexPath.row == 14 ) {
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 120, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = _titleArry[indexPath.row];
        
        UIImage * tagImage =  [UIImage imageNamed:@"you"];
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - tagImage.size.width, 25 - tagImage.size.height/2, tagImage.size.width, tagImage.size.height)];
        iconImage.image = tagImage;
        
        UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x - 10 - ( SCREEN_WIDTH - titleLbl.frame.size.width ) , 15 , SCREEN_WIDTH - titleLbl.frame.size.width , 20)];
        contentLbl.textAlignment = NSTextAlignmentRight;
        contentLbl.font = [UIFont systemFontOfSize:14 ];
        contentLbl.textColor = [UIColor blackColor];
        contentLbl.text = _contentArry[indexPath.row];
        
        [cell.contentView addSubview:contentLbl];
        [cell.contentView addSubview:titleLbl];
        [cell.contentView addSubview:iconImage];
        return cell;
    }
    cell.backgroundColor = WKPColor(238, 238, 238);
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 7 || indexPath.row == 16 || indexPath.row == 19) {
        return 80;
    }
     if (indexPath.row == 8 || indexPath.row == 11 || indexPath.row == 13 || indexPath.row == 17)
     {
         return 10;
     }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self clickUpLoadImage];
        
    }
    if (indexPath.row == 4) {
        StoreQRCodeViewController * storeQRCodeVC = [[StoreQRCodeViewController alloc]init];
        [self.navigationController pushViewController:storeQRCodeVC animated:YES];
    }
    if (indexPath.row == 3 || indexPath.row == 5  || indexPath.row == 6 || indexPath.row == 9 || indexPath.row == 10) {
        InPutViewController * inPutVC = [[InPutViewController alloc]init];
        if (indexPath.row == 5 ) {
            inPutVC.VCStyle = inputVCWithCityPicker;
            if ([[_addressIdDict allKeys] containsObject:@"street"]) {
                if (![[_addressIdDict objectForKey:@"street"]isEqualToString:@""]) {
                    inPutVC.street = [_addressIdDict objectForKey:@"street"];
                    inPutVC.streetId = [[_addressIdDict objectForKey:@"county"] intValue];
                    
                }
            }
            
        }
        else  if (indexPath.row == 6 ) {
            
            inPutVC.VCStyle = inputVCWithStatePicker;
            
        }
        else  if (indexPath.row == 3 || indexPath.row == 9 || indexPath.row == 10) {
            inPutVC.VCStyle = inputVCWithNomal;
        }
        else
        {
            inPutVC.VCStyle = inputVCWithNomal;
        }
        inPutVC.delegate = self;
        inPutVC.contentStr = _contentArry[indexPath.row];
        inPutVC.title = _titleArry[indexPath.row];
        inPutVC.Tag = (int)(100 + indexPath.row);
        
        [self.navigationController pushViewController:inPutVC animated:YES];
    }

    if (indexPath.row == 7) {
        AddExhibitionPlanViewController * addExhibitionPlanVC = [[AddExhibitionPlanViewController alloc]init];
        addExhibitionPlanVC.delegate = self;
        if ( [_contentArry[indexPath.row] isKindOfClass:[NSArray class]]) {
            addExhibitionPlanVC.getImgArry = _contentArry[indexPath.row];
        }
        addExhibitionPlanVC.Tag = (int)indexPath.row;
        [self.navigationController pushViewController:addExhibitionPlanVC animated:YES];
    }
}

-(void)copyText
{
    [SVProgressHUD showSuccessWithStatus:@"复制成功!"];
    [SVProgressHUD dismissWithDelay:1.0f];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =  [NSString stringWithFormat:@"http://gxhy.vkepai.com/?weikepai/shopdetail&shop_id=%@",self.store.id];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    //self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma 上传图片方法
- (void)clickUpLoadImage
{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 从相册选取
    UIAlertAction * alBum = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.allowCrop = YES;
        imagePickerVc.needCircleCrop = NO;
        
        imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT/2 - SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH);
        // You can get the photos by block, the same as by delegate.
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray* assets,BOOL isSelectOriginalPhoto){
            _contentArry[0] = photos[0];
            [_tableview reloadData];
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    // 从相机选取
    
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
        
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    // 添加到alertVC上
    [alertVC addAction:cancel];
    [alertVC addAction:alBum];
    [alertVC addAction:camera];
    // 显示alertVC
    [self presentViewController:alertVC animated:YES completion:nil];
}

//调用相机
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (iOS8Later) {
                UIApplication *application = [UIApplication sharedApplication];
                [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                
            } else {
                NSURL *privacyUrl;
                //                    privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    UIApplication *application = [UIApplication sharedApplication];
                    [application openURL:privacyUrl options:@{} completionHandler:nil];
                } else {
                    
                    UIAlertController * alertTaps = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    // 添加到alertVC上
                    [alertTaps addAction:cancel];
                    // 显示alertVC
                    [self presentViewController:alertTaps animated:YES completion:nil];
                }
            }
            
        }];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        // 添加到alertVC上
        [alertVC addAction:cancel];
        [alertVC addAction:camera];
        // 显示alertVC
        [self presentViewController:alertVC animated:YES completion:nil];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController * alertPhotosVC = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (iOS8Later) {
                UIApplication *application = [UIApplication sharedApplication];
                [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                
            } else {
                NSURL *privacyUrl;
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    UIApplication *application = [UIApplication sharedApplication];
                    [application openURL:privacyUrl options:@{} completionHandler:nil];
                } else {
       
                    UIAlertController * alertTaps = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    // 添加到alertVC上
                    [alertTaps addAction:cancel];
                    // 显示alertVC
                    [self presentViewController:alertTaps animated:YES completion:nil];
                }
            }
            
        }];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        // 添加到alertVC上
        [alertPhotosVC addAction:cancel];
        [alertPhotosVC addAction:camera];
        // 显示alertVC
        [self presentViewController:alertPhotosVC animated:YES completion:nil];
        
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    //    __weak typeof(self) weakSelf = self;
    //    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
    //        weakSelf.location = location;
    //    } failureBlock:^(NSError *error) {
    //        weakSelf.location = nil;
    //    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

//选择图片
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                _contentArry[0] = cropImage;
                                [_tableview reloadData];
                            }];
                            imagePickerVc.allowCrop = YES;
                            imagePickerVc.needCircleCrop = NO;
                            imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT/2 - SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH);
                            [self presentViewController:imagePickerVc animated:YES completion:nil];
                            
                            
                        }
                    }];
                }];
            }
        }];
    }
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
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
