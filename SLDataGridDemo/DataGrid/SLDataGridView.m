//
//  SLDataGridView.m
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/10/16.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#import "SLDataGridView.h"
#import "SLDataGridTableViewCell.h"
#import "Masonry.h"
#import "SLMacroDefinition.h"

static NSString * const kReuseIdentifier = @"Cell";

@interface SLDataGridView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *headerScrollView;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) SLDataGridModel *model;
@property (nonatomic, strong) NSMutableArray *displayCellIndexPaths;
@property (nonatomic, assign) NSInteger refreshingPageNo;
@property (nonatomic) CGPoint headerScrollViewContentOffset;

@end

@implementation SLDataGridView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerViewHeight = 60.f;
        _firstColumnWidth = 120.f;
        _otherColumnWidth = 90.f;
        _model = [[SLDataGridModel alloc] init];
        _displayCellIndexPaths = @[].mutableCopy;
        _refreshingPageNo = 1;
        _headerScrollViewContentOffset = CGPointZero;
        
        //接收来自tableViewCell的滚动消息
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
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLDataGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    cell.rObj = self.model.lists.count > indexPath.row ? self.model.lists[indexPath.row] : nil;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-  (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (0 == indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor clearColor];
//    } else {
//        cell.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
//    }
    
//    //配置选中cell时的背景颜色
//    UIView *colorView = [[UIView alloc] init];
//    colorView.backgroundColor = RGBA_COLOR(17.f, 117.f, 172.f, 1.f);
//    colorView.clipsToBounds = YES;
//    cell.selectedBackgroundView = colorView;
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    if (![self.displayCellIndexPaths containsObject:indexPath]) {
        [self.displayCellIndexPaths addObject:indexPath];
        
        //设置未显示过的cell的偏移量
        ((SLDataGridTableViewCell *)cell).scrollViewContentOffset = self.headerScrollView.contentOffset;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = RGBA_COLOR(135.f, 206.f, 235.f, 1.f);
    
    [self settingHeaderFixedLabelAtView:headerView];
    [self settingHeaderScrollViewAtView:headerView];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.headerScrollView) {
        self.headerScrollViewContentOffset = scrollView.contentOffset;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SLDataGridTableViewCellScrollNotification
                                                            object:self.headerScrollView
                                                          userInfo:@{@"contentOffset":[NSValue valueWithCGPoint:scrollView.contentOffset]}];
    }
}

#pragma mark - NSNotification
- (void)cellDidScrollNotification:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGPoint offSet = [userInfo[@"contentOffset"] CGPointValue];
    
    NSObject *obj = note.object;
    //自己发的通知，不做任何处理。
    if (obj != self.headerScrollView) {
        self.headerScrollView.contentOffset = offSet;
        self.headerScrollViewContentOffset = offSet;
    }
}

#pragma mark - Interface method
- (void)configViewWithObj:(SLDataGridModel *)mObj {
    self.model = mObj;
    
    [self.tableView reloadData];
}

#pragma mark - Private method
- (void)settingHeaderFixedLabelAtView:(UIView *)superView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColor clearColor];
    [superView addSubview:label];
    
    if (self.model.header.items.count > 0) {
        SLDataGridHeaderItem *item = self.model.header.items[0];
        label.text = item.text;
        if (item.textColor) {
            label.textColor = item.textColor;
        }
    } else {
        label.text = @"-";
    }
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(superView);
        make.width.equalTo(@(self.firstColumnWidth));
    }];
}

- (void)settingHeaderScrollViewAtView:(UIView *)superView {
    self.headerScrollView = [[UIScrollView alloc] init];
    self.headerScrollView.showsVerticalScrollIndicator = NO;
    self.headerScrollView.showsHorizontalScrollIndicator = NO;
    self.headerScrollView.backgroundColor = [UIColor clearColor];
    self.headerScrollView.delegate = self;
    [superView addSubview:self.headerScrollView];
    
    CGFloat width = [self getHeaderScrollViewWidth];
    [self.headerScrollView setContentSize:CGSizeMake(width, 0.f)];
    [self.headerScrollView setContentOffset:self.headerScrollViewContentOffset];
    
    [self.headerScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(self.firstColumnWidth);
        make.top.bottom.right.equalTo(superView);
    }];
    
    [self layoutHeaderScrollSubviews];
}

- (CGFloat)getHeaderScrollViewWidth {
    CGFloat width = 0.f;
    //屏幕剩余宽度
    CGFloat screenRemainingWidth = CGRectGetWidth(self.bounds) - self.firstColumnWidth;
    //从第二列开始计算
    NSInteger count = self.model.header.items.count - 1;
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

- (void)layoutHeaderScrollSubviews {
    UILabel *lastLabel = nil;
    
    NSInteger count = self.model.header.items.count;
    CGFloat width = [self getHeaderScrollViewWidth] / (0 == count ? 1 : (count - 1));
    //从第二列开始计算，索引值从1开始
    for (NSInteger i = 1; i < count; i++) {
        SLDataGridHeaderItem *item = self.model.header.items[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = item.text;
        
        label.font = [UIFont systemFontOfSize:16.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = item.textColor ? : [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.headerScrollView addSubview:label];
        
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerScrollView);
            make.width.equalTo(@(width));
            make.height.equalTo(@(self.headerViewHeight));
            if (!lastLabel) {
                make.left.equalTo(self.headerScrollView.mas_left);
            } else {
                make.left.equalTo(lastLabel.mas_right);
            }
        }];
        lastLabel = label;
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorColor = [UIColor blackColor];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 80.f;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.tableFooterView = [UIView new];
        tableView.allowsSelection = NO;
        [tableView registerClass:[SLDataGridTableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
        [self addSubview:tableView];
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSArray<NSIndexPath *> *)indexPathsForVisibleRows {
    return self.tableView.indexPathsForVisibleRows;
}

@end
