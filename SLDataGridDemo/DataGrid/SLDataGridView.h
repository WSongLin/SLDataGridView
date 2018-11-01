//
//  SLDataGridView.h
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/10/16.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLDataGridModel.h"

@interface SLDataGridView : UIView

/**
 网格头部高度，默认60.f（垂直方向滚动时该头部固定不动）
 */
@property (nonatomic, assign) CGFloat headerViewHeight;

/**
 网格第一列宽度，默认120.f（水平方向滚动时该列固定不动）
 */
@property (nonatomic, assign) CGFloat firstColumnWidth;

/**
 网格第一列之后的其他列宽度，默认90.f
 */
@property (nonatomic, assign) CGFloat otherColumnWidth;

/**
 当前屏幕显示cell的索引值集合
 */
@property (nonatomic, readonly) NSArray<NSIndexPath *> *indexPathsForVisibleRows;

- (void)configViewWithObj:(SLDataGridModel *)mObj;

@end

