//
//  SODAAlertView.h
//  LQAlertView
//
//  Created by liqian on 17/2/27.
//  Copyright © 2017年 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SODAAlertBtnStyle) {
    SODAAlertBtnStyleDefault = 0,
    SODAAlertBtnStyleCancel = 1,
    SODAAlertBtnStyleDestructive = 2,
};

typedef NS_ENUM(NSUInteger, SODAAlertViewStyle) {
    SODAAlertViewStyleAlert = 0,
    SODAAlertViewStyleActionSheet = 1
};


// Title custom
@interface SODATitleConfiguration : NSObject

@property (nonatomic, copy) NSString *text;

// default 18
@property (nonatomic, assign) CGFloat fontSize;

// default 0x000000
@property (nonatomic, strong) UIColor *textColor;

// default 15
@property (nonatomic, assign) CGFloat top;

// default 0
@property (nonatomic, assign) CGFloat bottom;

@end


// message custom
@interface SODAMessageConfiguration : NSObject

@property (nonatomic, copy) NSString *text;

// default 16
@property (nonatomic, assign) CGFloat fontSize;

// default 0x333333
@property (nonatomic, strong) UIColor *textColor;

// default 10
@property (nonatomic, assign) CGFloat top;

// default 15
@property (nonatomic, assign) CGFloat bottom;

@end

typedef void(^buttonAction) (void);
typedef void(^dismissAction) (void);

@interface SODAAlertView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;

// you can get textField's text from this property
@property (nonatomic, strong, readonly) NSArray<UITextField *> *textFieldArray;

// customize property

// default 50.0
@property (nonatomic, assign) CGFloat buttonHeight;

// default 33.0
@property (nonatomic, assign) CGFloat textFieldHeight;

// default 0.6
@property (nonatomic, assign) CGFloat lineHeight;

// default 15.0
@property (nonatomic, assign) CGFloat textFieldFontSize;

// default 0x0a7af3, system alert blue
@property (nonatomic, strong) UIColor *btnStyleDefaultTextColor;

// default 0x555555, black
@property (nonatomic, strong) UIColor *btnStyleCancelTextColor;

// default 0xff4141, red
@property (nonatomic, strong) UIColor *btnStyleDestructiveTextColor;

// default when preferredStyle is SODAAlertViewStyleAlert NO, when preferredStyle is SODAAlertViewStyleActionSheet YES
@property (nonatomic, assign) BOOL canClickBackgroundHide;

@property (nonatomic, copy) dismissAction dismissAction;

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message;

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles actionWithIndex:(void(^)(NSInteger index))action;

-(instancetype) initWithSODATitleConfiguration:(void (^)(SODATitleConfiguration *configuration))SODATitleConfiguration SODAMessageConfiguration:(void (^)(SODAMessageConfiguration *configuration))msgConfiguration;


- (void) addTextFieldWithPlaceholder:(NSString *)placeholder text:(NSString *)text secureEntry:(BOOL)secureEntry;
- (void) addBtnWithTitle:(NSString *)title type:(SODAAlertBtnStyle)style handler:(buttonAction)handler;

//show
- (void)showInWindowWithPreferredStyle:(SODAAlertViewStyle)preferredStyle;
- (void)showInView:(UIView *)view preferredStyle:(SODAAlertViewStyle)preferredStyle;


-(void)soda_addInView:(UIView *)view;
-(void)soda_showAnimatePreferredStyle:(SODAAlertViewStyle)preferredStyle;
@end
