//
//  UIAlertController+SODA.h
//  BaseUI
//
//  Created by boob on 2018/1/4.
//

#import <UIKit/UIKit.h>
#import "SODAAlertView.h"

/**
 * 这是alertview的空载体，直接present出来才能看到
 */
@interface SODAAlertViewController:UIViewController

/**
 * 设置详情label，附带可点击文字，回调点击事件
 */
-(void)soda_setMessageTitle:(NSString *)message clickMessage:(NSString *)clickMessage touchBlock:(void(^)(void))touckBlock;
@end


/**
 * cancel 按钮
 */
const static int SODA_ALERTACTION_CANCEL = -2;
/**
 * DESCRUCT按钮
*/
const static int SODA_ALERTACTION_DESCRUCT = -1;
/**
 * 其他第一个按钮
 */
const static int SODA_ALERTACTION_OTHER = 0; //其他按钮的第一个值

/**
 * 按钮点击回调
 */
typedef void(^SODAALERTACTIONBLOCK)(UIAlertAction * action,int index);

@interface NSObject(SODA)

/**
 * 苏打 alert 弹窗
 */
+ (SODAAlertViewController *)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelTitle:(NSString *)cancelButtonTitle
              destructiveTitle:(NSString *)destructTitle
                   otherTitles:(NSArray<NSString *> *)otherButtonTitles
                   actionBlock:(SODAALERTACTIONBLOCK)actionBlock;
/**
 * 苏打 actionsheet 操作选择
 */
+ (SODAAlertViewController *)actionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                         cancelTitle:(NSString *)cancelButtonTitle
                    destructiveTitle:(NSString *)destructTitle
                         otherTitles:(NSArray<NSString *> *)otherButtonTitles
                         actionBlock:(SODAALERTACTIONBLOCK)actionBlock;



@end

 

