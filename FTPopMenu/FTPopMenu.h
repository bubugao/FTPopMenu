//
//  FTPopMenu.h
//  FTPopMenu
//
//  Created by xiaodou on 16/1/13.
//  Copyright © 2016年 xiaodou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FTPopMenuSelectedBlock)(NSInteger index, NSString *itemName);

typedef NS_ENUM(NSInteger, PopDirection) {
    PopDirectionUp,        /**< 选项向上弹出 */
    PopDirectionDown       /**< 选项向下弹出 */
};

@interface FTPopMenuCell : UITableViewCell

@end

@interface FTPopMenuView : UIView

@end

@interface FTPopMenu : NSObject

/** 显示菜单 targetFrame为点击控件的frame */
- (void)showMenuWithTargetFrame:(CGRect)targetFrame popDirection:(PopDirection)popDirection itemNameArray:(NSArray *)itemNameArray selectedBlock:(FTPopMenuSelectedBlock)selectedBlock;

@end
