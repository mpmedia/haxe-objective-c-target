/*
	NSPrintOperation.h
	Application Kit
	Copyright (c) 1994-2011, Apple Inc.
	All rights reserved.
*/

#import <Foundation/NSGeometry.h>
#import <Foundation/NSRange.h>
#import <AppKit/AppKitDefines.h>

@class NSMutableData, NSGraphicsContext, NSPrintPanel, NSPrintInfo, NSView, NSWindow;

/* Values for -setPageOrder:/-pageOrder.
*/
enum {
    NSDescendingPageOrder		= -1,
    NSSpecialPageOrder			= 0, // Tells spooler to not rearrange
    NSAscendingPageOrder		= 1,
    NSUnknownPageOrder			= 2  // No page order written out
};
typedef NSInteger NSPrintingPageOrder;

#if MAC_OS_X_VERSION_10_7 <= MAC_OS_X_VERSION_MAX_ALLOWED
enum {
    /* Render at the best quality you can regardless of how slow that may be
    */
    NSPrintRenderingQualityBest,

    /* Sacrifice the least possible amount of rendering quality for speed to maintain a responsive user interface. 
       Note: Only do this after establishing that best quality rendering does indeed make the user interface unresponsive.
    */
    NSPrintRenderingQualityResponsive
};
#endif
typedef NSInteger NSPrintRenderingQuality;

/* An exception that may be thrown by the factory methods described below.
*/
APPKIT_EXTERN NSString *NSPrintOperationExistsException;

extern class NSPrintOperation extends NSObject {
}

/* Factory methods that create a new NSPrintOperation for printing, copying to Portable Document Format, or copying to Encapsulated PostScript. The passed-in NSPrintInfo is copied, and the copy is retained by the new NSPrintOperation. (So, no need to copy the NSPrintInfo you pass to these.) You can get the copy with -printInfo.
*/
+ (NSPrintOperation *)printOperationWithView:(NSView *)view printInfo:(NSPrintInfo *)printInfo;
+ (NSPrintOperation *)PDFOperationWithView:(NSView *)view insideRect:(NSRect)rect toData:(NSMutableData *)data printInfo:(NSPrintInfo *)printInfo;
+ (NSPrintOperation *)PDFOperationWithView:(NSView *)view insideRect:(NSRect)rect toPath:(NSString *)path printInfo:(NSPrintInfo *)printInfo;
+ (NSPrintOperation *)EPSOperationWithView:(NSView *)view insideRect:(NSRect)rect toData:(NSMutableData *)data printInfo:(NSPrintInfo *)printInfo;
+ (NSPrintOperation *)EPSOperationWithView:(NSView *)view insideRect:(NSRect)rect toPath:(NSString *)path printInfo:(NSPrintInfo *)printInfo;

/* Slight conveniences, for use when the application's global NSPrintInfo is appropriate. Each of these methods invokes [NSPrintInfo sharedPrintInfo] and then invokes the like-named method listed above.
*/
+ (NSPrintOperation *)printOperationWithView:(NSView *)view;
+ (NSPrintOperation *)PDFOperationWithView:(NSView *)view insideRect:(NSRect)rect toData:(NSMutableData *)data;
+ (NSPrintOperation *)EPSOperationWithView:(NSView *)view insideRect:(NSRect)rect toData:(NSMutableData *)data;

/* The current print operation for this thread. If this is nil, there is no current operation for the current thread.
*/
+ (NSPrintOperation *)currentOperation;
+ (void)setCurrentOperation:(NSPrintOperation *)operation;

/* Return YES if the operation for copying to PDF or EPS, NO if it's for printing.
*/
- (BOOL)isCopyingOperation;

/* If the print sheet is unresponsive or sluggish due to the time is takes you to fully render a page, you can check this method in drawRect and other printing methods such as beginDocument and knowsPageRage: to determine if the print operation prefers speed over fidelity. Please see the comments for NSPrintRenderingQuality. Most applications render each page fast enough and do not need to call this method.
*/
- (NSPrintRenderingQuality)preferredRenderingQuality NS_AVAILABLE_MAC(10_7);

/* The title of the print job. If a job title is set it overrides anything that might be gotten by sending the printed view an [NSView(NSPrinting) printJobTitle] message.
*/
- (void)setJobTitle:(NSString *)jobTitle NS_AVAILABLE_MAC(10_5);
- (NSString *)jobTitle NS_AVAILABLE_MAC(10_5);



/* Whether the print and progress panels are shown during the operation.
*/
- (void)setShowsPrintPanel:(BOOL)flag;
- (BOOL)showsPrintPanel;
- (void)setShowsProgressPanel:(BOOL)flag;
- (BOOL)showsProgressPanel;


/* The print panel to be presented by the operation when it is run, if showsProgressPanel is YES and isCopyingOperation is NO. -printPanel will create a new NSPrintPanel if one hasn't been set yet.
*/
- (void)setPrintPanel:(NSPrintPanel *)panel;
- (NSPrintPanel *)printPanel;

/* Whether the print operation should spawn a separate thread in which to run itself.
*/
- (void)setCanSpawnSeparateThread:(BOOL)canSpawnSeparateThread;
- (BOOL)canSpawnSeparateThread;

/* The page order that will be used to generate the pages in this job. This is the physical page order of the pages. It depends on the stacking order of the printer, the capability of the app to reverse page order, etc.
*/
- (void)setPageOrder:(NSPrintingPageOrder)pageOrder;
- (NSPrintingPageOrder)pageOrder;

/* Do the print operation, with panels that are document-modal to a specific window. When the operation has been completed, send the message selected by didRunSelector to the delegate, with the contextInfo as the last argument. The method selected by didRunSelector must have the same signature as:

    - (void)printOperationDidRun:(NSPrintOperation *)printOperation success:(BOOL)success contextInfo:(void *)contextInfo;

This can only be invoked once. Create a new NSPrintOperation instance for each operation. When this method completes, the object is removed from being the current operation if it is the current operation.
*/
- (void)runOperationModalForWindow:(NSWindow *)docWindow delegate:(id)delegate didRunSelector:(SEL)didRunSelector contextInfo:(void *)contextInfo;

/* Do the print operation, with application-modal panels. Return YES if the operation completed successfully, NO if there was an error or the user cancelled the operation. This can only be invoked once. Create a new NSPrintOperation instance for each operation. When this method completes, the object is removed from being the current operation if it is the current operation.
*/
- (BOOL)runOperation;

/* The view being printed.
*/
- (NSView *)view;

/* The print info of the operation. -printInfo always returns a copy of the NSPrintInfo passed into the factory method used to create the print operation, unless -setPrintInfo: has been invoked, in which case it returns the exact same object passed into -setPrintInfo:. So, the factory methods listed above copy the passed-in NSPrintInfo, but -setPrintInfo: doesn't.
*/
- (NSPrintInfo *)printInfo;
- (void)setPrintInfo:(NSPrintInfo *)printInfo;

/* The context for the output of this operation.
*/
- (NSGraphicsContext *)context;

/* The first through last one-based page numbers of the operation as it's being previewed or printed. The first page number might not be 1, and the page count might be NSIntegerMax to indicate that the number of pages is not known, depending on what the printed view returned when sent an [NSView(NSPrinting) knowsPageRange:] message.
*/
- (NSRange)pageRange NS_AVAILABLE_MAC(10_5);


/* The current one-based page number of the operation as it's being previewed or printed.
*/
- (NSInteger)currentPage;

/* Methods that are invoked by the print operation itself as it proceeds. You should not invoke them.
*/
- (NSGraphicsContext *)createContext;
- (void)destroyContext;
- (BOOL)deliverResult;
- (void)cleanUpOperation;

}

extern class NSPrintOperation(NSDeprecated)

/* Methods that were deprecated in Mac OS 10.5. You can merely get the NSPrintPanel of the operation and invoke these methods on the result instead of invoking them on the operation. In Mac OS 10.5 -setAccessoryView:/-accessoryView are deprecated in NSPageLayout and NSPrintPanel too. You should consider using those class' support for NSViewControllers instead.
*/
- (void)setAccessoryView:(NSView *)view NS_DEPRECATED_MAC(10_0, 10_5);
- (NSView *)accessoryView NS_DEPRECATED_MAC(10_0, 10_5);

- (void)setJobStyleHint:(NSString *)hint NS_DEPRECATED_MAC(10_2, 10_5);
- (NSString *)jobStyleHint NS_DEPRECATED_MAC(10_2, 10_5);

/* Methods that were deprecated in Mac OS 10.4. Use the new -setShowsPrintPanel:/-showsPrintPanel and -setShowsProgressPanel:/-showsProgressPanel methods instead.
*/
- (void)setShowPanels:(BOOL)flag NS_DEPRECATED_MAC(10_0, 10_4);
- (BOOL)showPanels NS_DEPRECATED_MAC(10_0, 10_4);

}
