//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

@import Darwin.TargetConditionals;

#if TARGET_OS_IPHONE

@import UIKit;

#define DH_VIEW_CLASS UIView
#define DH_COLOUR_CLASS UIColor

#else

@import AppKit;

#define DH_VIEW_CLASS NSView
#define DH_COLOUR_CLASS NSColor

#endif

/**
 @brief Returns the current graphics context of the current thread.
 @return The current graphics context of the current thread.
 */
CGContextRef DHScatterGraphGetCurrentGraphicsContext(void);
