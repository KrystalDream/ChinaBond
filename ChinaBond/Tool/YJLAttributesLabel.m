//
//  YJLAttributesLabel.m
//  ChinaBond
//
//  Created by Krystal on 2020/11/20.
//  Copyright © 2020 chinaBond. All rights reserved.
//

#import "YJLAttributesLabel.h"

@interface YJLTextView : UITextView

@end

@implementation YJLTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // 返回NO为禁用，YES为开启
    // 粘贴
    if (action == @selector(paste:)) return NO;
    // 剪切
    if (action == @selector(cut:)) return NO;
    // 复制
    if (action == @selector(copy:)) return NO;
    // 选择
    if (action == @selector(select:)) return NO;
    // 选中全部
    if (action == @selector(selectAll:)) return NO;
    // 删除
    if (action == @selector(delete:)) return NO;
    // 分享
    if (action == @selector(share)) return NO;
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}


@end


@interface YJLAttributesLabel()<UITextViewDelegate>

@property (nonatomic , strong) YJLTextView *textView ;
@property (nonatomic , strong) NSMutableArray *actionText ;
@property (nonatomic , strong) NSMutableArray *actionRange ;

@end


@implementation YJLAttributesLabel

- (void)setAttributesText: (NSMutableAttributedString *)text actionText: (NSMutableArray *)actionText actionRange:(NSMutableArray *)actionrange{
    self.textView.attributedText    = text;
    self.actionText                 = actionText;
    self.actionRange                = actionrange;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if ([self.actionRange containsObject:[NSString stringWithFormat:@"%ld",characterRange.location]]) {
        NSLog(@"%ld",characterRange.location);
        NSInteger index = [self.actionRange indexOfObject:[NSString stringWithFormat:@"%ld",characterRange.location]];
        self.YJLAttributesBlock(self.actionText[index]);
        return NO;
    }
    return YES;
}

- (instancetype)init {
    if (self == [super init]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.userInteractionEnabled = YES;
}

- (void)setupUI {
    [self addSubview:self.textView];
}

- (void)layoutSubviews {
    self.textView.frame = self.bounds;
}


- (YJLTextView *)textView {
    
    if (_textView == nil) {
        _textView = [[YJLTextView alloc]init];
        _textView.backgroundColor = self.backgroundColor;
        _textView.textColor = self.textColor;
        self.textColor  = [UIColor clearColor];
        _textView.font  = self.font;
        _textView.scrollEnabled = NO;
        _textView.text  = self.text;
        _textView.delegate = self;
        _textView.editable = NO;
        _textView.textAlignment = self.textAlignment;
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:CBRGBColor(25, 122, 246)};
    }
    return _textView;
}
@end
