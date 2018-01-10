//
//  YYActionSheetViewController.m
//  YYMobile
//
//  Created by yangmengjun on 15/5/14.
//  Copyright (c) 2015年 YY.inc. All rights reserved.
//

#import "YYActionSheetViewController.h"
#import "SODAAlertView.h"
#import <objc/runtime.h>

const static float kCornerRadius = 0;
const static float kButtonGap    = 6;

NSString *const YYActionSheetDismissAllSheetsNotification = @"YYActionSheetDismissAllSheetsNotification";
NSString *const YYActionSheetAnimatedKey = @"YYActionSheetAnimatedKey";



static float kButtonHeight = 48;
static NSString *kCellIdentifier = @"YYActionSheetViewCell";

static float    defaultTitltFontSize = 12.0;
static NSString *defualtTitltColor  = @"#BBBBBB";

static float    defaultFontSize = 16.0;
static NSString *defaultFontColor   = @"#000000";
static NSString *defaultCancelColor = @"#FF4F4F";
static NSString *defaultBgColor     = @"#FFFFFF";
static float    titleTopGap     = 16;
static float    titleLeftGap    = 18;

@interface YYActionSheetViewController ()
//<UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) SODAAlertView * alertView;
@end

@implementation YYActionSheetViewController

-(void)dealloc{
    NSLog(@"%s",__func__);
}

//WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initData];
        
        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.transitioningDelegate = self;
        
    }
    
    return self;
}

- (void)initData{
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
//{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0)
//{
//    UIInterfaceOrientation or = [[UIApplication sharedApplication] statusBarOrientation];
//    return or;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
}

-(SODAAlertView *)alertView{
    if (!_alertView) {
        SODAAlertView *popUpView = [[SODAAlertView alloc] initWithTitle:@"提示" message:nil];
        _alertView = popUpView; 
        popUpView.btnStyleCancelTextColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
        popUpView.btnStyleDefaultTextColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
        popUpView.btnStyleDestructiveTextColor = [UIColor colorWithRed:0xfd/(float)0xff green:0x3d/(float)0xff blue:0x66/(float)0xff alpha:1];
        __weak typeof(self) wself = self;
        _alertView.dismissAction = ^(void){
            [wself dismiss];
        };
    }
    return _alertView;

}

- (BOOL)isIphoneX{
    CGFloat min = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    CGFloat max = MAX(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    if (min == 375.f && max == 812.f) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _disableDefaultCancel ? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kButtonHeight;
}


#pragma mark - UIViewControllerAnimated
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return self;
//}
//
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    return self;
//}

//-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    return 0.25;
//}
//
//-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView* con = [transitionContext containerView];
//    UIView* v1 = vc1.view;
//    UIView* v2 = vc2.view;
//
//}

#pragma mark - public method
- (void)addTitleText:(NSString *)title;
{
    [self addTitleText:title attribute:nil];
}

- (void)addTitleText:(NSString *)title attribute:(NSDictionary *)attribute
{
    
}

- (void)addTitleView:(UIView *)view
{
}

- (void)addButtonWithView:(UIView *)view block:(YYActionSheetViewControllerButtonBlock)block
{
    
}

- (void)addButtonWithTitle:(NSString *)title block:(YYActionSheetViewControllerButtonBlock) block
{
    [self addButtonWithTitle:title block:block attribute:nil];
}

- (void)addButtonWithTitle:(NSString *)title block:(YYActionSheetViewControllerButtonBlock)block attribute:(NSDictionary *)attribute
{
    [self.alertView addBtnWithTitle:title type:SODAAlertBtnStyleDefault handler:^{
        block(self);
    }];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title block:(YYActionSheetViewControllerButtonBlock)block
{
    [self.alertView addBtnWithTitle:title type:SODAAlertBtnStyleDestructive handler:^{
        block(self);
    }];
}

- (void)show
{
    [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated
{
    [self.alertView addBtnWithTitle:@"取消" type:SODAAlertBtnStyleCancel handler:^{
        
    }];
    UIViewController * ctr = [UIApplication sharedApplication].delegate.window.rootViewController;
    [ctr presentViewController:self animated:NO completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.alertView showInView:self.view preferredStyle:SODAAlertViewStyleActionSheet];
        });
    }];
}

- (void)subscribeForDismissNotification
{
    
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:self.dismissAction];
}


- (IBAction)onBackgroundTap:(id)sender {
    [self dismiss];
}

- (void)updateTitle:(NSString*)oldTitle toNewTitle:(NSString*)newTitle
{
    self.alertView.titleLabel.text = newTitle;
}

@end

@implementation UIViewController(soda)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(presentViewController:animated:completion:) withAnotherSelector:@selector(tb_presentViewController:animated:completion:)];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector withAnotherSelector:(SEL)swizzledSelector
{
    Class aClass = [self class];
    
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Method Swizzling

- (void)tb_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([viewControllerToPresent isKindOfClass:[YYActionSheetViewController class]]) {
        completion();
    }
    else{
        [self tb_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end
