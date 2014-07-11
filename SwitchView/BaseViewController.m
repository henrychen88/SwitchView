//
//  BaseViewController.m
//  SwitchView
//
//  Created by Henry on 14-7-9.
//  Copyright (c) 2014年 Surwin. All rights reserved.
//

#import "BaseViewController.h"
#import "TableViewController.h"
#import "DetailViewController.h"

#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

@interface BaseViewController ()<UIScrollViewDelegate>
{
    SlideSwitchView *slideSwitchView;
    BOOL draging;
}
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) NSInteger currentPageIndex;
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NetEase";
    
    slideSwitchView = [[SlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    slideSwitchView.titles = @[@"头条", @"体育界", @"汽车", @"科技", @"轻松一刻", @"杭州", @"游戏", @"时尚", @"财经", @"推荐", @"军事", @"娱乐", @"世界杯"];
    
    [self.view addSubview:slideSwitchView];
    
    float offsetY = slideSwitchView.frame.origin.y + slideSwitchView.frame.size.height;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, SCREEN_HEIGHT - offsetY - 64)];
    self.scrollView.backgroundColor = [UIColor orangeColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    __block BaseViewController *blockSelf = self;
    
    NSInteger count = [slideSwitchView.titles count];
    self.scrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, self.scrollView.bounds.size.height);
    for (int i = 0; i < count; i++) {
        TableViewController *tabviewController = [[TableViewController alloc]initWithTitle:[slideSwitchView.titles objectAtIndex:i]];
        [tabviewController setSelectBlock:^(NSInteger currentIndex) {
            [self didselectedRow:(NSInteger)currentIndex];
        }];
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = i * SCREEN_WIDTH;
        tabviewController.view.frame = frame;
        [self addChildViewController:tabviewController];
        [self.scrollView addSubview:tabviewController.view];
    }
    
    self.currentPageIndex = 0;
    
    
    [slideSwitchView setSelectBlock:^(NSInteger currentIndex) {
        [blockSelf changeCurrentPage:currentIndex];
    }];
}

- (void)didselectedRow:(NSInteger)currentIndex
{
    DetailViewController *viewController =[[DetailViewController alloc]init];
    
    NSString *category = slideSwitchView.titles[self.currentPageIndex];
    
    viewController.content = [NSString stringWithFormat:@"%@--第%d项",category, currentIndex];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)changeCurrentPage:(NSInteger)currentPageIndex
{
    self.currentPageIndex = currentPageIndex;
    [self.scrollView setContentOffset:CGPointMake(currentPageIndex * self.scrollView.bounds.size.width, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    
    /**
     *  连续快速翻页导致 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 无法执行
     *  造成当前页的更新有延迟 从而影响到 SlideSwitchView 中 selectedImageView的变化
     *  具体表现为 selectedImageView 会出现一直变短 或者 一直变长的现象
     *  暂时的解决方法为 SlideSwitchView.m 167行
     */
    
    draging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // NSLog(@"scrollViewDidScroll");
    
    //如果是通过单击顶部按钮来改变内容页不处理事件
    if (draging) {
        [slideSwitchView updateSelectedImageViewFrameWithOffsetX:(scrollView.contentOffset.x - self.currentPageIndex * scrollView.bounds.size.width)];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    float offsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offsetX = scrollView.contentOffset.x;
    
    self.currentPageIndex = (NSInteger)(offsetX / self.scrollView.bounds.size.width);
    NSLog(@"当前页:%d",self.currentPageIndex);
    draging = NO;
    [slideSwitchView updateCurrentIndex:self.currentPageIndex];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"scrollViewWillEndDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}

@end
