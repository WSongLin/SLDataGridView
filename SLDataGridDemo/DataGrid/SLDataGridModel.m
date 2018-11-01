//
//  SLDataGridModel.m
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/10/15.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#import "SLDataGridModel.h"

@implementation SLDataGridModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _header = [SLDataGridHeader new];
        _lists = @[];
    }
    
    return self;
}

@end

@implementation SLDataGridHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = @[];
    }
    
    return self;
}

@end

@implementation SLDataGridHeaderItem

@end

@implementation SLDataGridListRowObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = @[];
    }
    
    return self;
}

@end

@implementation SLDataGridListColumnItem

@end
