//
//  DHScatterGraphDefinitions.h (OS X)
//
//  Douglas Hill, 12 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import <AppKit/AppKit.h>

#define DH_VIEW_CLASS NSView
#define DH_COLOUR_CLASS NSColor
#define DH_FONT_CLASS NSFont

#define DH_CONTENT_MODE_CONFIGURATION

#define DH_GREYSCALE_COLOUR_METHOD(WHITE, ALPHA) colorWithDeviceWhite:WHITE alpha:ALPHA

#define DH_CGCONTEXT_CREATE [[NSGraphicsContext currentContext] graphicsPort]

#define DH_SET_NEEDS_DISPLAY_METHOD setNeedsDisplay:YES

#define DH_STRING_SIZE_METHOD(FONT) sizeWithAttributes:@{NSFontAttributeName : FONT}
#define DH_STRING_DRAW_METHOD(RECT, FONT) drawInRect:RECT withAttributes:@{NSFontAttributeName : FONT}

#define DH_POINT_VALUE_METHOD pointValue

#define DH_Y_POSITIVE 1.0
#define DH_TRANSFORM_FOR_LOWER_LEFT_ORIGIN(HEIGHT) CGAffineTransformIdentity