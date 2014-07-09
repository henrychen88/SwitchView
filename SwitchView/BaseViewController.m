//
//  BaseViewController.m
//  SwitchView
//
//  Created by Henry on 14-7-9.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NetEase";
    
    SlideSwitchView *slideSwitchView = [[SlideSwitchView alloc]initWithFrame:CGRectMake(20, 100, 280, 40)];
    slideSwitchView.titles = @[@"头条", @"体育界", @"汽车", @"科技", @"轻松一刻", @"杭州", @"游戏", @"时尚", @"财经", @"推荐", @"军事", @"娱乐", @"世界杯"];
    
    [self.view addSubview:slideSwitchView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
