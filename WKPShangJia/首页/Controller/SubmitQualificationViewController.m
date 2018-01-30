//
//  SubmitQualificationViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/18.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "SubmitQualificationViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "InPutViewController.h"
#import "SubmitSuccessViewController.h"
@interface SubmitQualificationViewController ()<TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,InPutViewControllerDelegate>

@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)NSArray * titleArry;
@property(nonatomic,strong)UIImageView * headImageView;
@property(nonatomic,strong)NSArray * contentArry;
@property(nonatomic,strong)UIButton * zhizhaoBtn;
@property(nonatomic,strong)UIButton * zizhiBtn;
@property(nonatomic,strong)NSMutableArray * contenArry;
@property(nonatomic,strong)NSMutableArray * imageArry;
@property(nonatomic,strong)UIImagePickerController * picker1;
@property(strong, nonatomic) CLLocation *location;
@property(nonatomic,assign)int tag;
@property(nonatomic, strong) UIImagePickerController *imagePickerVc;
@property(nonatomic,strong)NSMutableDictionary * stateIdDict;
@property(nonatomic,strong)NSMutableDictionary * addressIdDict;
@property(nonatomic,strong)UIButton * releaseButton;
@property(nonatomic,assign)int imageNum;
@end

@implementation SubmitQualificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交资质";
    _imageNum =0;
    [self setUpUI];
    if (self.registerMid) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.registerMid forKey:@"mid"];
    }

    _tag = 0;
    _contenArry = [[NSMutableArray alloc]initWithArray:@[@"请填写",@"请填写",@"请填写",@"请填写",@"",@"请填写",@"请填写",@"",@"",@"请填写"]];
    _imageArry = [[NSMutableArray alloc]initWithArray:@[[UIImage imageNamed:@"shangchuanzhizhao"],[UIImage imageNamed:@"shangchuanzizhi"]]];
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    _titleArry = @[@"店铺名称",@"商家电话",@"商家地址",@"所属分类",@"",@"营业执照编号",@"营业执照结束时间",@"营业执照照片",@"",@"行业资质证结束时间",@"行业资质证照片"];
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
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    _releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_releaseButton setTitle:@"提交" forState:normal];
    _releaseButton.frame = CGRectMake(20,20, 30, 30);
    _releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [_releaseButton addTarget:self action:@selector(sumMitQualification) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}


#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    if (indexPath.row == 4  || indexPath.row == 8) {
        cell.backgroundColor  = WKPColor(238, 238, 238);
        return cell;
    }
        UILabel * titleLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 , 140, 20)];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.font = [UIFont systemFontOfSize:14 ];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = _titleArry[indexPath.row];
        [cell.contentView addSubview:titleLbl];
    
        if (indexPath.row == 7) {
       _zhizhaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zhizhaoBtn.frame = CGRectMake(10,CGRectGetMaxY(titleLbl.frame)+10, SCREEN_WIDTH - 20, 220);
        [_zhizhaoBtn setImage:_imageArry[0] forState:0];
        [_zhizhaoBtn addTarget:self action:@selector(clickUpLoadImage:) forControlEvents:UIControlEventTouchUpInside];
        _zhizhaoBtn.tag = 1000;
        [cell.contentView addSubview:_zhizhaoBtn];
        return cell;
    }
    if (indexPath.row == 10) {
        _zizhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zizhiBtn.frame = CGRectMake(10,CGRectGetMaxY(titleLbl.frame)+10, SCREEN_WIDTH - 20, 220);
        [_zizhiBtn setImage:_imageArry[1] forState:0];
        [_zizhiBtn addTarget:self action:@selector(clickUpLoadImage:) forControlEvents:UIControlEventTouchUpInside];
        _zizhiBtn.tag = 1001;
        [cell.contentView addSubview:_zizhiBtn];
          return cell;
    }
    UIImage * tagImage =  [UIImage imageNamed:@"you"];
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - tagImage.size.width, 25 - tagImage.size.height/2, tagImage.size.width, tagImage.size.height)];
    iconImage.image = tagImage;
    
  
    UILabel * contentLbl  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLbl.frame), 15 , SCREEN_WIDTH - titleLbl.frame.size.width - iconImage.frame.size.width - 30, 20)];
    contentLbl.textAlignment = NSTextAlignmentRight;
    contentLbl.font = [UIFont systemFontOfSize:14 ];
    contentLbl.textColor = [UIColor blackColor];
    contentLbl.text = _contenArry[indexPath.row];
    [cell.contentView addSubview:iconImage];
    [cell.contentView addSubview:contentLbl];
      return cell;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4 || indexPath.row == 8)
    {
        return 10;
    }
    if(indexPath.row == 7 || indexPath.row == 10)
    {
        return 270;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0 || indexPath.row == 1  || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 9) {
        InPutViewController * inPutVC = [[InPutViewController alloc]init];
        if (indexPath.row == 2 ) {
            inPutVC.VCStyle = inputVCWithCityPicker;
            if ([[_addressIdDict allKeys] containsObject:@"street"]) {
                if (![[_addressIdDict objectForKey:@"street"]isEqualToString:@""]) {
                    inPutVC.street = [_addressIdDict objectForKey:@"street"];
                    inPutVC.streetId = [[_addressIdDict objectForKey:@"county"] intValue];

                }
            }
        }
         else  if (indexPath.row == 3 ) {
            
            inPutVC.VCStyle = inputVCWithStatePicker;
            
        }
         else  if (indexPath.row == 6 || indexPath.row == 9) {
            inPutVC.VCStyle = inputVCWithDataPicker;
        }
        else
        {
            inPutVC.VCStyle = inputVCWithNomal;
        }
        inPutVC.delegate = self;
        inPutVC.contentStr = _contenArry[indexPath.row];
        inPutVC.title = _titleArry[indexPath.row];
        inPutVC.Tag = (int)(100 + indexPath.row);
        
        [self.navigationController pushViewController:inPutVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma 上传图片方法
- (void)clickUpLoadImage:(UIButton *)button
{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 从相册选取
    UIAlertAction * alBum = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.isStatusBarDefault = YES;
        imagePickerVc.showSelectBtn = NO;
        // You can get the photos by block, the same as by delegate.
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray* assets,BOOL isSelectOriginalPhoto){
            if (button.tag == 1000) {
                _imageArry[0]  = photos[0];
                _imageNum++;
                [_zhizhaoBtn setImage:photos[0] forState:0];
            }
            else{
                _imageNum++;
                _imageArry[1]  = photos[0];
            [_zizhiBtn setImage:photos[0] forState:0];
            }
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    // 从相机选取
    
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (button.tag == 1000) {
            _tag = 1000;
        }
        else{
          _tag = 1001;
        }
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
                            if (_tag == 1000) {
                                _imageArry[0]  = image;
                                _imageNum++;
                                [_zhizhaoBtn setImage:image forState:0];
                            }
                            else{
                                _imageNum++;
                                [_zizhiBtn setImage:image forState:0];
                            }

                        }
//                        if (self.allowCropSwitch.isOn) { // 允许裁剪,去裁剪
//                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
//                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
//                            }];
//                            imagePicker.needCircleCrop = self.needCircleCropSwitch.isOn;
//                            imagePicker.circleCropRadius = 100;
//                            [self presentViewController:imagePicker animated:YES completion:nil];
//                        } else {
//                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
//                        }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)backVC:(NSString *)contentStr andTag:(int)Tag andDict:(NSDictionary *)dict
{
    if (Tag == 2) {
        
        _addressIdDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    }
    if (Tag == 3) {
        _stateIdDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    }
    _contenArry[Tag] = contentStr;
    [self.tableview reloadData];
}


- (void)sumMitQualification
{
    if ([_contenArry[0] isEqualToString:@"请填写"] || [_contenArry[1] isEqualToString:@"请填写"] || [_contenArry[2] isEqualToString:@"请填写"] || [_contenArry[3] isEqualToString:@"请填写"]) {
        [SVProgressHUD showErrorWithStatus:@"请完善商家资质"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
       NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
       [_releaseButton setTitleColor:[UIColor grayColor] forState:0];
      _releaseButton.userInteractionEnabled = NO;
      UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
      self.navigationItem.rightBarButtonItem = releaseButtonItem;

        [WKPHttpRequest postUpload:UpLoadImg param:NULL uploadImageData:UIImageJPEGRepresentation(_imageArry[0], 0.5) finish:^(NSData *data, NSDictionary *objct, NSError *error) {
            
            if([[objct objectForKey:@"msg"] isEqualToString:@"上传成功"])
            {
                [SVProgressHUD showWithStatus:@"上传中"];
                [param setObject:[objct objectForKey:@"file_url"] forKey:@"bus_license"];
            }
            [WKPHttpRequest postUpload:UpLoadImg param:NULL uploadImageData:UIImageJPEGRepresentation(_imageArry[1], 0.5) finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                [SVProgressHUD dismiss];
                if([[obj objectForKey:@"msg"] isEqualToString:@"上传成功"])
                {
                 
                    [param setObject:[obj objectForKey:@"file_url"] forKey:@"bus_license"];
                }
                
                [param setObject:[obj objectForKey:@"file_url"] forKey:@"indu_license"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (self.registerMid) {
                    [param setObject:self.registerMid forKey:@"mid"];
                }
                else
                {
                [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
                }
                [param setObject:_contenArry[0] forKey:@"title"];
                [param setObject:_contenArry[1] forKey:@"mobile"];
                
                if([[_addressIdDict allKeys] containsObject:@"province"] && [[_addressIdDict allKeys] containsObject:@"address"])
                {
                [param setObject:_addressIdDict[@"province"] forKey:@"province"];
                [param setObject:_addressIdDict[@"county"] forKey:@"county"];
                [param setObject:_addressIdDict[@"city"] forKey:@"city"];
                [param setObject:_addressIdDict[@"address"] forKey:@"address"];
                }
                if ([[_addressIdDict allKeys] containsObject:@"street"]) {
                    if (![[_addressIdDict objectForKey:@"street"]isEqualToString:@""]) {
                    [param setObject:_addressIdDict[@"streetId"] forKey:@"bus_district_id"];
                        
                    }
                }

                if([[_stateIdDict allKeys] containsObject:@"industryid"] )
                {
                [param setObject:_stateIdDict[@"industryid"] forKey:@"industryid"];
                }
                [param setObject:_contenArry[5] forKey:@"bus_license_code"];
                [param setObject:_contenArry[6] forKey:@"bus_end_time"];
                [param setObject:_contenArry[9] forKey:@"indu_end_time"];
                
                [WKPHttpRequest post:AddNewShop param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                    
                    [SVProgressHUD dismiss];
                    if ([[obj objectForKey:@"msg"] isEqualToString:@"参数错误"]) {
                        [SVProgressHUD showErrorWithStatus:@"请完善资质信息"];
                        [SVProgressHUD dismissWithDelay:1.0f];
                        [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
                        _releaseButton.userInteractionEnabled = YES;
                        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
                        self.navigationItem.rightBarButtonItem = releaseButtonItem;
                    }
                    else if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
                          [SVProgressHUD showSuccessWithStatus :[obj objectForKey:@"msg"]];
                        [SVProgressHUD dismissWithDelay:1.0f];
                        SubmitSuccessViewController * submitSuccessVC = [[SubmitSuccessViewController alloc]init];
                        [self.navigationController pushViewController:submitSuccessVC animated:YES];
                        [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
                        _releaseButton.userInteractionEnabled = YES;
                        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
                        self.navigationItem.rightBarButtonItem = releaseButtonItem;
                    }
                    else{
                    [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                        [SVProgressHUD dismissWithDelay:1.0f];
                        [_releaseButton setTitleColor:[UIColor blackColor] forState:0];
                        _releaseButton.userInteractionEnabled = YES;
                        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_releaseButton];
                        self.navigationItem.rightBarButtonItem = releaseButtonItem;
                    }
                   
                }];

            }];
        }];
    

    
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
