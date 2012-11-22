//
//  UIActivityViewController.h
package objc.ios.ui;
//
//  Copyright 2012 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIKitDefines.h>

typedef void (^UIActivityViewControllerCompletionHandler)(NSString *activityType, BOOL completed);

NS_CLASS_AVAILABLE_IOS(6_0)extern class UIActivityViewController extends UIViewController

- (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities;

public var  UIActivityViewControllerCompletionHandler completionHandler;  // set to nil after call
public var  NSArray *excludedActivityTypes; // default is nil. activity types listed will not be displayed

}
