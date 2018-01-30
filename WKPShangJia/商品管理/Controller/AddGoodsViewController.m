//
//  AddGoodsViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/10.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "YMTextView.h"
#import "WKPButton.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "UIImageView+WebCache.h"
@interface AddGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UILabel * nameLbl;
@property(nonatomic,strong)YMTextView * describeText;
@property(nonatomic,strong)YMTextView * titleText;
@property(nonatomic,strong)YMTextView * priceText;
@property(nonatomic,strong)WKPButton * headBtn;
@property(nonatomic,strong)UIButton * imgBtn;
@property(nonatomic,strong)UIView * headView;
@property(strong, nonatomic) CLLocation *location;
@property(strong,nonatomic)UIImage * headImage;
@property(nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加商品";
    [self setUpUI];
    if (self.goodsInformation != NULL) {
    [self getData];
    }
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        if (is_IPhone_X) {
            make.bottom.equalTo(self.view).offset(-83);
        }else {
            make.bottom.equalTo(self.view).offset(-40);
        }
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    _imgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _imgBtn.backgroundColor = WKPColor(238, 238, 238);
    _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    [_imgBtn addTarget:self action:@selector(clickUpLoadImage:) forControlEvents:UIControlEventTouchUpInside];

    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    _headBtn = [WKPButton buttonWithType:UIButtonTypeCustom];
    _headBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 80, 20, 160, 80);
    [_headBtn setTitle:@"添加商品图片" forState:UIControlStateNormal];
    [_headBtn addTarget:self action:@selector(clickUpLoadImage:) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_headBtn setTitleColor:[UIColor blackColor] forState:0];
    [_headBtn setImage: [UIImage imageNamed:@"tianjiashangpin"] forState:0];
    [_headView addSubview:_imgBtn];
    [_headView addSubview:_headBtn];
 
    
    _tableview.tableHeaderView = _headView;
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = WKPColor(238, 238, 238);
    _tableview.tableFooterView = footerView;
    UIButton * btn = [[UIButton alloc] init];//WithFrame:CGRectMake(0, self.view.frame.size.height - 104, SCREEN_WIDTH, 40)];
    if (is_IPhone_X) {
    btn.frame = CGRectMake(0, self.view.frame.size.height - 171, SCREEN_WIDTH, 83);
    }else {
    btn.frame = CGRectMake(0, self.view.frame.size.height - 104, SCREEN_WIDTH, 40);
    }
    //btn.frame = CGRectMake(0, self.view.frame.size.height - 40, SCREEN_WIDTH, 40);
    if (self.goodsInformation != NULL) {
    [btn setTitle:@"确定修改" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(modifyGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
    [btn setTitle:@"立即发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:1];
    btn.backgroundColor = [UIColor redColor];
   // [btn setTitleColor:[UIColor whiteColor] forState:0];
    
    [self.view addSubview:btn];
    
}

- (void)getData
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.goodsInformation.image]];
    UIImage *image = [UIImage imageWithData:data];
    if ( image.size.height <140) {
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140) ;
        _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    }
    else if ( image.size.height >SCREEN_WIDTH) {
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) ;
        _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    }
    else{
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height) ;
        _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height);
        
    }
    _headImage = image;
    [_headBtn removeFromSuperview];
    [_imgBtn setImage:image forState:0];
    _tableview.tableHeaderView = _headView;

}



#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    UILabel * tagLbl  = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 , 40, 20)];
    tagLbl.textAlignment = NSTextAlignmentLeft;
    tagLbl.font = [UIFont systemFontOfSize:14 ];
    tagLbl.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        tagLbl.text = @"标题";
        _titleText = [[YMTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tagLbl.frame), 3, SCREEN_WIDTH-CGRectGetMaxX(tagLbl.frame), 36)];
        NSLog(@"%f",_titleText.frame.origin.y);
        _titleText.placeholder = @"请填写商品标题";
        _titleText.text = self.goodsInformation.title;
        _titleText.delegate  = self;
        _titleText.textColor = [UIColor blackColor];
        _titleText.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:tagLbl];
        [cell.contentView addSubview:_titleText];
        return cell;
    }
    if (indexPath.row == 2 ) {
        tagLbl.text = @"描述";
        _describeText = [[YMTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tagLbl.frame), 3, SCREEN_WIDTH-CGRectGetMaxX(tagLbl.frame), 77)];
        _describeText.placeholder = @"请填写商品描述(选填)";
        _describeText.delegate  = self;
        _describeText.text = self.goodsInformation.introduce;
        _describeText.textColor = [UIColor blackColor];
        _describeText.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:tagLbl];
        [cell.contentView addSubview:_describeText];
        return cell;
    }
    if (indexPath.row == 4 ) {
        tagLbl.text = @"价格";
        _priceText = [[YMTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tagLbl.frame), 3, SCREEN_WIDTH-CGRectGetMaxX(tagLbl.frame), 36)];
        _priceText.placeholder = @"请填写商品价格(选填)";
        _priceText.text = self.goodsInformation.price;
        _priceText.keyboardType =  UIKeyboardTypeDecimalPad;
        _priceText.delegate  = self;
        _priceText.textColor = [UIColor blackColor];
        _priceText.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:tagLbl];
        [cell.contentView addSubview:_priceText];
        return cell;
    }
    cell.backgroundColor = WKPColor(238, 238, 238);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 4) {
        return 40;
    }
    if (indexPath.row == 1) {
        return 2;
    }
    if (indexPath.row == 3) {
        return 10;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
}



//修改商品
- (void)modifyGoods
{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [WKPHttpRequest postUpload:UpLoadImg param:NULL uploadImageData:UIImageJPEGRepresentation(_headImage, 0.5) finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        [SVProgressHUD showWithStatus:@"上传中"];
        if([[obj objectForKey:@"msg"] isEqualToString:@"上传成功"])
        {
            [param setObject:[obj objectForKey:@"file_url"] forKey:@"image"];
        }
        [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
        [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
        [param setObject:_titleText.text forKey:@"title"];
        [param setObject:_priceText.text forKey:@"price"];
        [param setObject:_describeText.text forKey:@"introduce"];
        [param setObject:self.goodsInformation.id forKey:@"productid"];
        [WKPHttpRequest post:EditShopProduct param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            
            [SVProgressHUD dismiss];
            if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
                [SVProgressHUD showSuccessWithStatus :[obj objectForKey:@"msg"]];
                 [SVProgressHUD dismissWithDelay:1.0f];
                [self.delegate backToGoodsManage];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                 [SVProgressHUD dismissWithDelay:1.0f];
            }
           
        }];
        
    }];
    
}

//添加商品
- (void)addGoods
{
    if (!_headImage) {
        [SVProgressHUD showErrorWithStatus:@"请选择图片"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }else if ((_titleText.text == nil) || ([_titleText.text  isEqualToString: @""])) {
        [SVProgressHUD showErrorWithStatus:@"请填写标题"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }else if ((_describeText.text == nil) || ([_describeText.text  isEqualToString: @""])) {
        [SVProgressHUD showErrorWithStatus:@"请填写描述内容"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }else if ((_priceText.text == nil) || ([_priceText.text  isEqualToString: @""])) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品价格"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
        
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [WKPHttpRequest postUpload:UpLoadImg param:NULL uploadImageData:UIImageJPEGRepresentation(_headImage, 0.5) finish:^(NSData *data, NSDictionary *obj, NSError *error) {
          [SVProgressHUD showWithStatus:@"上传中"];
        if([[obj objectForKey:@"msg"] isEqualToString:@"上传成功"])
        {
            [param setObject:[obj objectForKey:@"file_url"] forKey:@"image"];
        }
        [param setObject:[defaults objectForKey:@"mid"] forKey:@"mid"];
        [param setObject:[defaults objectForKey:@"shopid"] forKey:@"shopid"];
        [param setObject:_titleText.text forKey:@"title"];
        [param setObject:_priceText.text forKey:@"price"];
        [param setObject:_describeText.text forKey:@"introduce"];
        [WKPHttpRequest post:AddShopProduct param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            
            [SVProgressHUD dismiss];
           if([[NSString stringWithFormat:@"%@",[obj objectForKey:@"ret"]] isEqualToString:@"1"]){
                [SVProgressHUD showSuccessWithStatus :[obj objectForKey:@"msg"]];
               [SVProgressHUD dismissWithDelay:1.0f];
                [self.delegate backToGoodsManage];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[obj objectForKey:@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
            }
            
        }];
        
    }];

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
            if (photos[0].size.height <140) {
                _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140) ;
                _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
            }
            else if (photos[0].size.height >SCREEN_WIDTH) {
                _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) ;
                _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
            }
           else{
            _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, photos[0].size.height) ;
            _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, photos[0].size.height);
            }
                _tableview.tableHeaderView = _headView;
                [_headBtn removeFromSuperview];
                 _headImage =photos[0];
                [_imgBtn setImage:photos[0] forState:0];
            
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
                        
                            if (image.size.height <140) {
                                _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140) ;
                                _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
                            }
                            else if (image.size.height >SCREEN_WIDTH) {
                                _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) ;
                                _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
                            }
                            else{
                                _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height) ;
                                _imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height);
                            }
                                _tableview.tableHeaderView = _headView;
                                [_headBtn removeFromSuperview];
                                _headImage = image;
                                [_imgBtn setImage:image forState:0];
                            
                            
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
