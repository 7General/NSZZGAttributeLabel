//
//  NSAttributedLabelLink.m
//  HHHAttribute
//
//  Created by zzg on 2018/4/9.
//  Copyright © 2018年 王会洲. All rights reserved.
//

#import "NSAttributedLabelLink.h"

@implementation NSAttributedLabelLink

- (instancetype)initWithAttributes:(NSDictionary *)attributes
                  activeAttributes:(NSDictionary *)activeAttributes
                inactiveAttributes:(NSDictionary *)inactiveAttributes
                textCheckingResult:(NSTextCheckingResult *)result {
    
    if ((self = [super init])) {
        _result = result;
        _attributes = [attributes copy];
        _activeAttributes = [activeAttributes copy];
        _inactiveAttributes = [inactiveAttributes copy];
    }
    
    return self;
}

@end
