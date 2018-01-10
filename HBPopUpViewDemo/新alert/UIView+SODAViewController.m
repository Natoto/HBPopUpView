//
//  UIView+SODAViewController.m
//  SODA
//
//  Created by peng jun on 2017/12/5.
//  Copyright © 2017年 YY.Inc. All rights reserved.
//

#import "UIView+SODAViewController.h"

@implementation UIView (SODAViewController)

#pragma mark - viewcontroller cycle

- (UIViewController *)currentViewController{
    
    UIViewController *vc = [self currentVisiableRootViewController];
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    
    return vc;
    
    
}
- (UIViewController*) currentVisiableRootViewController{
    
    __block UIViewController *result = nil;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    NSArray *windowSubviews = [topWindow subviews];
    
    [windowSubviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop) {
         UIView *rootView = obj;
         
         if ([NSStringFromClass([rootView class]) isEqualToString:@"UITransitionView"]) {
             
             NSArray *aSubViews = rootView.subviews;
             
             [aSubViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 UIView *tempView = obj;
                 
                 id nextResponder = [tempView nextResponder];
                 
                 if ([nextResponder isKindOfClass:[UIViewController class]]) {
                     result = nextResponder;
                     *stop = YES;
                 }
             }];
             *stop = YES;
         } else {
             
             id nextResponder = [rootView nextResponder];
             
             if ([nextResponder isKindOfClass:[UIViewController class]]) {
                 result = nextResponder;
                 *stop = YES;
             }
         }
     }];
    
    if (result == nil && [topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
    }
    
    return result;
}

@end
