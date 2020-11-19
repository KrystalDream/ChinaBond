//
//  CBValueView.m
//  ChinaBond
//
//  Created by wangran on 15/12/2.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBValueView.h"
#import "CBItemValueView.h"

@interface CBValueView()<UIScrollViewDelegate>
{
    NSInteger _tempPage;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *tmpArr;
@property (nonatomic) NSNumber *autoTime; // 滚动时间

@end

@implementation CBValueView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)reloadData:(NSArray *)array
{
    _tmpArr = array;
    if (_scrollView) {
        return;
    }
    _scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 100)];
    _scrollView.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x0f0f0f);
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH-20, 100*array.count);
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self addSubview:_scrollView];
    
    CGFloat width = (SCREEN_WIDTH-30)/2;
    
    int count = (int)array.count;
    
    if (count>0) {
        for (int j=0; j<(count/2 > 0 ? count/2 : count%2); j++) {
            for (int i=0; i<(count>2 ? 2 : 1); i++) {
                CBItemValueView *itemValue = [[CBItemValueView alloc] initWithFrame:CGRectMake(width*i+10*i, 100*j, width, 100)
                                                                             andDic:array[i+2*j]];
                
                [_scrollView addSubview:itemValue];
            }
        }
        
        //设置定时器
        if (!self.autoTime) {
            self.autoTime = [NSNumber numberWithFloat:10.0f];
        }
        NSTimer *myTimer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage)userInfo:nil repeats:YES];
        
        [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];

    }
}

#pragma mark -定时器 Method-
- (void)runTimePage
{
    NSInteger page = self.scrollView.contentOffset.y/100;
    page ++;
    [self turnPage:page];
}

#pragma mark -PageControl Method-
- (void)turnPage:(NSInteger)page
{
    _tempPage = page;
    if (page == _tmpArr.count/2) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }else
    {
        [self.scrollView scrollRectToVisible:CGRectMake(0, page*100, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }
}

@end
