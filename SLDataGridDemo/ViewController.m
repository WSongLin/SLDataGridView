//
//  ViewController.m
//  SLDataGridDemo
//
//  Created by sl on 2018/11/1.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "ViewController.h"
#import "SLDataGridView.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, weak) SLDataGridView *dataGridView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.dataGridView configViewWithObj:[self reformDataGridDatas]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.dataGridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (SLDataGridModel *)reformDataGridDatas {
    SLDataGridModel *model = [[SLDataGridModel alloc] init];
    model.header.items = [self dataGridTitles];
    
    NSInteger colCount = model.header.items.count;
    NSMutableArray *rows = @[].mutableCopy;
    for (NSInteger row = 0; row < 20; row++) {
        SLDataGridListRowObject *rObj = [[SLDataGridListRowObject alloc] init];
        
        //获取每一行的所有item
        NSMutableArray *columnItems = @[].mutableCopy;
        for (NSInteger col = 0; col < colCount; col++) {
            SLDataGridListColumnItem *cItem = [[SLDataGridListColumnItem alloc] init];
            if (0 == col) {
                cItem.text = [NSString stringWithFormat:@"表格水平方向滚动时固定文本-%ld", (long)(row + 1)];
            } else {
                cItem.text = [NSString stringWithFormat:@"第%ld行第%ld列", (long)(row + 1), (long)(col + 1)];
            }
            
            [columnItems addObject:cItem];
        }
        
        rObj.items = [NSArray arrayWithArray:columnItems];
        [rows addObject:rObj];
    }
    
    model.lists = [NSArray arrayWithArray:rows];
    
    return model;
}

- (NSArray *)dataGridTitles {
    NSArray *array = @[@"固定头部文本",
                       @"滚动头部第一列文本",
                       @"滚动头部第二列文本",
                       @"滚动头部第三列文本",
                       @"滚动头部第四列文本",
                       @"滚动头部第五列文本"
                       ];
    
    NSMutableArray *titles = @[].mutableCopy;
    for (NSInteger i = 0; i < array.count; i++) {
        SLDataGridHeaderItem *item = [SLDataGridHeaderItem new];
        item.text = array[i];
        [titles addObject:item];
    }
    
    return titles.mutableCopy;
}

#pragma mark - Getter
- (SLDataGridView *)dataGridView {
    if (!_dataGridView) {
        SLDataGridView *view = [[SLDataGridView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        
        _dataGridView = view;
    }
    
    return _dataGridView;
}

@end
