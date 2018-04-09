//
//  NSAttributeLabel.m
//  HHHAttribute
//
//  Created by zzg on 2018/4/9.
//  Copyright © 2018年 王会洲. All rights reserved.
//

#import "NSAttributedLabel.h"
#import <Availability.h>
#import "NSAttributedLabelLink.h"

NSString * const kNSBackgroundFillColorAttributeName = @"NSBackgroundFillColor";


@interface NSAttributedLabel()
@property (readwrite, nonatomic, strong) NSArray *linkModels;
@property (readwrite, nonatomic, copy) NSAttributedString *renderedAttributedText;
@property (readwrite, nonatomic, strong) NSAttributedLabelLink *activeLink;
@end


@implementation NSAttributedLabel{
@private
BOOL _needsFramesetter;
CTFramesetterRef _framesetter;
CTFramesetterRef _highlightFramesetter;
}
@synthesize attributedText = _attributedText;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)initData {
    self.userInteractionEnabled = YES;
    self.linkModels = [NSArray array];
    
    
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableInactiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableInactiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    if ([NSMutableParagraphStyle class]) {
        [mutableLinkAttributes setObject:[UIColor blueColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableActiveLinkAttributes setObject:[UIColor redColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableInactiveLinkAttributes setObject:[UIColor grayColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    } else {
        [mutableLinkAttributes setObject:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableActiveLinkAttributes setObject:(__bridge id)[[UIColor redColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableInactiveLinkAttributes setObject:(__bridge id)[[UIColor grayColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    }
    
//    self.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
//    self.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableActiveLinkAttributes];
//    self.inactiveLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableInactiveLinkAttributes];
//    _extendsLinkTouchArea = NO;

    
    
}


- (void)setText:(id)text {
    NSParameterAssert(!text || [text isKindOfClass:[NSAttributedString class]] || [text isKindOfClass:[NSString class]]);
    
    if ([text isKindOfClass:[NSString class]]) {
        [self setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:nil];
        return;
    }
    
    self.attributedText = text;
    self.activeLink = nil;
    
//    self.linkModels = [NSArray array];
//    if (text && self.attributedText && self.enabledTextCheckingTypes) {
//        __weak __typeof(self)weakSelf = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//            NSDataDetector *dataDetector = strongSelf.dataDetector;
//            if (dataDetector && [dataDetector respondsToSelector:@selector(matchesInString:options:range:)]) {
//                NSArray *results = [dataDetector matchesInString:[(NSAttributedString *)text string] options:0 range:NSMakeRange(0, [(NSAttributedString *)text length])];
//                if ([results count] > 0) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if ([[strongSelf.attributedText string] isEqualToString:[(NSAttributedString *)text string]]) {
//                            [strongSelf addLinksWithTextCheckingResults:results attributes:strongSelf.linkAttributes];
//                        }
//                    });
//                }
//            }
//        });
//    }
//
//    [self.attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(id value, __unused NSRange range, __unused BOOL *stop) {
//        if (value) {
//            NSURL *URL = [value isKindOfClass:[NSString class]] ? [NSURL URLWithString:value] : value;
//            [self addLinkToURL:URL withRange:range];
//        }
//    }];
}

- (void)setText:(id)text
afterInheritingLabelAttributesAndConfiguringWithBlock:(NSMutableAttributedString * (^)(NSMutableAttributedString *mutableAttributedString))block
{
    NSMutableAttributedString *mutableAttributedString = nil;
    if ([text isKindOfClass:[NSString class]]) {
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:NSAttributedStringAttributesFromLabel(self)];
    } else {
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
        [mutableAttributedString addAttributes:NSAttributedStringAttributesFromLabel(self) range:NSMakeRange(0, [mutableAttributedString length])];
    }
    
    if (block) {
        mutableAttributedString = block(mutableAttributedString);
    }
    
    [self setText:mutableAttributedString];
}

-(void)setLinkAttributes:(NSDictionary *)linkAttributes {
    _linkAttributes = convertNSAttributedStringAttributesToCTAttributes(linkAttributes);
}

- (NSAttributedLabelLink *)addLinkToURL:(NSURL *)url
                              withRange:(NSRange)range {
    return [self addLinkWithTextCheckingResult:[NSTextCheckingResult linkCheckingResultWithRange:range URL:url]];
}
- (NSAttributedLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    return [self addLinkWithTextCheckingResult:result attributes:self.linkAttributes];
}
- (NSAttributedLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                                               attributes:(NSDictionary *)attributes {
    return [self addLinksWithTextCheckingResults:@[result] attributes:attributes].firstObject;
}
- (NSArray *)addLinksWithTextCheckingResults:(NSArray *)results
                                  attributes:(NSDictionary *)attributes {
    NSMutableArray *links = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in results) {
        NSDictionary *activeAttributes = attributes ? self.activeLinkAttributes : nil;
        NSDictionary *inactiveAttributes = attributes ? self.inactiveLinkAttributes : nil;
        NSAttributedLabelLink *link = [[NSAttributedLabelLink alloc] initWithAttributes:attributes
                                                                         activeAttributes:activeAttributes
                                                                       inactiveAttributes:inactiveAttributes
                                                                       textCheckingResult:result];
        [links addObject:link];
    }
    [self addLinks:links];
    return links;
}
- (void)addLinks:(NSArray *)links {
    NSMutableArray *mutableLinkModels = [NSMutableArray arrayWithArray:self.linkModels];
    NSMutableAttributedString *mutableAttributedString = [self.attributedText mutableCopy];

    for (NSAttributedLabelLink *link in links) {
        if (link.attributes) {
            [mutableAttributedString addAttributes:link.attributes range:link.result.range];
        }
    }
    
    self.attributedText = mutableAttributedString;
    [self setNeedsDisplay];
    
    [mutableLinkModels addObjectsFromArray:links];
    
    self.linkModels = [NSArray arrayWithArray:mutableLinkModels];
}



#pragma mark-c++
static inline NSDictionary * NSAttributedStringAttributesFromLabel(NSAttributedLabel *label) {
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionary];
    
    [mutableAttributes setObject:label.font forKey:(NSString *)kCTFontAttributeName];
    [mutableAttributes setObject:label.textColor forKey:(NSString *)kCTForegroundColorAttributeName];
//    [mutableAttributes setObject:@(label.kern) forKey:(NSString *)kCTKernAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = label.textAlignment;
//    paragraphStyle.lineSpacing = label.lineSpacing;
//    paragraphStyle.minimumLineHeight = label.minimumLineHeight > 0 ? label.minimumLineHeight : label.font.lineHeight * label.lineHeightMultiple;
//    paragraphStyle.maximumLineHeight = label.maximumLineHeight > 0 ? label.maximumLineHeight : label.font.lineHeight * label.lineHeightMultiple;
//    paragraphStyle.lineHeightMultiple = label.lineHeightMultiple;
//    paragraphStyle.firstLineHeadIndent = label.firstLineIndent;
    
    if (label.numberOfLines == 1) {
        paragraphStyle.lineBreakMode = label.lineBreakMode;
    } else {
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    [mutableAttributes setObject:paragraphStyle forKey:(NSString *)kCTParagraphStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary:mutableAttributes];
}


static inline NSDictionary * convertNSAttributedStringAttributesToCTAttributes(NSDictionary *attributes) {
    if (!attributes) return nil;
    
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionary];
    
    NSDictionary *NSToCTAttributeNamesMap = @{
                                              NSFontAttributeName:            (NSString *)kCTFontAttributeName,
                                              NSBackgroundColorAttributeName: (NSString *)kNSBackgroundFillColorAttributeName,
                                              NSForegroundColorAttributeName: (NSString *)kCTForegroundColorAttributeName,
                                              NSUnderlineColorAttributeName:  (NSString *)kCTUnderlineColorAttributeName,
                                              NSUnderlineStyleAttributeName:  (NSString *)kCTUnderlineStyleAttributeName,
                                              NSStrokeWidthAttributeName:     (NSString *)kCTStrokeWidthAttributeName,
                                              NSStrokeColorAttributeName:     (NSString *)kCTStrokeWidthAttributeName,
                                              NSKernAttributeName:            (NSString *)kCTKernAttributeName,
                                              NSLigatureAttributeName:        (NSString *)kCTLigatureAttributeName
                                              };
    
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        key = [NSToCTAttributeNamesMap objectForKey:key] ? : key;
        
        if (![NSMutableParagraphStyle class]) {
            if ([value isKindOfClass:[UIFont class]]) {
                value = (__bridge id)CTFontRefFromUIFont(value);
            } else if ([value isKindOfClass:[UIColor class]]) {
                value = (__bridge id)((UIColor *)value).CGColor;
            }
        }
        
        [mutableAttributes setObject:value forKey:key];
    }];
    
    return [NSDictionary dictionaryWithDictionary:mutableAttributes];
}

static inline CTFontRef CTFontRefFromUIFont(UIFont * font) {
    CTFontRef ctfont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    return CFAutorelease(ctfont);
}




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
    CTFrameRef frame = CTFramesetterCreateFrame([self framesetter], CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CGPathRelease(path);
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
        CGFloat flushFactor = NSFlushFactorForTextAlignment(self.textAlignment);
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
    CGPathRelease(path);
    
    return idx;
}

- (CTFramesetterRef)framesetter {
    if (_needsFramesetter) {
        @synchronized(self) {
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.renderedAttributedText);
//            [self setFramesetter:framesetter];
//            [self setHighlightFramesetter:nil];
            _needsFramesetter = NO;
            
            if (framesetter) {
                CFRelease(framesetter);
            }
        }
    }
    
    return _framesetter;
}

- (NSAttributedString *)renderedAttributedText {
    if (!_renderedAttributedText) {
//        NSMutableAttributedString *fullString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//
//        if (self.attributedTruncationToken) {
//            [fullString appendAttributedString:self.attributedTruncationToken];
//        }
//
//        NSAttributedString *string = [[NSAttributedString alloc] initWithAttributedString:fullString];
//        self.renderedAttributedText = NSAttributedStringBySettingColorFromContext(string, self.textColor);
    }
    
    return _renderedAttributedText;
}

static inline CGFloat NSFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5f;
        case NSTextAlignmentRight:
            return 1.0f;
        case NSTextAlignmentLeft:
        default:
            return 0.0f;
    }
}

@end
