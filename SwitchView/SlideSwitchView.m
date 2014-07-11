//
//  SlideSwitchView.m
//  SwitchView
//
//  Created by Henry on 14-7-9.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import "SlideSwitchView.h"

#define kButtonTitleFont    [UIFont systemFontOfSize:15]

@interface SlideSwitchView ()<UIScrollViewDelegate>

@property(nonatomic, strong, readwrite) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation SlideSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor brownColor];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
        [self setDefaultProperties];
    }
    return self;
}

- (void)setDefaultProperties
{
    _edgeSpace = 15;
    _itemSpace = 15;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    _totalCount = [titles count];
    CGFloat totalLength = _edgeSpace;
    CGFloat height = self.bounds.size.height;
    for (int i = 0; i < _totalCount; i++) {
        NSString *str = titles[i];
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: kButtonTitleFont}];
        NSLog(@"size:%@",NSStringFromCGSize(size));
        
        CGFloat width = size.width + 6;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = kButtonTitleFont;
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(totalLength, 0, width, self.bounds.size.height)];
        [button setTag:i + 1];
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        if (i == 0 && !self.selectedImageView) {
            self.selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(totalLength, height - 4, width, 4)];
            self.selectedImageView.image = [[UIImage imageNamed:@"selected"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
            [self.scrollView addSubview:self.selectedImageView];
        }

        totalLength += (_itemSpace + width);
    }
    totalLength -= _itemSpace;
    totalLength += _edgeSpace;
    [self.scrollView setContentSize:CGSizeMake(totalLength, self.bounds.size.height)];
    
    [self.scrollView bringSubviewToFront:self.selectedImageView];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:currentIndex + 1];
    
    [self buttonSelected:button];
}


/**
 *  单击button改变自身scrollView的样式以及相关视图的显示内容
 *
 */
- (void)buttonSelected:(UIButton *)button
{
//    NSLog(@"button.tag:%d",button.tag);
    
    CGRect frame = button.frame;
    frame.origin.y = self.bounds.size.height - 4;
    frame.size.height = 4;
    [UIView animateWithDuration:0.285 animations:^{
        self.selectedImageView.frame = frame;
    }];
    
    _currentIndex = button.tag - 1;
    
//    NSLog(@"button.frame:%@",NSStringFromCGRect(button.frame));
    
    CGRect frameInScreen = [self.scrollView convertRect:button.frame toView:self];
    
//    NSLog(@"button InScreen frame:%@",NSStringFromCGRect(frameInScreen));
    
    //将选中的button置于最中间
    CGFloat idealOffsetX = (self.frame.size.width - frame.size.width) / 2.0f;
    CGFloat distance = frameInScreen.origin.x - idealOffsetX;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    contentOffsetX += distance;
    if (contentOffsetX < 0) {
        contentOffsetX = 0;
    }
    
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (contentOffsetX > maxOffsetX) {
        contentOffsetX = maxOffsetX;
    }
    
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    
    if (self.selectBlock){
            self.selectBlock(button.tag - 1);
    }
}

- (void)updateSelectedImageViewFrameWithOffsetX:(CGFloat)offsetX
{
    if (_currentIndex == 0 && (offsetX < 0)) {
        return;
    }
    
    if ((_currentIndex == _totalCount - 1) && (offsetX > 0)) {
        return;
    }
    
    NSInteger offsetIndex = 0;
    if (offsetX < 0) {
        offsetIndex = -1;
    }else{
        offsetIndex = 1;
    }
    
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:_currentIndex + 1 + offsetIndex];
    CGRect toFrame = button.frame;
    
    UIButton *fromButton = (UIButton *)[self.scrollView viewWithTag:_currentIndex + 1];
    CGRect fromFrame = fromButton.frame;
    
    CGFloat percentage = fabsf(offsetX)/ self.scrollView.bounds.size.width;
    
    CGFloat distanceX = toFrame.origin.x - fromFrame.origin.x;
    CGFloat sizeOffset = toFrame.size.width - fromFrame.size.width;
    
    CGRect frame = self.selectedImageView.frame;
    frame.origin.x = fromFrame.origin.x + distanceX * percentage;
    frame.size.width = fromFrame.size.width + sizeOffset * percentage;
    
    //---------------------------  见BaseViewControler.m 94行
    CGFloat minWidth = MIN(fromFrame.size.width, toFrame.size.width);
    CGFloat maxWidth = MAX(fromFrame.size.width, toFrame.size.width);
    if (frame.size.width < minWidth) {
        frame.size.width = minWidth;
    }
    if (frame.size.width > maxWidth) {
        frame.size.width = maxWidth;
    }
    //---------------------------
    self.selectedImageView.frame = frame;
}

- (void)updateCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    UIButton *button = [self findButtonByTag:_currentIndex];
    
    CGRect frameInScreen = [self.scrollView convertRect:button.frame toView:self];
    
    CGRect frame = button.frame;
    
    frame.origin.y = self.bounds.size.height - 4;
    frame.size.height = 4;
    [UIView animateWithDuration:0.285 animations:^{
        self.selectedImageView.frame = frame;
    }];
    
    //将选中的button置于最中间
    CGFloat idealOffsetX = (self.frame.size.width - frame.size.width) / 2.0f;
    CGFloat distance = frameInScreen.origin.x - idealOffsetX;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    contentOffsetX += distance;
    if (contentOffsetX < 0) {
        contentOffsetX = 0;
    }
    
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (contentOffsetX > maxOffsetX) {
        contentOffsetX = maxOffsetX;
    }
    
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
}

- (UIButton *)findButtonByTag:(NSInteger)tag
{
    return (UIButton *)[self.scrollView viewWithTag:tag + 1];
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll");
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"end");
}
 */

@end
