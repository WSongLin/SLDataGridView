//
//  SLDataGridModel.h
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/10/15.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SLDataGridHeader, SLDataGridHeaderItem, SLDataGridListRowObject, SLDataGridListColumnItem;

@interface SLDataGridModel : NSObject

@property (nonatomic, strong) SLDataGridHeader *header;
@property (nonatomic, strong) NSArray<SLDataGridListRowObject *> *lists;

@end


@interface SLDataGridHeader : NSObject

@property (nonatomic, strong) NSArray<SLDataGridHeaderItem *> *items;

@end

@interface SLDataGridHeaderItem : NSObject

@property (nonatomic, copy) NSString *key; //用来匹配SLDataGridListItem对象
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;

@end

@interface SLDataGridListRowObject : NSObject

@property (nonatomic, strong) NSArray<SLDataGridListColumnItem *> *items;

@end

@interface SLDataGridListColumnItem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *subText; //副加文字

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *subTextColor;

@end


