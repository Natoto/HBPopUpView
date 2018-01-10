//
//  UIAlertController+SODA.m
//  BaseUI
//
//  Created by boob on 2018/1/4.
//

#import <objc/runtime.h>
#import "UIAlertController+SODA.h"
#import "SODAAlertView.h"
#import "UIView+SODAViewController.h"

@interface SODAAlertViewController()
@property (nonatomic, strong) SODAAlertView * popUpView;
@property (nonatomic, assign) SODAAlertViewStyle alertStyle;
@end

typedef void (^sodaalertcallback)(id weakSelf, id arg);
@interface NSObject (SODABlockSEL)
/**
 用block来代替selector
 */
- (SEL)sodaalert_selectorBlock:(void (^)(id target, id arg))block ;

@end


@implementation SODAAlertViewController


//static int tag_soda_alertview = 0xcccc;

/**
 * 设置详情label，附带可点击文字，回调点击事件
 */
-(void)soda_setMessageTitle:(NSString *)message clickMessage:(NSString *)clickMessage touchBlock:(void(^)(void))touckBlock{
    
    NSString * str = [NSString stringWithFormat:@"%@%@",message,clickMessage];
    SODAAlertViewController * ctr = self;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0x19/(float)0xff green:0xbb/(float)0xff blue:0xf1/(float)0xff alpha:1] range:[str rangeOfString:clickMessage]];
    [ctr soda_setAttributedMessage:title];
    UILabel * msglabel = [ctr soda_getMessageLabel];
    __weak typeof(UIViewController) * wctr = ctr;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:[self sodaalert_selectorBlock:^(id weakSelf, id arg) {
        if(touckBlock) touckBlock();
        [wctr dismissViewControllerAnimated:NO completion:nil];
    }]];
    msglabel.userInteractionEnabled = YES;
    [msglabel addGestureRecognizer:tap];
}

/**
 * 获得标题的label
 */
-(UILabel *)soda_getTitleLabel{
    @try {
        SODAAlertView * alert = self.popUpView;//[self.view viewWithTag:tag_soda_alertview];
        UILabel * msglabel =  [alert titleLabel];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msglabelTap:)];
        return msglabel;
    }@catch(NSException * ex){
        return nil;
    }@finally{
        
    };
}

/**
 * 获得message label 用于点击
 */
-(UILabel *)soda_getMessageLabel{
    @try {
        SODAAlertView * alert = self.popUpView; //[self.view viewWithTag:tag_soda_alertview];
        if (alert) {
            UILabel * msglabel =  [alert messageLabel];
            return msglabel;
        }
        return nil;
    }@catch(NSException * ex){
        return nil;
    }@finally{
        
    };
}

/**
 * 配置圆角
 */
-(void)soda_setbgCornerRadius:(CGFloat)cornerRadius{
    
    UIView * alertContentView = [self.popUpView valueForKey:@"contentView"];
    alertContentView.layer.cornerRadius = cornerRadius;
}

/**
 * 设置富文本详情
 */
-(void)soda_setAttributedMessage:(NSMutableAttributedString *)attributedMessage{
    SODAAlertView * alert = self.popUpView;// [self.view viewWithTag:tag_soda_alertview];
    UILabel * msglabel =  [alert messageLabel];
    msglabel.attributedText = attributedMessage;
}

/**
 * 设置富文本标题
 */
-(void)soda_setAttributedTitle:(NSMutableAttributedString *)attributedTitle{
    [self setValue:attributedTitle forKey:@"attributedTitle"];
}

@end


@implementation NSObject(SODA)

/**
 * 苏打alert
 */
+ (SODAAlertViewController *)alertWithTitle:(NSString *)title
                      message:(NSString *)message
                   cancelTitle:(NSString *)cancelButtonTitle
              destructiveTitle:(NSString *)destructTitle
                   otherTitles:(NSArray<NSString *> *)otherButtonTitles
                   actionBlock:(SODAALERTACTIONBLOCK)actionBlock
{ 
    SODAAlertViewController * alert = [[SODAAlertViewController alloc] init];
    alert.view.backgroundColor = [UIColor clearColor];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    SODAAlertView *popUpView = [[SODAAlertView alloc] initWithSODATitleConfiguration:^(SODATitleConfiguration *configuration) {
        configuration.text = title;
        configuration.textColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
        configuration.fontSize = 16;
    } SODAMessageConfiguration:^(SODAMessageConfiguration *configuration) {
        configuration.text = message;
        configuration.textColor = [UIColor colorWithRed:0x33/(float)0xff green:0x33/(float)0xff blue:0x33/(float)0xff alpha:1];
        configuration.fontSize = 14;
    }];
    alert.popUpView = popUpView;
    alert.alertStyle = SODAAlertViewStyleAlert;
    
//    popUpView.tag = tag_soda_alertview;
    popUpView.textFieldFontSize = 16;
    popUpView.btnStyleCancelTextColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
    popUpView.btnStyleDefaultTextColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
    popUpView.btnStyleDestructiveTextColor = [UIColor colorWithRed:0xfd/(float)0xff green:0x3d/(float)0xff blue:0x66/(float)0xff alpha:1];
    if (cancelButtonTitle) {
        [popUpView addBtnWithTitle:cancelButtonTitle type:SODAAlertBtnStyleCancel handler:^{
            if(actionBlock)actionBlock(nil,SODA_ALERTACTION_CANCEL);
        }];
    }
    
    [otherButtonTitles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [popUpView addBtnWithTitle:obj type:SODAAlertBtnStyleDefault handler:^{
            if(actionBlock) actionBlock(nil,(int)idx);
        }];
    }];
    
    if (destructTitle) {
        [popUpView addBtnWithTitle:destructTitle type:SODAAlertBtnStyleDestructive handler:^{
            if(actionBlock)actionBlock(nil,SODA_ALERTACTION_DESCRUCT);
        }];
    }
    
    popUpView.dismissAction = ^(void){
        
    };
    return alert;
}

+ (SODAAlertViewController *)actionSheetWithTitle:(nullable NSString *)title
                             message:(NSString *)message
                         cancelTitle:(NSString *)cancelButtonTitle
                    destructiveTitle:(NSString *)destructTitle
                         otherTitles:(NSArray<NSString *> *)otherButtonTitles
                         actionBlock:(SODAALERTACTIONBLOCK)actionBlock {

    
    SODAAlertViewController * alert = [[SODAAlertViewController alloc] init];
    alert.view.backgroundColor = [UIColor clearColor];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
//    SODAAlertView *popUpView = [[SODAAlertView alloc] initWithTitle:title message:message];
    SODAAlertView *popUpView = [[SODAAlertView alloc] initWithSODATitleConfiguration:^(SODATitleConfiguration *configuration) {
        configuration.text = title;
        configuration.textColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
        configuration.fontSize = 16;
    } SODAMessageConfiguration:^(SODAMessageConfiguration *configuration) {
        configuration.text = message;
        configuration.textColor = [UIColor colorWithRed:0xbb/(float)0xff green:0xbb/(float)0xff blue:0xbb/(float)0xff alpha:1];
        configuration.fontSize = 12;
    }];
    alert.popUpView = popUpView;
    alert.alertStyle = SODAAlertViewStyleActionSheet;
    popUpView.textFieldFontSize = 16;
    popUpView.buttonHeight = 48;
    popUpView.lineHeight = 0.5;
    popUpView.btnStyleCancelTextColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
    popUpView.btnStyleDefaultTextColor = [UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1];
    popUpView.btnStyleDestructiveTextColor = [UIColor colorWithRed:0xfd/(float)0xff green:0x3d/(float)0xff blue:0x66/(float)0xff alpha:1];
    
    if (cancelButtonTitle) {
        [popUpView addBtnWithTitle:cancelButtonTitle type:SODAAlertBtnStyleCancel handler:^{
            if(actionBlock)actionBlock(nil,SODA_ALERTACTION_CANCEL);
        }];
    }
    
    [otherButtonTitles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [popUpView addBtnWithTitle:obj type:SODAAlertBtnStyleDefault handler:^{
            if(actionBlock) actionBlock(nil,(int)idx);
        } ];
    }];
    
    if (destructTitle) {
        [popUpView addBtnWithTitle:destructTitle type:SODAAlertBtnStyleDestructive handler:^{
            if(actionBlock)actionBlock(nil,SODA_ALERTACTION_DESCRUCT);
        }];
    }
    
    popUpView.dismissAction = ^(void){
    };
    return alert;
    
}


@end


@implementation UIAlertAction(soda)

/**
 * 文字颜色设置
 */
-(void)soda_setTitleTextColor:(UIColor *)titleTextColor{
    //[UIColor colorWithRed:0x11/(float)0xff green:0x11/(float)0xff blue:0x11/(float)0xff alpha:1]
     [self setValue:titleTextColor forKey:@"titleTextColor"];
}

/** 
 * 设置文字排列
 */
-(void)soda_setTitleTextAlignment:(NSTextAlignment)alignmentLeft{
    [self setValue:[NSNumber numberWithInteger:alignmentLeft] forKey:@"titleTextAlignment"];
}

/** 
* 设置左边图片
 */
-(void)soda_setAccessImage:(UIImage *)accessoryImage{
//    UIImage *accessoryImage = [[UIImage imageNamed:@"3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self setValue:accessoryImage forKey:@"image"];
}

@end




@implementation NSObject (SODABlockSEL)

- (SEL)sodaalert_selectorBlock:(void (^)(id target, id arg))block {
    if (!block) {
        [NSException raise:@"block can not be nil" format:@"%@ selectorBlock error", self];
    }
    NSString *selName = [NSString stringWithFormat:@"selector_%p:", block];
    SEL sel = NSSelectorFromString(selName);
    class_addMethod([self class], sel, (IMP)sodaAlertSelectorImp, "v@:@");
    objc_setAssociatedObject(self, sel, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return sel;
}

static void sodaAlertSelectorImp(id self, SEL _cmd, id arg) {
    sodaalertcallback block = objc_getAssociatedObject(self, _cmd);
    __weak typeof(self) weakSelf = self;
    if (block) {
        block(weakSelf, arg);
    }
}


@end



@implementation UIViewController(soda)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(presentViewController:animated:completion:) withAnotherSelector:@selector(soda_presentViewController:animated:completion:)];
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

- (void)soda_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([viewControllerToPresent isKindOfClass:[SODAAlertViewController class]]) {
        SODAAlertViewController * ctr = (SODAAlertViewController *)viewControllerToPresent;
        if (ctr.alertStyle == SODAAlertViewStyleAlert) {
            [ctr.popUpView showInView:[UIApplication sharedApplication].delegate.window preferredStyle:SODAAlertViewStyleAlert];
        }
        else{
            [ctr.popUpView showInView:[UIApplication sharedApplication].delegate.window preferredStyle:SODAAlertViewStyleActionSheet];
        }
    }
    else{
        [self soda_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end

