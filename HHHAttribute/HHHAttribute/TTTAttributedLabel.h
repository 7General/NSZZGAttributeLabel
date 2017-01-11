

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@class TTTAttributedLabelLink;

/**
 Vertical alignment for text in a label whose bounds are larger than its text bounds
 */
typedef NS_ENUM(NSInteger, TTTAttributedLabelVerticalAlignment) {
    TTTAttributedLabelVerticalAlignmentCenter   = 0,
    TTTAttributedLabelVerticalAlignmentTop      = 1,
    TTTAttributedLabelVerticalAlignmentBottom   = 2,
};





@interface TTTAttributedLabel : UILabel <NSObject>


/**
 An array of `NSTextCheckingResult` objects for links detected or manually added to the label text.
 */
@property (readonly, nonatomic, strong) NSArray *links;

/**
 The edge inset for the background of a link. The default value is `{0, -1, 0, -1}`.
 */
@property (nonatomic, assign) UIEdgeInsets linkBackgroundEdgeInset;


/**
 The line height multiple. This value is 1.0 by default.
 */
@property (nonatomic, assign) IBInspectable CGFloat lineHeightMultiple;

/**
 The distance, in points, from the margin to the text container. This value is `UIEdgeInsetsZero` by default.
 
 @discussion The `UIEdgeInset` members correspond to paragraph style properties rather than a particular geometry, and can change depending on the writing direction.
 
 ## `UIEdgeInset` Member Correspondence With `CTParagraphStyleSpecifier` Values:
 
 - `top`: `kCTParagraphStyleSpecifierParagraphSpacingBefore`
 - `left`: `kCTParagraphStyleSpecifierHeadIndent`
 - `bottom`: `kCTParagraphStyleSpecifierParagraphSpacing`
 - `right`: `kCTParagraphStyleSpecifierTailIndent`
 
 */
@property (nonatomic, assign) IBInspectable UIEdgeInsets textInsets;

/**
 The vertical text alignment for the label, for when the frame size is greater than the text rect size. The vertical alignment is `TTTAttributedLabelVerticalAlignmentCenter` by default.
 */
@property (nonatomic, assign) TTTAttributedLabelVerticalAlignment verticalAlignment;


///--------------------------
/// @name Long press gestures
///--------------------------

/**
 *  The long-press gesture recognizer used internally by the label.
 */
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;


///------------------------------------
/// @name Accessing the Text Attributes
///------------------------------------

/**
 A copy of the label's current attributedText. This returns `nil` if an attributed string has never been set on the label.
 
 @warning Do not set this property directly. Instead, set @c text to an @c NSAttributedString.
 */
@property (readwrite, nonatomic, copy) NSAttributedString *attributedText;

@end

