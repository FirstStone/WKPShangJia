//
//  AddExhibitionPlanViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/15.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "AddExhibitionPlanViewController.h"
#import "TZImagePickerController.h"
#import <PYPhotoBrowser.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
@interface AddExhibitionPlanViewController ()<TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * imgArry;
@property(strong, nonatomic) CLLocation *location;
@property(nonatomic, strong) UIImagePickerController *imagePickerVc;
@property(nonatomic, strong)PYPhotosView * photosView;

@end

@implementation AddExhibitionPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家展示图";
    self.view.backgroundColor = [UIColor whiteColor];
     [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)setUpUI
{
    
    if ([self.getImgArry isKindOfClass:[NSArray class]]) {
        _imgArry = [[NSMutableArray alloc]initWithArray:self.getImgArry];
    }
    else{
    _imgArry = [[NSMutableArray alloc]init];
    }
    _tableview = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = WKPColor(238, 238, 238);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 10, 20)];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = [UIColor blackColor];
    lbl.text = @"展示图";
    [headerView addSubview:lbl];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableview.tableHeaderView = headerView;
    _tableview.tableFooterView = [self tableviewFooterView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUpLoadImage) name:PYAddImageDidClickedNotification object:nil];
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"保存" forState:normal];
    releaseButton.frame = CGRectMake(20,20, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor blackColor] forState:0];
    [releaseButton addTarget:self action:@selector(onClickedOKbtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}


-(void)onClickedOKbtn
{
    if (_photosView.images.count == 0) {
        
    }
    [self.delegate backVC:_photosView.images andTag:self.Tag];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableviewFooterView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    _photosView = [PYPhotosView photosViewWithImages:_imgArry];
    _photosView.imagesMaxCountWhenWillCompose = _imgArry.count+1;
    _photosView.photoWidth = SCREEN_WIDTH - 20;
    _photosView.photoHeight = SCREEN_WIDTH * 0.5 - 10;
    _photosView.photosMaxCol = 1;
    _photosView.layoutType = PYPhotosViewLayoutTypeFlow;
    _photosView.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, _photosView.frame.size.height);
    [footerView addSubview:_photosView];
    CGRect temp = footerView.frame;
    temp.size = CGSizeMake(SCREEN_WIDTH, _photosView.frame.size.height + 20);
    footerView.frame = temp ;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT/2 - SCREEN_WIDTH/4, SCREEN_WIDTH, SCREEN_WIDTH/2);
        // You can get the photos by block, the same as by delegate.
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray* assets,BOOL isSelectOriginalPhoto){
            for (int i = 0 ; i<photos.count; i++) {
                [_imgArry addObject:photos[i]];
            }
            _tableview.tableFooterView = [self tableviewFooterView];
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
                            assetModel = [models lastObject];
                            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [_imgArry addObject:image];
                                _tableview.tableFooterView = [self tableviewFooterView];
                            }];
                            imagePickerVc.allowCrop = YES;
                            imagePickerVc.needCircleCrop = NO;
                            imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT/2 - SCREEN_WIDTH/4, SCREEN_WIDTH, SCREEN_WIDTH/2);
                            [self presentViewController:imagePickerVc animated:YES completion:nil];
   
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
