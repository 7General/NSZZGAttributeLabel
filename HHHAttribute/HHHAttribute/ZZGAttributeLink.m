//
//  ZZGAttributeLink.m
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import "ZZGAttributeLink.h"

@implementation ZZGAttributeLink

-(instancetype)initWithAttributeLink:(NSTextCheckingResult *)result{
    if (self = [super init]) {
        _result = result;
    
    }
    return self;
}

@end
