//
//  ZZGLabel.m
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import "ZZGLabel.h"
#import "ZZGRunFlag.h"
#import "ZZGAttributeLink.h"
#import<CoreText/CoreText.h>
#import "NSString+ZZGAttribute.h"



@interface ZZGLabel(){
@private
BOOL _needsFramesetter;
CTFramesetterRef _framesetter;
CTFramesetterRef _highlightFramesetter;
}

/**超链接数据*/
@property (nonatomic, strong) NSMutableArray * links;

/**鉴别类型*/
@property (nonatomic, strong) NSMutableArray * textCheckingResoult;
@property (readwrite, nonatomic, copy) NSAttributedString *renderedAttributedText;


@property (nonatomic, strong) ZZGAttributeLink * ActiveLink;
@end

@implementation ZZGLabel

-(NSMutableArray *)links{
    if (_links == nil) {
        _links = [NSMutableArray new];
    }
    return _links;
}
- (NSAttributedString *)renderedAttributedText {
    if (!_renderedAttributedText) {
        self.renderedAttributedText = NSAttributedStringBySettingColorFromContext(self.attributedText, self.textColor);
    }
    return _renderedAttributedText;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView {
    self.userInteractionEnabled = YES;
    self.numberOfLines = 0;
    self.multipleTouchEnabled = NO;
    self.textCheckingResoult = [NSMutableArray new];
    self.adjustsFontSizeToFitWidth = NO;
}

- (void)resetSize {
    [self sizeToFit];
    CGFloat x      = self.frame.origin.x;
    CGFloat y      = self.frame.origin.y;
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}


#pragma mark - 添加关键字富文本
-(void)addLinkStringRange:(NSRange)range flag:(NSString *)flag {
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributeString];
    NSDictionary *keyFC = @{ NSKernAttributeName:@.5f,NSForegroundColorAttributeName:[UIColor redColor]};
    [attStr addAttributes:keyFC range:range];
    self.attributeString = attStr;
    
    [self.links addObject:[ZZGRunFlag rangeFlagWithFlag:flag range:range]];
}

-(void)ApplayDraw {
//    self.attributedText = self.attributeString;
//    [self setAttribute:self.attributeString];
    [super setText:[self.attributeString string]];
    /**组装连接类型*/
    [self.links enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZGRunFlag *rangeflag = self.links[idx];
        NSTextCheckingResult * resoult = [NSTextCheckingResult linkCheckingResultWithRange:rangeflag.range URL:[NSURL URLWithString:rangeflag.flag]];
        ZZGAttributeLink * link = [[ZZGAttributeLink alloc] initWithAttributeLink:resoult];
        [self.textCheckingResoult addObject:link];
    }];
}




//-(void)setAttributeString:(NSAttributedString *)attributeString{
//    [self setNeedsDisplay];
//    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
//        [self invalidateIntrinsicContentSize];
//    }
    

//}


// steup 获取点击位置对
#pragma mark - 触摸事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    self.ActiveLink = [self linkAtPoint:[touch locationInView:self]];
    [super touchesBegan:touches withEvent:event];
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSTextCheckingResult *result = self.ActiveLink.result;
    if (result.resultType == NSTextCheckingTypeLink) {
        NSLog(@"=======================================%@",result.URL.absoluteString);
    }
    [super touchesEnded:touches withEvent:event];
}

-(ZZGAttributeLink *)linkAtPoint:(CGPoint)point{
    CFIndex idx = [self characterIndexAtPoint:point];
    
    if (!NSLocationInRange((NSUInteger)idx, NSMakeRange(0, self.attributeString.length))) {
        return nil;
    }
    
    NSEnumerator *enumerator = [self.textCheckingResoult reverseObjectEnumerator];
    ZZGAttributeLink *link = nil;
    while ((link = [enumerator nextObject])) {
        if (NSLocationInRange((NSUInteger)idx, link.result.range)) {
            return link;
        }
    }
    return nil;
}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////###########################################
///**获取点击文字在文章的**索引***/
- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    if (!CGRectContainsPoint(self.bounds, p)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    p = CGPointMake(p.x, textRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    //CTFrameRef frame = CTFramesetterCreateFrame([self framesetter], CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributeString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    CFIndex idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
        
        // Apply penOffset using flushFactor for horizontal alignment to set lineOrigin since this is the horizontal offset from drawFramesetter
        CGFloat flushFactor = 0.5f;//TTTFlushFactorForTextAlignment(self.textAlignment);
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        lineOrigin.x = penOffset;
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    NSLog(@"点击index:%ld",idx);
    return idx;
}


- (CGRect)textRectForBounds:(CGRect)bounds
     limitedToNumberOfLines:(NSInteger)numberOfLines
{
    bounds = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsZero);
    if (!self.attributedText) {
        return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    
    CGRect textRect = bounds;
    
    // Calculate height with a minimum of double the font pointSize, to ensure that CTFramesetterSuggestFrameSizeWithConstraints doesn't return CGSizeZero, as it would if textRect height is insufficient.
    textRect.size.height = MAX(self.font.lineHeight * MAX(2, numberOfLines), bounds.size.height);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    // Adjust the text to be in the center vertically, if the text size is smaller than bounds
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, (CFIndex)[self.attributedText length]), NULL, textRect.size, NULL);
//    textSize = CGSizeMake(CGFloat_ceil(textSize.width), CGFloat_ceil(textSize.height));
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height)); // Fix for iOS 4,
    // Fix for iOS 4, CTFramesetterSuggestFrameSizeWithConstraints sometimes returns fractional sizes
    
    if (textSize.height < bounds.size.height) {
        CGFloat yOffset = 0.0f;
//        switch (self.verticalAlignment) {
//            case TTTAttributedLabelVerticalAlignmentCenter:
                yOffset = floor((bounds.size.height - textSize.height) / 2.0f);
//                break;
//            case TTTAttributedLabelVerticalAlignmentBottom:
//                yOffset = bounds.size.height - textSize.height;
//                break;
//            case TTTAttributedLabelVerticalAlignmentTop:
//            default:
//                break;
//        }
        
        textRect.origin.y += yOffset + 10;
    }
    return textRect;
}


static inline NSAttributedString * NSAttributedStringBySettingColorFromContext(NSAttributedString *attributedString, UIColor *color) {
    if (!color) {
        return attributedString;
    }
    
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString enumerateAttribute:(NSString *)kCTForegroundColorFromContextAttributeName inRange:NSMakeRange(0, [mutableAttributedString length]) options:0 usingBlock:^(id value, NSRange range, __unused BOOL *stop) {
        BOOL usesColorFromContext = (BOOL)value;
        if (usesColorFromContext) {
            [mutableAttributedString setAttributes:[NSDictionary dictionaryWithObject:color forKey:(NSString *)kCTForegroundColorAttributeName] range:range];
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorFromContextAttributeName range:range];
        }
    }];
    
    return mutableAttributedString;
}


- (CTFramesetterRef)framesetter {
    if (_needsFramesetter) {
        @synchronized(self) {
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.renderedAttributedText);
            [self setFramesetter:framesetter];
            [self setHighlightFramesetter:nil];
            _needsFramesetter = NO;
            
            if (framesetter) {
                CFRelease(framesetter);
            }
        }
    }
    
    return _framesetter;
}

- (void)setFramesetter:(CTFramesetterRef)framesetter {
    if (framesetter) {
        CFRetain(framesetter);
    }
    
    if (_framesetter) {
        CFRelease(_framesetter);
    }
    
    _framesetter = framesetter;
}

- (CTFramesetterRef)highlightFramesetter {
    return _highlightFramesetter;
}

- (void)setHighlightFramesetter:(CTFramesetterRef)highlightFramesetter {
    if (highlightFramesetter) {
        CFRetain(highlightFramesetter);
    }
    
    if (_highlightFramesetter) {
        CFRelease(_highlightFramesetter);
    }
    
    _highlightFramesetter = highlightFramesetter;
}




@end
