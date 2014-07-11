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

@property(nonatomic, copy) selectBlock selectBlock;

- (void)setSelectBlock:(selectBlock)selectBlock;

/**
 *  当前页发生变化时，通知scrollView将选中项置于最中间
 */
- (void)updateCurrentIndex:(NSInteger)currentIndex;

/**
 *  在滑动内容页的时候,动态改变selectedImageView的位置
 */
- (void)updateSelectedImageViewFrameWithOffsetX:(CGFloat)offsetX;

@end
