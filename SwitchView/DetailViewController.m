//
//  DetailViewController.m
//  SwitchView
//
//  Created by Henry on 14-7-11.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    UILabel *label;
}
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 50)];
    label.text = self.content;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

//- (void)setContent:(NSString *)content
//{
//    label.text = content;
//}

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
