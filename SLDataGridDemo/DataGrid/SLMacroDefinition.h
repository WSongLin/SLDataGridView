//
//  SLMacroDefinition.h
//  PLIntelligentEnergyPro
//
//  Created by sl on 2018/9/20.
//  Copyright © 2018年 Pilot. All rights reserved.
//

#ifdef DEBUG
#define DLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif


#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH SCREEN_SIZE.width
#define SCREEN_HEIGHT SCREEN_SIZE.height


#define SLWeakSelf(type) __weak typeof(type) weakSelf = type
#define SLStrongSelf(type) __strong typeof(type) strongSelf = type

#define RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:r / 255.f\
                                               green:g / 255.f\
                                                blue:b / 255.f\
                                               alpha:a]

