//
//  RKCateFreshView.m
//  RKKLineDemo
//
//  Created by Jiaxiaobin on 15/12/4.
//  Copyright © 2015年 RK Software. All rights reserved.
//

#import "RKCateFreshView.h"

@implementation RKCateFreshView
{
    NSArray *models;
    UIScrollView *_scroll1;
    UIScrollView *_scroll2;
    UIScrollView *_scroll3;
    
    CGFloat _currentHeight;
}

- (id)init
{
    if (self = [super init]) {
        _scroll1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
        _scroll1.dk_backgroundColorPicker = DKColorWithRGB(0xffffff, 0x282727);
        _scroll1.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scroll1];
        _scroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 39)];
        _scroll2.dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x333333);
        _scroll2.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scroll2];
        _scroll3 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39*2, SCREEN_WIDTH, 39)];
        _scroll3.dk_backgroundColorPicker = DKColorWithRGB(0xf0eff4, 0x404040);
        _scroll3.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scroll3];
    }
    return self;
}

static int currentSection[3] = {-1, -1, -1};

- (void)resetWithData:(NSArray *)data
{
    models = data;
    if ([models count]>0) {
        currentSection[0]=0;
    }
    //默认获得第一个一级菜单
    RKCateLevelModel *modelFirstInLevelOne = [models firstObject];
    if ([modelFirstInLevelOne.subLevels count]>0) {
        currentSection[1]=0;
    }
    
    RKCateLevelModel *modelFirstInLevelTwo = [modelFirstInLevelOne.subLevels firstObject];
    if ([modelFirstInLevelTwo.subLevels count]>0) {
        currentSection[2] = 0;
    }
    [self refreshWithState];
    //默认将点击第一个
    [self preLoad];
}
- (void)preLoad
{
    for (UIView *view in _scroll3.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag==33000) {
            [self modelSelected:(UIButton *)view];
            //找到第3行，返回
            return;
        }
    }
    for (UIView *view in _scroll2.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag==32000) {
            [self modelSelected:(UIButton *)view];
            //找到第二行，返回
            return;
        }
    }
    for (UIView *view in _scroll1.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag==31000) {
            [self modelSelected:(UIButton *)view];
            //找到第一行，返回
            return;
        }
    }
}
- (RKCateLevelModel *)refreshWithState
{
    for (UIView *view in _scroll1.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag>31000-1 && view.tag<34000) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in _scroll2.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag>31000-1 && view.tag<34000) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in _scroll3.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag>31000-1 && view.tag<34000) {
            [view removeFromSuperview];
        }
    }
    //用于contentSize
    CGFloat widthOfOneScrollView = 0;
    CGFloat widthOfTwoScrollView = 0;
    CGFloat widthOfThreeScrollView = 0;
    
    //显示第一行
    if ([models count]<1) {
        _currentHeight = 0;
        return nil;
    }
    int order = 0;
    NSMutableArray *widthsOfOne = [NSMutableArray arrayWithCapacity:0];
    for (RKCateLevelModel *model in models) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:model.levelTitle forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        button.tag = 31000+order;
        [button dk_setTitleColorPicker:DKColorWithRGB(0xd64848, 0xad4343) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button dk_setTitleColorPicker:DKColorWithRGB(0x000000, 0x999999) forState:UIControlStateNormal];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize labelSize = [model.levelTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                       attributes:attribute
                                                          context:nil].size;
        
        CGFloat labelX = 0;
        if (order>0) {
            for (NSNumber *num in widthsOfOne) {
                labelX += [num floatValue];
            }
        }
        button.frame = CGRectMake(labelX, 5, labelSize.width+20, 34);
        
        [widthsOfOne addObject:[NSNumber numberWithFloat:(labelSize.width+20)]];
        [_scroll1 addSubview:button];
        order++;
    }
    for (NSNumber *widthOfLabel in widthsOfOne) {
        widthOfOneScrollView += [widthOfLabel floatValue];
    }
    _scroll1.contentSize = CGSizeMake(widthOfOneScrollView, 39);
    
    //选中第一行,获得子Level
    int indexOfOneLine = currentSection[0];
    if (indexOfOneLine==-1) {
        _currentHeight = 39.0;
        return nil;
    }
    
    RKCateLevelModel *modelInLevelOne = [models objectAtIndex:indexOfOneLine];
    if ([modelInLevelOne.subLevels count]<1) {
        //第一行确认刷新列表
        _currentHeight = 39.0;
        return modelInLevelOne;
    }
    //显示第二行
    order = 0;
    NSMutableArray *widthsOfTwo = [NSMutableArray arrayWithCapacity:0];
    for (RKCateLevelModel *model in modelInLevelOne.subLevels) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        button.tag = 32000+order;
        [button setTitle:model.levelTitle forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button dk_setTitleColorPicker:DKColorWithRGB(0x6d6d6d, 0x7f7f7f) forState:UIControlStateNormal];
        [button dk_setTitleColorPicker:DKColorWithRGB(0xf95e5c, 0xad4343) forState:UIControlStateSelected];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize labelSize = [model.levelTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                       attributes:attribute
                                                          context:nil].size;
        
        CGFloat labelX = 10*(order+1)+10*order;
        if (order>0) {
            for (NSNumber *num in widthsOfTwo) {
                labelX += [num floatValue];
            }
        }
        button.frame = CGRectMake(labelX, 7, labelSize.width+20, 24);
        
        [widthsOfTwo addObject:[NSNumber numberWithFloat:(labelSize.width+20)]];
        [_scroll2 addSubview:button];
        order++;
    }
    for (NSNumber *widthOfLabel in widthsOfTwo) {
        widthOfTwoScrollView += [widthOfLabel floatValue];
    }
    _scroll2.contentSize = CGSizeMake(widthOfTwoScrollView, 39);
    
    
    //选中第二行
    int indexOfTwoLine = currentSection[1];
    if (indexOfTwoLine==-1) {
        _currentHeight = 39.0*2;
        return nil;
    }
    RKCateLevelModel *modelInLevelTwo = [modelInLevelOne.subLevels objectAtIndex:indexOfTwoLine];
    if ([modelInLevelTwo.subLevels count]<1) {
        //第二行确认刷新列表
        _currentHeight = 39.0*2;
        return modelInLevelTwo;
    }
    order = 0;
    NSMutableArray *widthsOfThree = [NSMutableArray arrayWithCapacity:0];
    for (RKCateLevelModel *model in modelInLevelTwo.subLevels) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        button.tag = 33000+order;
        [button addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:model.levelTitle forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button dk_setTitleColorPicker:DKColorWithRGB(0x868686, 0x7f7f7f) forState:UIControlStateNormal];
        [button dk_setTitleColorPicker:DKColorWithRGB(0xfd8d38, 0xd47b37) forState:UIControlStateSelected];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize labelSize = [model.levelTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                       attributes:attribute
                                                          context:nil].size;
        
        CGFloat labelX = 0;
        if (order>0) {
            for (NSNumber *num in widthsOfThree) {
                labelX += [num floatValue];
            }
        }
        button.frame = CGRectMake(labelX, 0, labelSize.width+20, 39);
        
        [widthsOfThree addObject:[NSNumber numberWithFloat:(labelSize.width+20)]];
        [_scroll3 addSubview:button];
        order++;
    }
    
    //选中第三行
    int indexOfThreeLine = currentSection[2];
    if (indexOfThreeLine==-1) {
        _currentHeight = 39.0*3;
        return nil;
    }
    for (NSNumber *widthOfLabel in widthsOfThree) {
        widthOfThreeScrollView += [widthOfLabel floatValue];
    }
    _scroll3.contentSize = CGSizeMake(widthOfThreeScrollView, 39);
    
    RKCateLevelModel *modelInLevelThree = [modelInLevelTwo.subLevels objectAtIndex:indexOfThreeLine];
    //第三行确认刷新列表
    _currentHeight = 39.0*3;
    return modelInLevelThree;
}

//确认刷新列表
- (void)confirmByModel:(RKCateLevelModel *)model
{
    NSLog(@"%@",model.levelTitle);
    if (self.delegate && [self.delegate respondsToSelector:@selector(freshViewSelectModel:)]) {
        [self.delegate freshViewSelectModel:model];
    }
}

- (void)modelSelected:(UIButton *)sender
{
    //31000 32000 33000
    if (sender.tag-31000<1000) {
        //scrollview1
        currentSection[0] = (int)sender.tag-31000;
        currentSection[1] = -1;
        currentSection[2] = -1;
        [self confirmByModel:[self refreshWithState]];
        ((UIButton *)[_scroll1 viewWithTag:sender.tag]).selected = YES;
        ((UIButton *)[_scroll1 viewWithTag:sender.tag]).dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x333333);
    }else if(sender.tag-31000<2000){
        //scrollview2
        currentSection[1] = (int)sender.tag-32000;
        currentSection[2] = -1;
        [self confirmByModel:[self refreshWithState]];
        ((UIButton *)[_scroll1 viewWithTag:31000+currentSection[0]]).selected = YES;
        ((UIButton *)[_scroll1 viewWithTag:31000+currentSection[0]]).dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x333333);
        ((UIButton *)[_scroll2 viewWithTag:sender.tag]).selected = YES;
        ((UIButton *)[_scroll2 viewWithTag:sender.tag]).layer.cornerRadius = 2;
        ((UIButton *)[_scroll2 viewWithTag:sender.tag]).layer.borderWidth = 1;
        ((UIButton *)[_scroll2 viewWithTag:sender.tag]).layer.borderColor = UIColorFromRGB(0xfa5e5c).CGColor;
    }else{
        //scrollview3
        currentSection[2] = (int)sender.tag-33000;
        [self confirmByModel:[self refreshWithState]];
        ((UIButton *)[_scroll1 viewWithTag:31000+currentSection[0]]).selected = YES;
        ((UIButton *)[_scroll1 viewWithTag:31000+currentSection[0]]).dk_backgroundColorPicker = DKColorWithRGB(0xe9e8ed, 0x333333);
        ((UIButton *)[_scroll2 viewWithTag:32000+currentSection[1]]).selected = YES;
        ((UIButton *)[_scroll2 viewWithTag:32000+currentSection[1]]).layer.cornerRadius = 2;
        ((UIButton *)[_scroll2 viewWithTag:32000+currentSection[1]]).layer.borderWidth = 1;
        ((UIButton *)[_scroll2 viewWithTag:32000+currentSection[1]]).layer.borderColor = UIColorFromRGB(0xfa5e5c).CGColor;
        ((UIButton *)[_scroll3 viewWithTag:sender.tag]).selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(freshViewDidRefresh:)]) {
        [self.delegate freshViewDidRefresh:self];
    }
}

- (CGFloat)heightOfCurrent
{
    if (_currentHeight<40) {
        _scroll3.hidden = YES;
        _scroll2.hidden = YES;
    }else if(_currentHeight <40*2){
        _scroll3.hidden = YES;
        _scroll2.hidden = NO;
    }else{
        _scroll2.hidden = NO;
        _scroll3.hidden = NO;
    }
    return _currentHeight;
}

@end
