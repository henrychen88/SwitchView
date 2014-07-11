//
//  TableViewController.h
//  SwitchView
//
//  Created by Henry on 14-7-11.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) selectBlock selectBlock;
- (id)initWithTitle:(NSString *)title;

- (void)setSelectBlock:(selectBlock)selectBlock;

@end
