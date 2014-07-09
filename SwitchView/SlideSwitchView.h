//
//  SlideSwitchView.h
//  SwitchView
//
//  Created by Henry on 14-7-9.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSwitchView : UIView

/**
 *  scrollView
 */
@property(nonatomic, strong, readonly) UIScrollView *scrollView;

@property(nonatomic, strong) NSArray *titles;

@property(nonatomic, assign) CGFloat itemSpace;

@property(nonatomic, assign) CGFloat edgeSpace;

@property(nonatomic, assign) NSInteger totalCount;

@property(nonatomic, assign) NSInteger currentIndex;

@end
