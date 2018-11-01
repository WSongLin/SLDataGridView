//
//  SLDataGridTableViewCell.h
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/10/16.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLDataGridListRowObject;

UIKIT_EXTERN NSString * const SLDataGridTableViewCellScrollNotification;

@interface SLDataGridTableViewCell : UITableViewCell

/**
 cell第一列宽度，默认120.f（水平方向滚动时该列固定不动）
 */
@property (nonatomic, assign) CGFloat firstColumnWidth;

/**
 cell第一列之后的其他列宽度，默认90.f
 */
@property (nonatomic, assign) CGFloat otherColumnWidth;

/**
 cell滚动视图内容偏移量，默认CGPointZero
 */
@property (nonatomic) CGPoint scrollViewContentOffset;

@property (nonatomic, strong) SLDataGridListRowObject *rObj;

@end

