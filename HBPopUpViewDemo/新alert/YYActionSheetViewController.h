//
//  YYActionSheetViewController.h
//  YYMobile
//
//  Created by yangmengjun on 15/5/14.
//  Copyright (c) 2015年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"

@class YYActionSheetViewController;

extern NSString *const YYActionSheetDismissAllSheetsNotification;
extern NSString *const YYActionSheetAnimatedKey;

typedef void (^YYActionSheetViewControllerButtonBlock)(YYActionSheetViewController *controller);

/**
 * 废弃，使用UIAlertController+SODA代替
 */
@interface YYActionSheetViewController : UIViewController


- (void)addTitleText:(NSString *)title;

- (void)addButtonWithTitle:(NSString *)title block:(YYActionSheetViewControllerButtonBlock) block;

- (void)addDestructiveButtonWithTitle:(NSString *)title block:(YYActionSheetViewControllerButtonBlock)block;

- (void)setCancelBlock:(YYActionSheetViewControllerButtonBlock)block;

- (void)show;

- (void)showAnimated:(BOOL)animated;

- (void)dismiss;


/**
 *  点空白区域controller消失时的回调
 */
@property(nonatomic, copy) dispatch_block_t dismissAction;
@property(nonatomic, copy) YYActionSheetViewControllerButtonBlock cancelBlock;
@property(nonatomic, assign) BOOL disableDefaultCancel; //去掉默认的取消按钮和点击background事件

- (void)updateTitle:(NSString*)oldTitle toNewTitle:(NSString*)newTitle;
@end

