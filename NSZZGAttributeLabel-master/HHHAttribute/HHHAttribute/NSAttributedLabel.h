

#import <UIKit/UIKit.h>
#import "NSAttributedLabelLink.h"
#import <CoreText/CoreText.h>


FOUNDATION_EXPORT double NSAttributedLabelVersionNumber;


FOUNDATION_EXPORT const unsigned char NSAttributedLabelVersionString[];


typedef NS_ENUM(NSInteger, NSAttributedLabelVerticalAlignment) {
    NSAttributedLabelVerticalAlignmentCenter   = 0,
    NSAttributedLabelVerticalAlignmentTop      = 1,
    NSAttributedLabelVerticalAlignmentBottom   = 2,
};

extern NSString * const kNSStrikeOutAttributeName;

extern NSString * const kNSBackgroundFillColorAttributeName;

extern NSString * const kNSBackgroundFillPaddingAttributeName;

extern NSString * const kNSBackgroundStrokeColorAttributeName;

extern NSString * const kNSBackgroundLineWidthAttributeName;

extern NSString * const kNSBackgroundCornerRadiusAttributeName;

@protocol NSAttributedLabelDelegate;

// Override UILabel @property to accept both NSString and NSAttributedString
@protocol NSAttributedLabel <NSObject>
@property (nonatomic, copy) IBInspectable id text;
@end

IB_DESIGNABLE

@interface NSAttributedLabel : UILabel <NSAttributedLabel, UIGestureRecognizerDelegate>


- (instancetype) init NS_UNAVAILABLE;

@property (nonatomic, unsafe_unretained) IBOutlet id <NSAttributedLabelDelegate> delegate;

@property (nonatomic, assign) NSTextCheckingTypes enabledTextCheckingTypes;


@property (readonly, nonatomic, strong) NSArray *links;


@property (nonatomic, strong) NSDictionary *linkAttributes;


@property (nonatomic, strong) NSDictionary *activeLinkAttributes;


@property (nonatomic, strong) NSDictionary *inactiveLinkAttributes;


@property (nonatomic, assign) UIEdgeInsets linkBackgroundEdgeInset;


@property (nonatomic, assign) BOOL extendsLinkTouchArea;

@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;

@property (nonatomic, assign) IBInspectable CGFloat highlightedShadowRadius;

@property (nonatomic, assign) IBInspectable CGSize highlightedShadowOffset;

@property (nonatomic, strong) IBInspectable UIColor *highlightedShadowColor;


@property (nonatomic, assign) IBInspectable CGFloat kern;

@property (nonatomic, assign) IBInspectable CGFloat firstLineIndent;


@property (nonatomic, assign) IBInspectable CGFloat lineSpacing;


@property (nonatomic, assign) IBInspectable CGFloat minimumLineHeight;

@property (nonatomic, assign) IBInspectable CGFloat maximumLineHeight;


@property (nonatomic, assign) IBInspectable CGFloat lineHeightMultiple;


@property (nonatomic, assign) IBInspectable UIEdgeInsets textInsets;


@property (nonatomic, assign) NSAttributedLabelVerticalAlignment verticalAlignment;

@property (nonatomic, strong) IBInspectable NSAttributedString *attributedTruncationToken;


@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;


+ (CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString
                       withConstraints:(CGSize)size
                limitedToNumberOfLines:(NSUInteger)numberOfLines;

- (void)setText:(id)text;


- (void)setText:(id)text
afterInheritingLabelAttributesAndConfiguringWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block;


@property (readwrite, nonatomic, copy) NSAttributedString *attributedText;


- (void)addLink:(NSAttributedLabelLink *)link;


- (NSAttributedLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result;


- (NSAttributedLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                                               attributes:(NSDictionary *)attributes;


- (NSAttributedLabelLink *)addLinkToURL:(NSURL *)url
                               withRange:(NSRange)range;


- (NSAttributedLabelLink *)addLinkToAddress:(NSDictionary *)addressComponents
                                   withRange:(NSRange)range;


- (NSAttributedLabelLink *)addLinkToPhoneNumber:(NSString *)phoneNumber
                                       withRange:(NSRange)range;


- (NSAttributedLabelLink *)addLinkToDate:(NSDate *)date
                                withRange:(NSRange)range;


- (NSAttributedLabelLink *)addLinkToDate:(NSDate *)date
                                 timeZone:(NSTimeZone *)timeZone
                                 duration:(NSTimeInterval)duration
                                withRange:(NSRange)range;


- (NSAttributedLabelLink *)addLinkToTransitInformation:(NSDictionary *)components
                                              withRange:(NSRange)range;


- (BOOL)containslinkAtPoint:(CGPoint)point;


- (NSAttributedLabelLink *)linkAtPoint:(CGPoint)point;

@end


@protocol NSAttributedLabelDelegate <NSObject>
@optional

- (void)attributedLabel:(NSAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;


- (void)attributedLabel:(NSAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents;


- (void)attributedLabel:(NSAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber;


- (void)attributedLabel:(NSAttributedLabel *)label
  didSelectLinkWithDate:(NSDate *)date;


- (void)attributedLabel:(NSAttributedLabel *)label
  didSelectLinkWithDate:(NSDate *)date
               timeZone:(NSTimeZone *)timeZone
               duration:(NSTimeInterval)duration;


- (void)attributedLabel:(NSAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components;


- (void)attributedLabel:(NSAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result;


- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point;


- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithAddress:(NSDictionary *)addressComponents
                atPoint:(CGPoint)point;


- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber
                atPoint:(CGPoint)point;



- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithDate:(NSDate *)date
                atPoint:(CGPoint)point;



- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithDate:(NSDate *)date
               timeZone:(NSTimeZone *)timeZone
               duration:(NSTimeInterval)duration
                atPoint:(CGPoint)point;



- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithTransitInformation:(NSDictionary *)components
                atPoint:(CGPoint)point;

- (void)attributedLabel:(NSAttributedLabel *)label
didLongPressLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point;

@end


