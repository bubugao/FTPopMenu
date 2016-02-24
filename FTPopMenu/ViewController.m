//
//  ViewController.m
//  FTPopMenu
//
//  Created by xiaodou on 16/1/13.
//  Copyright © 2016年 xiaodou. All rights reserved.
//

#import "ViewController.h"
#import "FTPopMenu.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *popButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    popButton.center = self.view.center;
    [popButton setTitle:@"弹出选项" forState:UIControlStateNormal];
    [popButton setBackgroundColor:[UIColor orangeColor]];
    [popButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:popButton];
    
    [popButton addTarget:self action:@selector(popButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action
- (void)popButtonClicked:(UIButton *)button {
    FTPopMenu *popMenu = [[FTPopMenu alloc]init];
    
    // 向上弹出菜单选项
//    [popMenu showMenuWithTargetFrame:button.frame popDirection:PopDirectionUp itemNameArray:@[@"第一行",@"第二行",@"第三行"] selectedBlock:^(NSInteger index, NSString *itemName) {
//        NSLog(@"index:%d,name:%@",index,itemName);
//    }];

    // 向下弹出菜单选项
    [popMenu showMenuWithTargetFrame:button.frame popDirection:PopDirectionDown itemNameArray:@[@"第一行",@"第二行",@"第三行"] selectedBlock:^(NSInteger index, NSString *itemName) {
        NSLog(@"index:%d,name:%@",index,itemName);
    }];
}

@end
