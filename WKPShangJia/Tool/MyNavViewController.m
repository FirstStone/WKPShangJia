//
//  MyNavViewController.m
//  WeKePai
//
//  Created by JIN CHAO on 2017/8/7.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import "MyNavViewController.h"
#import "ZYYBtn.h"
#define iOS7 \
([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
@interface MyNavViewController ()

@end

@implementation MyNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 重载父类进行改写
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //先进入子Controller
    [super pushViewController:viewController animated:animated];
    
    //替换掉leftBarButtonItem
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self customLeftBackButton];
    }
}

#pragma mark - 自定义返回按钮图片
- (UIBarButtonItem*)customLeftBackButton{
    
    UIImage *image = [UIImage imageNamed:@"zuojiantou"];
    
    ZYYBtn *backButton = [ZYYBtn buttonWithType:UIButtonTypeCustom];
    
    backButton.frame = CGRectMake(0, 0, 44,44);
    backButton.btnStyle = imagePullOverLeft;
    [backButton setImage:image
                          forState:UIControlStateNormal];
    
    [backButton addTarget:self
                   action:@selector(popself)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    return backItem;
}

#pragma mark - 返回按钮事件(pop)
-(void)popself
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - 用图片设置导航背景
+ (void)initialize
{
    //取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //设置导航栏的背景图片
    NSString *navBarBg = nil;
    if (iOS7)
    {
        navBarBg = @"NavBar64";
        navBar.tintColor = [UIColor blackColor];
    }
    else
    {
        navBarBg = @"NavBar";
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    
    //标题颜色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
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
