//
//  SlideSwitchView.m
//  SwitchView
//
//  Created by Henry on 14-7-9.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import "SlideSwitchView.h"

#define kButtonTitleFont    [UIFont systemFontOfSize:15]

@interface SlideSwitchView ()
{
    
}

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
        [button setBackgroundColor:[UIColor orangeColor]];
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

- (void)buttonSelected:(UIButton *)button
{
    NSLog(@"button.tag:%d",button.tag);
    CGRect frame = button.frame;
    frame.origin.y = self.bounds.size.height - 4;
    frame.size.height = 4;
    [UIView animateWithDuration:0.2 animations:^{
        self.selectedImageView.frame = frame;
    }];
    
    NSLog(@"button.frame:%@",NSStringFromCGRect(button.frame));
    
    CGRect frameInScreen = [self.scrollView convertRect:button.frame toView:self];
    
    NSLog(@"button InScreen frame:%@",NSStringFromCGRect(frameInScreen));
    
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


@end
