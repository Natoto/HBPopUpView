//
//  HBAlertViewController.m
//  LQPopUpViewDemo
//
//  Created by boob on 2018/1/9.
//  Copyright © 2018年 liqian. All rights reserved.
//

#import "HBAlertViewController.h"
#import "UIAlertController+SODA.h"
#import "UIView+SODAViewController.h"
#import "YYActionSheetViewController.h"
#import "TBActionSheet.h"

@interface HBAlertViewController ()<TBActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *sectionControl;

@end

@implementation HBAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)first:(id)sender {
    
    if (0 == self.sectionControl.selectedSegmentIndex) {
       UIAlertController * ctr = [UIAlertController actionSheetWithTitle:@"请选择" message:@"请选出您的操作" cancelTitle:@"取消" destructiveTitle:@"退出" otherTitles:@[@"再看看",@"确定"] actionBlock:^(UIAlertAction *action, int index) {
            NSLog(@"%d",index);
        }];
        [[self.view currentViewController] presentViewController:ctr animated:YES completion:nil];
    }
    else if (1 == self.sectionControl.selectedSegmentIndex){
        YYActionSheetViewController * ctr = [YYActionSheetViewController new];
        
        [ctr addTitleText:@"提示"];
        
        [ctr addButtonWithTitle:@"退出" block:^(YYActionSheetViewController *controller) {
            
        }];
        
        [ctr show];
//        [[self.view currentViewController] presentViewController:ctr animated:YES completion:nil];
    }
    else if (2 == self.sectionControl.selectedSegmentIndex){
        
       TBActionSheet * actionSheet = [[TBActionSheet alloc] initWithTitle:@"MagicalActionSheet" message:@"巴拉巴拉小魔仙，变！" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"销毁" otherButtonTitles:nil];
        [TBActionSheet appearance].rectCornerRadius = 0;
        [TBActionSheet appearance].destructiveButtonColor = [UIColor colorWithRed:0xfd/(float)0xff green:0x3d/(float)0xff blue:0x66/(float)0xff alpha:1];
        [TBActionSheet appearance].sheetWidth = [UIScreen mainScreen].bounds.size.width;
        [TBActionSheet appearance].ambientColor = [UIColor whiteColor];
        [TBActionSheet appearance].offsetY = 0;
        YYActionSheetViewController * ctr = [YYActionSheetViewController new];
        [self presentViewController:ctr animated:YES completion:^{
            [actionSheet show];
        }];
    }
}

#pragma mark - TBActionSheetDelegate

- (void)actionSheet:(TBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click button:%ld",(long)buttonIndex);
}

- (void)actionSheet:(TBActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismiss");
}

- (void)actionSheet:(TBActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismiss");
}
- (IBAction)second:(id)sender {
    
    
    UIViewController * ctr = [UIViewController alertWithTitle:@"请选择" message:@"请选出您的操作，请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作请选出您的操作" cancelTitle:@"取消" destructiveTitle:@"退出" otherTitles:@[] actionBlock:^(UIAlertAction *action, int index) {
        NSLog(@"%d",index);
    }];
    [self presentViewController:ctr animated:YES completion:nil];
}
- (IBAction)third:(id)sender {
    
}
- (IBAction)textfiledtap:(id)sender {
    
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
