//
//  ZZGRunFlag.m
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import "ZZGRunFlag.h"

@implementation ZZGRunFlag
+ (ZZGRunFlag *)rangeFlagWithFlag:(NSString *)flag range:(NSRange)range {
    
    ZZGRunFlag *rangeFlag = [ZZGRunFlag new];
    rangeFlag.flag       = flag;
    rangeFlag.range      = range;
    
    return rangeFlag;
}
@end
