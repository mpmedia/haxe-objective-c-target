//
//  UITextField.h
package objc.ios.ui;
//
//  Copyright (c) 2005-2012, Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIFont.h>
#import <UIKit/UIStringDrawing.h>
#import <UIKit/UITextInput.h>

@class UIImage, UIImageView, UILabel, UIColor, UIButton;
@class UITextFieldAtomBackgroundView;
@class UITextFieldBackgroundView;
@class UITextFieldBorderView;
@class UITextFieldLabel;
@class UITextInputTraits;
@class UITextSelectionView;
@class UITextInteractionAssistant;
@class UIPopoverController;
extern interface UITextFieldDelegate;
extern interface UITextSelecting;

typedef NS_ENUM(NSInteger, UITextBorderStyle) {
    UITextBorderStyleNone,
    UITextBorderStyleLine,
    UITextBorderStyleBezel,
    UITextBorderStyleRoundedRect
};

typedef NS_ENUM(NSInteger, UITextFieldViewMode) {
    UITextFieldViewModeNever,
    UITextFieldViewModeWhileEditing,
    UITextFieldViewModeUnlessEditing,
    UITextFieldViewModeAlways
};

extern class UITextField : UIControl <UITextInput, NSCoding> {
  @private
    NSAttributedString *_text;
    UIColor            *_textColor;
    UITextBorderStyle   _borderStyle;
    CGFloat             _minimumFontSize;
    id                  _delegate;
    UIImage            *_background;
    UIImage            *_disabledBackground;
    UITextFieldViewMode _clearButtonMode;
    UIView             *_leftView;
    UITextFieldViewMode _leftViewMode;
    UIView             *_rightView;
    UITextFieldViewMode _rightViewMode;

    UITextInputTraits  *_traits;
    UITextInputTraits  *_nonAtomTraits;
    CGFloat             _fullFontSize; // font size to use when no shrinkage is needed.
    CGFloat             _paddingLeft;
    CGFloat             _paddingTop;
    CGFloat             _paddingRight;
    CGFloat             _paddingBottom;
    NSString           *_textFont; // This ivar will go away. This is deprecated and people should use _font
    NSRange             _selectionRange;
    int                 _scrollXOffset;
    int                 _scrollYOffset;
    float               _progress;
    NSString           *_style;
    
    UIButton           *_clearButton;
    CGSize              _clearButtonOffset;
    
    CGSize              _leftViewOffset;
    CGSize              _rightViewOffset;

    UITextFieldBorderView     *_backgroundView;
    UITextFieldBorderView     *_disabledBackgroundView;
    UITextFieldBackgroundView *_systemBackgroundView;
    
    UITextFieldLabel *_textLabel;
    UITextFieldLabel *_placeholderLabel;
    UITextFieldLabel *_suffixLabel;
    UITextFieldLabel *_prefixLabel;
    UIImageView      *_iconView;
    UILabel          *_label;
    CGFloat          _labelOffset;
    
    UITextInteractionAssistant *_interactionAssistant;
    
    UIView             *_inputView;
    UIView             *_inputAccessoryView;

    UITextFieldAtomBackgroundView *_atomBackgroundView;
    
    UIColor         *_shadowColor;
    CGSize           _shadowOffset;
    CGFloat          _shadowBlur;

    struct {
        unsigned int secureTextChanged:1;
        unsigned int guard:1;
        unsigned int delegateRespondsToHandleKeyDown:1;
        unsigned int verticallyCenterText:1;
        unsigned int isAnimating:4;
        unsigned int inactiveHasDimAppearance:1;
        unsigned int becomesFirstResponderOnClearButtonTap:1;
        unsigned int clearsOnBeginEditing:1;
        unsigned int clearsPlaceholderOnBeginEditing:1;
        unsigned int adjustsFontSizeToFitWidth:1;
        unsigned int fieldEditorAttached:1;
        unsigned int canBecomeFirstResponder:1;
        unsigned int shouldSuppressShouldBeginEditing:1;
        unsigned int inResignFirstResponder:1;
        unsigned int undoDisabled:1;
        unsigned int contentsRTL:1;
        unsigned int explicitAlignment:1;
        unsigned int implementsCustomDrawing:1;
        unsigned int needsClearing:1;
        unsigned int suppressContentChangedNotification:1;
        unsigned int allowsEditingTextAttributes:1;
        unsigned int usesAttributedText:1;
        unsigned int backgroundViewState:2;
        unsigned int clearsOnInsertion:1;
    } _textFieldFlags;
}

// End ivars
// =============================================================================
// Begin SDK properties

public var    NSString               *text;                 // default is nil
public var    NSAttributedString     *attributedText NS_AVAILABLE_IOS(6_0); // default is nil
	public var (nonatomic,retain) UIColor                *textColor;            // default is nil. use opaque black
	public var (nonatomic,retain) UIFont                 *font;                 // default is nil. use system font 12 pt
	public var         NSTextAlignment         textAlignment;        // default is NSLeftTextAlignment
	public var         UITextBorderStyle       borderStyle;          // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
public var    NSString               *placeholder;          // default is nil. string is drawn 70% gray
public var    NSAttributedString     *attributedPlaceholder NS_AVAILABLE_IOS(6_0); // default is nil
	public var         BOOL                    clearsOnBeginEditing; // default is NO which moves cursor to location clicked. if YES, all text cleared
	public var         BOOL                    adjustsFontSizeToFitWidth; // default is NO. if YES, text will shrink to minFontSize along baseline
	public var         CGFloat                 minimumFontSize;      // default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
	public var  id<UITextFieldDelegate> delegate;             // default is nil. weak reference
	public var (nonatomic,retain) UIImage                *background;           // default is nil. draw in border rect. image should be stretchable
	public var (nonatomic,retain) UIImage                *disabledBackground;   // default is nil. ignored if background not set. image should be stretchable

	public var (nonatomic,readonly,getter=isEditing) BOOL editing;
	public var  BOOL allowsEditingTextAttributes NS_AVAILABLE_IOS(6_0); // default is NO. allows editing text attributes with style operations and pasting rich text
public var  NSDictionary *typingAttributes NS_AVAILABLE_IOS(6_0); // automatically resets when the selection changes

// You can supply custom views which are displayed at the left or right
// sides of the text field. Uses for such views could be to show an icon or
// a button to operate on the text in the field in an application-defined
// manner.
// 
// A very common use is to display a clear button on the right side of the
// text field, and a standard clear button is provided. Note: if the clear
// button overlaps one of the other views, the clear button will be given
// precedence.

	public var         UITextFieldViewMode  clearButtonMode; // sets when the clear button shows up. default is UITextFieldViewModeNever

	public var (nonatomic,retain) UIView              *leftView;        // e.g. magnifying glass
	public var         UITextFieldViewMode  leftViewMode;    // sets when the left view shows up. default is UITextFieldViewModeNever

	public var (nonatomic,retain) UIView              *rightView;       // e.g. bookmarks button
	public var         UITextFieldViewMode  rightViewMode;   // sets when the right view shows up. default is UITextFieldViewModeNever

// drawing and positioning overrides

- (CGRect)borderRectForBounds:(CGRect)bounds;
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)placeholderRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;
- (CGRect)clearButtonRectForBounds:(CGRect)bounds;
- (CGRect)leftViewRectForBounds:(CGRect)bounds;
- (CGRect)rightViewRectForBounds:(CGRect)bounds;

	public function drawTextInRect:(CGRect)rect;
	public function drawPlaceholderInRect:(CGRect)rect;

// Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
// set while first responder, will not take effect until reloadInputViews is called.
	public var  (readwrite, retain) UIView *inputView;             
	public var  (readwrite, retain) UIView *inputAccessoryView;

	public var  BOOL clearsOnInsertion NS_AVAILABLE_IOS(6_0); // defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.

}

extern class UIView (UITextField)
- (BOOL)endEditing:(BOOL)force;    // use to make the view or any subview that is the first responder resign (optionally force)
}

extern interface UITextFieldDelegate <NSObject>

@optional

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
	public function textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
	public function textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

}

UIKIT_EXTERN NSString *const UITextFieldTextDidBeginEditingNotification;
UIKIT_EXTERN NSString *const UITextFieldTextDidEndEditingNotification;
UIKIT_EXTERN NSString *const UITextFieldTextDidChangeNotification;

