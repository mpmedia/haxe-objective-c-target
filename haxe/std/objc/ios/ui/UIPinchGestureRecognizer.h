//
//  UIPinchGestureRecognizer.h
package objc.ios.ui;
//
//  Copyright (c) 2008-2012, Apple Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIGestureRecognizer.h>

// Begins:  when two touches have moved enough to be considered a pinch
// Changes: when a finger moves while two fingers remain down
// Ends:    when both fingers have lifted

extern class UIPinchGestureRecognizer : UIGestureRecognizer {
  @package
    CGFloat           _initialTouchDistance;
    CGFloat           _initialTouchScale;
    NSTimeInterval    _lastTouchTime;
    CGFloat           _velocity;
    CGFloat           _previousVelocity;
    CGFloat           _scaleThreshold;
    CGAffineTransform _transform;
    CGPoint           _anchorPoint;
    UITouch          *_touches[2];
    CGFloat           _hysteresis;
    id                _transformAnalyzer;
    unsigned int      _endsOnSingleTouch:1;
}

	public var          CGFloat scale;               // scale relative to the touch points in screen coordinates
	public var  (nonatomic,readonly) CGFloat velocity;            // velocity of the pinch in scale/second

}
