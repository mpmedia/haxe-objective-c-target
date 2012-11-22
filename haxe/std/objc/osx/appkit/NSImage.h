/*
	NSImage.h
	Application Kit
	Copyright (c) 1994-2011, Apple Inc.
	All rights reserved.
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSGeometry.h>
#import <Foundation/NSBundle.h>
#import <AppKit/NSGraphics.h>
#import <AppKit/NSBitmapImageRep.h>
#import <AppKit/NSPasteboard.h>
#import <ApplicationServices/ApplicationServices.h>

@class NSArray, NSColor, NSImageRep, NSGraphicsContext, NSURL;
@protocol NSImageDelegate;


enum {
    NSImageLoadStatusCompleted,
    NSImageLoadStatusCancelled,
    NSImageLoadStatusInvalidData,
    NSImageLoadStatusUnexpectedEOF,
    NSImageLoadStatusReadError
};
typedef NSUInteger NSImageLoadStatus;

enum {
    NSImageCacheDefault,    // unspecified. use image rep's default
    NSImageCacheAlways,     // always generate a cache when drawing
    NSImageCacheBySize,     // cache if cache size is smaller than original data
    NSImageCacheNever       // never cache, always draw direct
};
typedef NSUInteger NSImageCacheMode;


@class _NSImageAuxiliary;

extern class NSImage extends NSObject <NSCopying, NSCoding, NSPasteboardReading, NSPasteboardWriting>
{
    /*All instance variables are private*/
    NSString *_name;
    NSSize _size;
    struct __imageFlags {
	unsigned int scalable:1;
	unsigned int dataRetained:1;
	unsigned int uniqueWindow:1;
	unsigned int sizeWasExplicitlySet:1;
	unsigned int builtIn:1;
	unsigned int needsToExpand:1;
	unsigned int useEPSOnResolutionMismatch:1;
	unsigned int colorMatchPreferred:1;
	unsigned int multipleResolutionMatching:1;
	unsigned int focusedWhilePrinting:1;
	unsigned int archiveByName:1;
	unsigned int unboundedCacheDepth:1;
        unsigned int flipped:1;
        unsigned int aliased:1;
	unsigned int dirtied:1;
        unsigned int cacheMode:2;
        unsigned int sampleMode:3;
        unsigned int reserved2:1;
        unsigned int isTemplate:1;
        unsigned int failedToExpand:1;
        unsigned int reserved1:9;
    } _flags;
    volatile id _reps;
    _NSImageAuxiliary *_imageAuxiliary;
}

+ (id)imageNamed:(NSString *)name;	/* If this finds & creates the image, only name is saved when archived */

- (id)initWithSize:(NSSize)aSize;
- (id)initWithData:(NSData *)data;			/* When archived, saves contents */
- (id)initWithContentsOfFile:(NSString *)fileName;	/* When archived, saves contents */
- (id)initWithContentsOfURL:(NSURL *)url;               /* When archived, saves contents */
- (id)initByReferencingFile:(NSString *)fileName;	/* When archived, saves fileName */
- (id)initByReferencingURL:(NSURL *)url;		/* When archived, saves url, supports progressive loading */
- (id)initWithIconRef:(IconRef)iconRef NS_AVAILABLE_MAC(10_5);
- (id)initWithPasteboard:(NSPasteboard *)pasteboard;

// not for general use, but useful for compatibility with old NSImage behavior.  Ignore exif orientation tags in JPEG and such.  See AppKit release notes.
- (id)initWithDataIgnoringOrientation:(NSData *)data NS_AVAILABLE_MAC(10_6);

- (void)setSize:(NSSize)aSize;
- (NSSize)size;
- (BOOL)setName:(NSString *)string;
- (NSString *)name;
- (void)setBackgroundColor:(NSColor *)aColor;
- (NSColor *)backgroundColor;
- (void)setUsesEPSOnResolutionMismatch:(BOOL)flag;
- (BOOL)usesEPSOnResolutionMismatch;
- (void)setPrefersColorMatch:(BOOL)flag;
- (BOOL)prefersColorMatch;
- (void)setMatchesOnMultipleResolution:(BOOL)flag;
- (BOOL)matchesOnMultipleResolution;
- (void)drawAtPoint:(NSPoint)point fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;
- (void)drawInRect:(NSRect)rect fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;
- (void)drawInRect:(NSRect)dstSpacePortionRect fromRect:(NSRect)srcSpacePortionRect operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha respectFlipped:(BOOL)respectContextIsFlipped hints:(NSDictionary *)hints NS_AVAILABLE_MAC(10_6);
- (BOOL)drawRepresentation:(NSImageRep *)imageRep inRect:(NSRect)rect;
- (void)recache;
- (NSData *)TIFFRepresentation;
- (NSData *)TIFFRepresentationUsingCompression:(NSTIFFCompression)comp factor:(float)aFloat;

- (NSArray *)representations;
- (void)addRepresentations:(NSArray *)imageReps;
- (void)addRepresentation:(NSImageRep *)imageRep;
- (void)removeRepresentation:(NSImageRep *)imageRep;

- (BOOL)isValid;
- (void)lockFocus;
- (void)lockFocusFlipped:(BOOL)flipped NS_AVAILABLE_MAC(10_6);
- (void)unlockFocus;

// use -[NSImage bestRepresentationForRect:context:hints:] instead.  Any deviceDescription dictionary is also a valid hints dictionary.
- (NSImageRep *)bestRepresentationForDevice:(NSDictionary *)deviceDescription NS_DEPRECATED_MAC(10_0, 10_6);

- (void)setDelegate:(id <NSImageDelegate>)anObject;
- (id <NSImageDelegate>)delegate;

/* These return union of all the types registered with NSImageRep.
*/
+ (NSArray *)imageUnfilteredFileTypes;
+ (NSArray *)imageUnfilteredPasteboardTypes;
+ (NSArray *)imageFileTypes;
+ (NSArray *)imagePasteboardTypes;

+ (NSArray *)imageTypes NS_AVAILABLE_MAC(10_5);
+ (NSArray *)imageUnfilteredTypes NS_AVAILABLE_MAC(10_5);

+ (BOOL)canInitWithPasteboard:(NSPasteboard *)pasteboard;

- (void)cancelIncrementalLoad;

-(void)setCacheMode:(NSImageCacheMode)mode;
-(NSImageCacheMode)cacheMode;

/* The alignmentRect of an image is metadata that a client may use to help determine layout. The bottom of the rect gives the baseline of the image. The other edges give similar information in other directions.
 
 A 20x20 image of a phone icon with a glow might specify an alignmentRect of {{2,2},{16,16}} that excludes the glow. NSButtonCell can take advantage of the alignmentRect to place the image in the same visual location as an 16x16 phone icon without the glow. A 5x5 star that should render high when aligned with text might specify a rect of {{0,-7},{5,12}}.
 
 The alignmentRect of an image has no effect on methods such as drawInRect:fromRect:operation:Fraction: or drawAtPoint:fromRect:operation:fraction:. It is the client's responsibility to take the alignmentRect into account where applicable.
 
 The default alignmentRect of an image is {{0,0},imageSize}. The rect is adjusted when setSize: is called. 
 */
- (NSRect)alignmentRect NS_AVAILABLE_MAC(10_5);
- (void)setAlignmentRect:(NSRect)rect NS_AVAILABLE_MAC(10_5);

/* The 'template' property is metadata that allows clients to be smarter about image processing.  An image should be marked as a template if it is basic glpyh-like black and white art that is intended to be processed into derived images for use on screen.
 
 NSButtonCell applies effects to images based on the state of the button.  For example, images are shaded darker when the button is pressed.  If a template image is set on a cell, the cell can apply more sophisticated effects.  For example, it may be processed into an image that looks engraved when drawn into a cell whose interiorBackgroundStyle is NSBackgroundStyleRaised, like on a textured button.
 */
- (BOOL)isTemplate NS_AVAILABLE_MAC(10_5);
- (void)setTemplate:(BOOL)isTemplate NS_AVAILABLE_MAC(10_5);

/* An accessibility description can be set on an image.  This description will be used automatically by interface elements that display images.  Like all accessibility descriptions, the string should be a short localized string that does not include the name of the interface element.  For instance, "delete" rather than "delete button". 
*/
- (NSString *)accessibilityDescription	NS_AVAILABLE_MAC(10_6);
- (void)setAccessibilityDescription:(NSString *)description NS_AVAILABLE_MAC(10_6);

/* Make an NSImage referencing a CGImage.  The client should not assume anything about the image, other than that drawing it is equivalent to drawing the CGImage.
 
 If size is NSZeroSize, the pixel dimensions of cgImage are the returned image's size.   
 
 This is not a designated initializer.
 
 Size of an NSImage is distinct from pixel dimensions.  If an NSImage is placed in an NSButton, it will be drawn in a rect with the provided size in the ambient coordinate system.
 */
- (id)initWithCGImage:(CGImageRef)cgImage size:(NSSize)size NS_AVAILABLE_MAC(10_6);

/* Returns a CGImage capturing the drawing of the receiver.  This method returns an existing CGImage if one is available, or creates one if not.  It behaves the same as drawing the image with respect to caching and related behaviors.  This method is typically called, not overridden.  
 
 An NSImage is potentially resolution independent, and may have representations that allow it to draw well in many contexts.  A CGImage is more like a single pixel-based representation.   This method produces a snapshot of how the NSImage would draw if it was asked to draw in *proposedDestRect in the passed context.  Producing this snapshot may be more expensive than just drawing the NSImage, so prefer to use -[NSImage drawInRect:fromRect:operation:fraction:] unless you require a CGImage.
 
 The return value in *proposedDestRect tells the client where to draw the CGImage.  This rect may be outset from the requested rect, because a CGImage must have pixel-integral dimensions while an NSImage need not.
 
 All input parameters are optional.  They provide hints for how to choose among existing CGImages, or how to create one if there isn't already a CGImage available.  The parameters are _only_ hints.  Any CGImage is a valid return.
 
 If proposedDestRect is NULL, it defaults to the smallest pixel-integral rectangle containing {{0,0}, [self size]}.  The proposedDestRect is in user space in the reference context. 
 
 If referenceContext is nil, the method behaves as if a window context scaled by the default user space scaling factor was passed, though no context is actually created.  The properties of the context are used as hints for choosing the best representation and for creating a CGImage if creation is necessary.  It also provides the coordinate space in which the proposedDestRect is interpreted.  Only the snapshotted state of the context at the moment its passed to this method is relevant. Future changes to the context have no bearing on image behavior.
 
 The hints provide more context for selecting or generating a CGImage, and may override properties of the referenceContext.  Hints may be nil.  Any entries in a device description dictionary (see NSScreen) are valid, as are all CIContext creation options, plus a few extra hints defined below.  Unrecognized hints are ignored, but passed down to image reps (see -[NSImageRep CGImageForProposedRect:context:hints:]).  Explicit hints are particularly useful when it is not draw time and you don't have a context to pass in.  For example, if you want to pass a rect in pixels for proposedDestRect, you should pass a dictionary with the identity transform for NSImageHintCTM.  
  
 This method will always return a valid CGImage provided the NSImage is able to draw.  If the receiver is unable to draw for whatever reason, the error behavior is the same as when drawing the image.
 
 The CGImageRef returned is guaranteed to live as long as the current autorelease pool.  The caller should not release the CGImage.  This is the standard Cocoa convention, but people may not realize that it applies to CFTypes.
 */
- (CGImageRef)CGImageForProposedRect:(NSRect *)proposedDestRect context:(NSGraphicsContext *)referenceContext hints:(NSDictionary *)hints NS_AVAILABLE_MAC(10_6);

/* Select best representation.  The parameters have the same meaning and behavior as in -CGImageForProposedRect:context:hints:.
 */
- (NSImageRep *)bestRepresentationForRect:(NSRect)rect context:(NSGraphicsContext *)referenceContext hints:(NSDictionary *)hints NS_AVAILABLE_MAC(10_6);

/* Answers the question, "If you were to draw the image in the passed destination rect in the passed context respecting the passed flippedness with the passed hints, would the test rect in the context intersect a non-transparent portion of the image?"
 */
- (BOOL)hitTestRect:(NSRect)testRectDestSpace withImageDestinationRect:(NSRect)imageRectDestSpace context:(NSGraphicsContext *)context hints:(NSDictionary *)hints flipped:(BOOL)flipped NS_AVAILABLE_MAC(10_6); 

}

APPKIT_EXTERN NSString *const NSImageHintCTM NS_AVAILABLE_MAC(10_6); // value is NSAffineTransform
APPKIT_EXTERN NSString *const NSImageHintInterpolation NS_AVAILABLE_MAC(10_6); // value is NSNumber with NSImageInterpolation enum value

@protocol NSImageDelegate <NSObject>
@optional

- (NSImage *)imageDidNotDraw:(id)sender inRect:(NSRect)aRect;

- (void)image:(NSImage*)image willLoadRepresentation:(NSImageRep*)rep;
- (void)image:(NSImage*)image didLoadRepresentationHeader:(NSImageRep*)rep;
- (void)image:(NSImage*)image didLoadPartOfRepresentation:(NSImageRep*)rep withValidRows:(NSInteger)rows; 
- (void)image:(NSImage*)image didLoadRepresentation:(NSImageRep*)rep withStatus:(NSImageLoadStatus)status;
}

extern class NSBundle(NSBundleImageExtension)
- (NSString *)pathForImageResource:(NSString *)name;	/* May return nil if no file found */
- (NSURL *)URLForImageResource:(NSString *)name NS_AVAILABLE_MAC(10_6); /* May return nil if no file found */
- (NSImage *)imageForResource:(NSString *)name NS_AVAILABLE_MAC(10_7); /* May return nil if no file found */
}

extern class NSImage (NSDeprecated)

// the concept of flippedness for NSImage is deprecated.  Please see the AppKit 10.6 release notes for a discussion of why, and for how to replace existing usage.
- (void)setFlipped:(BOOL)flag;
- (BOOL)isFlipped;

// these methods have surprising semantics.  Prefer to use the 'draw' methods (and note the new draw method taking respectContextIsFlipped as a parameter).  Please see the AppKit 10.6 release notes for exactly what's going on.
- (void)dissolveToPoint:(NSPoint)point fraction:(CGFloat)aFloat;
- (void)dissolveToPoint:(NSPoint)point fromRect:(NSRect)rect fraction:(CGFloat)aFloat;
- (void)compositeToPoint:(NSPoint)point operation:(NSCompositingOperation)op;
- (void)compositeToPoint:(NSPoint)point fromRect:(NSRect)rect operation:(NSCompositingOperation)op;
- (void)compositeToPoint:(NSPoint)point operation:(NSCompositingOperation)op fraction:(CGFloat)delta;
- (void)compositeToPoint:(NSPoint)point fromRect:(NSRect)rect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;

// this method doesn't do what people expect.  See AppKit 10.6 release notes.  Briefly, you can replace invocation of this method with code that locks focus on the image and then draws the rep in the image.
- (void)lockFocusOnRepresentation:(NSImageRep *)imageRepresentation;

// these methods have to do with NSImage's caching behavior.  You should be able to remove use of these methods without any replacement.  See 10.6 AppKit release notes for details.
- (void)setScalesWhenResized:(BOOL)flag;
- (BOOL)scalesWhenResized;
- (void)setDataRetained:(BOOL)flag;
- (BOOL)isDataRetained;
- (void)setCachedSeparately:(BOOL)flag;
- (BOOL)isCachedSeparately;
- (void)setCacheDepthMatchesImageDepth:(BOOL)flag;
- (BOOL)cacheDepthMatchesImageDepth;

}

#pragma mark -
#pragma mark Standard Images

/* Standard images.  
 
 Most images are named by a specific function or situation where they are intended to be used.  In some cases, the artwork may be more generic than the name.  For example, the image for NSImageNameInvalidDataFreestandingTemplate is an arrow in 10.5.  Please do not use an image outside of the function for which it is intended - the artwork can change between releases.  The invalid data image could change to a yellow exclamation-point-in-triangle  icon.  If there is no image available for the situation you're interested in, please file a bug and use your own custom art in the meantime.
 
 The size of an image is also not guaranteed to be the same (or maintain the same aspect ratio) between releases, so you should explcitly size the image appropriately for your use.

 Constants that end in the word "Template" name black and clear images that return YES for isTemplate.  These images can be processed into variants appropriate for different situations.  For example, these images can invert in a selected table view row.  See -[NSImage setTemplate:] for more comments.  These images are inappropriate for display without further processing, but NSCell and its subclasses will perform the processing.
 
 Some images also contain the word "Freestanding".  This indicates that an image is appropriate for use as a borderless button - it doesn't need any extra bezel artwork behind it.  For example, Safari uses NSImageNameStopProgressTemplate as the stop button in a button on its toolbar, while it uses NSImageNameStopProgressFreestandingTemplate in the downloads window where it appears inline with a progress indicator.
  
 The string value of each symbol is the same as the constant name without the "ImageName" part.  For example, NSImageNameBonjour is @"NSBonjour".  This is documented so that images can be used by name in Interface Builder.     
 
 */
APPKIT_EXTERN NSString *const NSImageNameQuickLookTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameBluetoothTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameIChatTheaterTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameSlideshowTemplate NS_AVAILABLE_MAC(10_5);

/*  This image is appropriate on an 'action' button.  An action button is a popup that has the same contents as the contextual menu for a related control.
 */
APPKIT_EXTERN NSString *const NSImageNameActionTemplate NS_AVAILABLE_MAC(10_5); 

/*  This image can be used as a badge for a 'smart' item.  In 10.5, this and the 'action' image are both gears.  Please avoid using a gear for other situations, and if you do, use custom art.
 */
APPKIT_EXTERN NSString *const NSImageNameSmartBadgeTemplate NS_AVAILABLE_MAC(10_5);

/* These images are intended for use in a segmented control for switching view interfaces for another part of the window.
 */
APPKIT_EXTERN NSString *const NSImageNameIconViewTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameListViewTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameColumnViewTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameFlowViewTemplate NS_AVAILABLE_MAC(10_5);

APPKIT_EXTERN NSString *const NSImageNamePathTemplate NS_AVAILABLE_MAC(10_5);

/* Place this image to the right of invalid data.  For example, use it if the user tries to commit a form when it's missing a required name field.
 */
APPKIT_EXTERN NSString *const NSImageNameInvalidDataFreestandingTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameLockLockedTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameLockUnlockedTemplate NS_AVAILABLE_MAC(10_5);

/* Use these images for "go forward" or "go back" functions, as seen in Safari's toolbar.  See also the right and left facing triangle images.
 */
APPKIT_EXTERN NSString *const NSImageNameGoRightTemplate NS_AVAILABLE_MAC(10_5); 
APPKIT_EXTERN NSString *const NSImageNameGoLeftTemplate NS_AVAILABLE_MAC(10_5); 

/* Prefer the "GoLeft" and "GoRight" images for situations where they apply.  These generic triangles aren't endorsed for any particular use, but you can use them if you don't have any better art.
 */
APPKIT_EXTERN NSString *const NSImageNameRightFacingTriangleTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameLeftFacingTriangleTemplate NS_AVAILABLE_MAC(10_5);

APPKIT_EXTERN NSString *const NSImageNameAddTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameRemoveTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameRevealFreestandingTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameFollowLinkFreestandingTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameEnterFullScreenTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameExitFullScreenTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameStopProgressTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameStopProgressFreestandingTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameRefreshTemplate NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameRefreshFreestandingTemplate NS_AVAILABLE_MAC(10_5);

APPKIT_EXTERN NSString *const NSImageNameBonjour NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameComputer NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameFolderBurnable NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameFolderSmart NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameFolder NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameNetwork NS_AVAILABLE_MAC(10_5);

/* NSImageNameDotMac will continue to work for the forseeable future, and will return the same image as NSImageNameMobileMe.
 */
APPKIT_EXTERN NSString *const NSImageNameDotMac NS_AVAILABLE_MAC(10_5); // informally deprecated
APPKIT_EXTERN NSString *const NSImageNameMobileMe NS_AVAILABLE_MAC(10_6);

/* This image is appropriate as a drag image for multiple items.
 */
APPKIT_EXTERN NSString *const NSImageNameMultipleDocuments NS_AVAILABLE_MAC(10_5);

/* These images are intended for use in toolbars in preference windows.
 */
APPKIT_EXTERN NSString *const NSImageNameUserAccounts NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNamePreferencesGeneral NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameAdvanced NS_AVAILABLE_MAC(10_5);

/* These images are intended for use in other toolbars.
 */
APPKIT_EXTERN NSString *const NSImageNameInfo NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameFontPanel NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameColorPanel NS_AVAILABLE_MAC(10_5);

/* These images are appropriate for use in sharing or permissions interfaces.
 */
APPKIT_EXTERN NSString *const NSImageNameUser NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameUserGroup NS_AVAILABLE_MAC(10_5);
APPKIT_EXTERN NSString *const NSImageNameEveryone NS_AVAILABLE_MAC(10_5);  
APPKIT_EXTERN NSString *const NSImageNameUserGuest NS_AVAILABLE_MAC(10_6);

/* These images are the default state images used by NSMenuItem.  Drawing these outside of menus is discouraged.
*/
APPKIT_EXTERN NSString *const NSImageNameMenuOnStateTemplate NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameMenuMixedStateTemplate NS_AVAILABLE_MAC(10_6);

/* The name @"NSApplicationIcon" has been available since Mac OS X 10.0.  The symbol NSImageNameApplicationIcon is new in 10.6.
 */
APPKIT_EXTERN NSString *const NSImageNameApplicationIcon NS_AVAILABLE_MAC(10_6);

APPKIT_EXTERN NSString *const NSImageNameTrashEmpty NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameTrashFull NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameHomeTemplate NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameBookmarksTemplate NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameCaution NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameStatusAvailable NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameStatusPartiallyAvailable NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameStatusUnavailable NS_AVAILABLE_MAC(10_6);
APPKIT_EXTERN NSString *const NSImageNameStatusNone NS_AVAILABLE_MAC(10_6);
