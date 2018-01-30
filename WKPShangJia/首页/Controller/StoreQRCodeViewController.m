//
//  StoreQRCodeViewController.m
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/11/11.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "StoreQRCodeViewController.h"

#import "UIImageView+WebCache.h"
@interface StoreQRCodeViewController ()
@property(nonatomic,strong)UIImageView * imageView;
@end

@implementation StoreQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"二维码";
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 -  100, 100, 200,200 )];
 
    [self.view addSubview:_imageView];
    [self getData];
}

-(void)getData
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mid"] forKey:@"mid"];
  [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"] forKey:@"shopid"];
    [WKPHttpRequest post:WKPGetusershopqr param:param finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"qr"]]];
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
