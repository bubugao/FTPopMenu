//
//  FTPopMenu.m
//  FTPopMenu
//
//  Created by xiaodou on 16/1/13.
//  Copyright © 2016年 xiaodou. All rights reserved.
//

#import "FTPopMenu.h"

// 对于常量的命名最好在前面加上字母k作为标记
static const CGFloat kMenuItemWidth = 100;                 /**< 单行宽度 */
static const CGFloat kMenuItemHeight = 35;                 /**< 单行高度 */
static const CGFloat kArrowHeight = 5;                     /**< 气泡箭头高度 */

@implementation FTPopMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Custom
    }
    return self;
}

@end

@interface FTPopMenuView ()<UITableViewDataSource, UITableViewDelegate>
{
    UIView *superView;
    CGFloat menuTableViewHeight;
}

@property (nonatomic, readwrite, strong) UIImageView *menuContainerImageView;
@property (nonatomic, readwrite, strong) UITableView *menuTableView;

@property (nonatomic, readwrite, assign) CGRect targetFrame;
@property (nonatomic, readwrite, assign) PopDirection popDirection;
@property (nonatomic, readwrite, strong) NSMutableArray *menuItemsArray;
@property (nonatomic, readonly, copy) FTPopMenuSelectedBlock popMenuSelectedBlock;

@end

@implementation FTPopMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - get

// 气泡图片
- (UIImageView *)menuContainerImageView {
    if (!_menuContainerImageView) {
        menuTableViewHeight = kMenuItemHeight * _menuItemsArray.count;
        CGFloat x = CGRectGetMidX(_targetFrame) - (kMenuItemWidth) / 2;
        CGFloat y;
        if (_popDirection == PopDirectionUp) {
             y = CGRectGetMinY(_targetFrame) - menuTableViewHeight - kArrowHeight;
        } else {
             y = CGRectGetMaxY(_targetFrame);
        }
        CGFloat width = kMenuItemWidth;
        CGFloat height = menuTableViewHeight + kArrowHeight;
        
        _menuContainerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        if (_popDirection == PopDirectionUp) {
             _menuContainerImageView.image = [[UIImage imageNamed:@"BubbleUp"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        } else {
             _menuContainerImageView.image = [[UIImage imageNamed:@"BubbleDown"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        }
        _menuContainerImageView.userInteractionEnabled = YES;
        _menuContainerImageView.clipsToBounds = YES;
        
        [_menuContainerImageView addSubview:self.menuTableView];
    }
    
    return _menuContainerImageView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] init];
        if (_popDirection == PopDirectionUp) {
            _menuTableView.frame = CGRectMake(0, 0, CGRectGetWidth(_menuContainerImageView.frame), menuTableViewHeight);
        } else {
            _menuTableView.frame = CGRectMake(0, 5, CGRectGetWidth(_menuContainerImageView.frame), menuTableViewHeight);
        }
        [_menuTableView registerClass:[FTPopMenuCell class] forCellReuseIdentifier:NSStringFromClass([FTPopMenuCell class])];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.rowHeight = kMenuItemHeight;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.scrollEnabled = NO;
    }
    
    return _menuTableView;
}

#pragma mark - public

- (void)showMenuWithTargetFrame:(CGRect)targetFrame popDirection:(PopDirection)popDirection itemNameArray:(NSArray *)itemNameArray selectedBlock:(FTPopMenuSelectedBlock)selectedBlock {
    
    _targetFrame = targetFrame;
    _popDirection = popDirection;
    _menuItemsArray = itemNameArray.mutableCopy;
    _popMenuSelectedBlock = selectedBlock;
    [self showMenu];
}


#pragma mark - private

- (CGRect)getTargetFrame {
    return self.targetFrame;
}

/** 显示气泡菜单 */
- (void)showMenu {
    // 主窗口
    superView = [[UIApplication sharedApplication] keyWindow];
    self.backgroundColor = [UIColor clearColor];
    [superView addSubview:self];
    
    [self addSubview:self.menuContainerImageView];
    _menuContainerImageView.alpha = 0;
    
    // 先获取气泡菜单的高度 再用动画将其从1变高 从透明变为不透明
    CGRect toFrame = _menuContainerImageView.frame;
    
    if (_popDirection == PopDirectionUp) {
        _menuContainerImageView.frame = CGRectMake(CGRectGetMinX(_menuContainerImageView.frame), CGRectGetMinY(_targetFrame), CGRectGetWidth(_menuContainerImageView.frame), 1);
    } else {
        _menuContainerImageView.frame = CGRectMake(CGRectGetMinX(_menuContainerImageView.frame), CGRectGetMaxY(_targetFrame), CGRectGetWidth(_menuContainerImageView.frame), 1);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _menuContainerImageView.alpha = 1;
        _menuContainerImageView.frame = toFrame;
    }];
}

/** 移除气泡菜单 */
- (void)dismissMenu:(BOOL)animated {
    if (superView) {
        if (animated) {
            CGRect toFrame;
            if (_popDirection == PopDirectionUp) {
                toFrame = CGRectMake(CGRectGetMinX(_menuContainerImageView.frame), CGRectGetMinY(_targetFrame), CGRectGetWidth(_menuContainerImageView.frame), 1);
            } else {
                toFrame = CGRectMake(CGRectGetMinX(_menuContainerImageView.frame), CGRectGetMaxY(_targetFrame), CGRectGetWidth(_menuContainerImageView.frame), 1);
            }
            [UIView animateWithDuration:0.3 animations:^{
                _menuContainerImageView.alpha = 0;
                _menuContainerImageView.frame = toFrame;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        } else {
            [self removeFromSuperview];
        }
    }
}

#pragma mark - touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.menuTableView.frame, localPoint)) {
        // 拦截点击
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dismissMenu:YES];
    }
}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell 可以自定义 比如像微信点击添加效果那样
    FTPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTPopMenuCell class])];
    cell.textLabel.text = _menuItemsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _popMenuSelectedBlock(indexPath.row, _menuItemsArray[indexPath.row]);
}

@end


#pragma mark - =============== 华丽丽的分割线 ================

@interface FTPopMenu ()

@property (nonatomic, readwrite, strong) FTPopMenuView *popMenuView;

@end

@implementation FTPopMenu

- (void)showMenuWithTargetFrame:(CGRect)targetFrame popDirection:(PopDirection)PopDirection itemNameArray:(NSArray *)itemNameArray selectedBlock:(FTPopMenuSelectedBlock)selectedBlock {
    if (_popMenuView) {
        [_popMenuView dismissMenu:YES];
        _popMenuView = nil;
        return;
    }
    
    /* 思路:
      _popMenuView为全屏大小 装载着气泡菜单 点击_popMenuView上除了气泡的其他地方 让_popMenuView在0.3秒内变透明再移除 
     */
    _popMenuView = [[FTPopMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_popMenuView showMenuWithTargetFrame:targetFrame popDirection:PopDirection itemNameArray:itemNameArray selectedBlock:selectedBlock];
}

@end
