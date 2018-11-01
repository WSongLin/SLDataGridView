//
//  SLDataGridTableViewCell.m
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/10/16.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#import "SLDataGridTableViewCell.h"
#import "SLDataGridModel.h"
#import "Masonry.h"
#import "SLMacroDefinition.h"

NSString * const SLDataGridTableViewCellScrollNotification = @"SLDataGridTableViewCellScrollNotification";

@interface SLDataGridTableViewCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *firstColumnLabel;
@property (nonatomic, weak) UIView *firstVerticalLine;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation SLDataGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _firstColumnWidth = 120.f;
        _otherColumnWidth = 90.f;
        _scrollViewContentOffset = CGPointZero;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cellDidScrollNotification:)
                                                     name:SLDataGridTableViewCellScrollNotification
                                                   object:nil
         ];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (0 == CGRectGetWidth(self.contentView.bounds)
        || 0 == CGRectGetHeight(self.contentView.bounds)) {
        return;
    }
    
    [self.firstColumnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(4.f);
        make.left.equalTo(self.contentView);
        make.width.equalTo(@(self.firstColumnWidth));
        make.height.equalTo(@60.f).priorityHigh();
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-4.f);
    }];
    
    [self.firstVerticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstColumnLabel.mas_top).offset(-4.f);
        make.bottom.equalTo(self.firstColumnLabel.mas_bottom).offset(4.f);
        make.right.equalTo(self.firstColumnLabel);
        make.width.equalTo(@0.5f);
    }];
    
    [self.firstColumnLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.contentView bringSubviewToFront:self.firstVerticalLine];
    
    if (self.rObj.items.count > 1) {
        [self layoutScrollView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:SLDataGridTableViewCellScrollNotification
                                                        object:self
                                                      userInfo:@{@"contentOffset":[NSValue valueWithCGPoint:scrollView.contentOffset]}];
}

#pragma mark - NSNotification
- (void)cellDidScrollNotification:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSValue *value = userInfo[@"contentOffset"];
    
    NSObject *obj = note.object;
    //自己发的通知，不做任何处理。
    if (obj != self) {
        [self.scrollView setContentOffset:[value CGPointValue]];
    }
}

#pragma mark - Private method
- (void)layoutScrollView {
    CGFloat width = [self getScrollViewWidth];
    [self.scrollView setContentSize:CGSizeMake(width, 0.f)];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstColumnLabel.mas_right);
        make.top.bottom.equalTo(self.firstColumnLabel);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self layoutScrollSubviews];
}

- (void)layoutScrollSubviews {
    [self.scrollView layoutIfNeeded];
    
    if (0 == CGRectGetWidth(self.scrollView.bounds)
        || 0 == CGRectGetHeight(self.scrollView.bounds)) {
        return;
    }
    
    NSArray *subviews = self.scrollView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *lastLabel = nil;
    NSInteger count = self.rObj.items.count;
    //从第二列开始计算，索引值从1开始
    for (NSInteger i = 1; i < count; i++) {
        SLDataGridListColumnItem *item = self.rObj.items[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = item.text;
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.height.equalTo(@(CGRectGetHeight(self.scrollView.bounds)));
            make.width.equalTo(@(self.otherColumnWidth));
            if (!lastLabel) {
                make.left.equalTo(self.scrollView.mas_left);
            } else {
                make.left.equalTo(lastLabel.mas_right);
            }
        }];
        
        lastLabel = label;
        
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:verticalLine];
        [verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_top).offset(-4.f);
            make.bottom.equalTo(label.mas_bottom).offset(4.f);
            make.right.equalTo(label);
            make.width.equalTo(@0.5f);
        }];
        
        [self.scrollView bringSubviewToFront:verticalLine];
    }
}

- (CGFloat)getScrollViewWidth {
    CGFloat width = 0.f;
    //屏幕剩余宽度
    CGFloat screenRemainingWidth = CGRectGetWidth(self.contentView.bounds) - self.firstColumnWidth;
    //从第二列开始计算
    NSInteger count = self.rObj.items.count - 1;
    if (count <= 1) {
        width = screenRemainingWidth;
    } else {
        width = count * self.otherColumnWidth;
        if (width < screenRemainingWidth) {
            width = screenRemainingWidth / count;
        }
    }
    
    return width;
}

#pragma mark - Setter
- (void)setRObj:(SLDataGridListRowObject *)rObj {
    _rObj = rObj;
    
    if (rObj && rObj.items.count > 0) {
        SLDataGridListColumnItem *item = rObj.items[0];
        self.firstColumnLabel.text = item.text;
    }
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setScrollViewContentOffset:(CGPoint)scrollViewContentOffset {
    _scrollViewContentOffset = scrollViewContentOffset;
    
    [self.scrollView setContentOffset:scrollViewContentOffset];
}

#pragma mark - Getter
- (UILabel *)firstColumnLabel {
    if (!_firstColumnLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        
        _firstColumnLabel = label;
    }
    
    return _firstColumnLabel;
}

- (UIView *)firstVerticalLine {
    if (!_firstVerticalLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:view];
        
        _firstVerticalLine = view;
    }
    
    return _firstVerticalLine;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.delegate = self;
        view.showsHorizontalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        view.backgroundColor = [UIColor clearColor];
        //禁用UIScrollView交互，防止UIScrollView拦截self.contentView的点击事件，然后把UIScrollView的拖动事件赋予self.contentView，让self.contentView来执行左右滚动事件
        view.userInteractionEnabled = NO;
        [self.contentView addGestureRecognizer:view.panGestureRecognizer];
        [self.contentView addSubview:view];
        
        _scrollView = view;
    }
    
    return _scrollView;
}

@end
