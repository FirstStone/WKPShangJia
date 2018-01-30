//
//  AddExhibitionPlanViewController.h
//  WKPShangJia
//
//  Created by JIN CHAO on 2017/8/15.
//  Copyright © 2017年 com.ichuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddExhibitionPlanViewControllerDelegate <NSObject>
- (void)backVC:(NSArray *)imageArry andTag:(int)Tag ;
@end
@interface AddExhibitionPlanViewController : UIViewController
@property(nonatomic,assign)int Tag;
@property(nonatomic,strong)NSMutableArray * getImgArry;
@property (nonatomic, weak) id<AddExhibitionPlanViewControllerDelegate> delegate;
@end
