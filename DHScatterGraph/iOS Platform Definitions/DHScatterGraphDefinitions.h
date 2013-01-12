//
//  DHScatterGraphDefinitions.h (iOS)
//
//  Douglas Hill, 12 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import <UIKit/UIKit.h>

#define DH_VIEW_CLASS UIView
#define DH_COLOUR_CLASS UIColor
#define DH_FONT_CLASS UIFont

#define DH_CONTENT_MODE_CONFIGURATION [self setContentMode:UIViewContentModeRedraw]

#define DH_GREYSCALE_COLOUR_METHOD(WHITE, ALPHA) colorWithWhite:WHITE alpha:ALPHA

#define DH_CGCONTEXT_CREATE UIGraphicsGetCurrentContext()

#define DH_SET_NEEDS_DISPLAY_METHOD setNeedsDisplay

#define DH_STRING_SIZE_METHOD(FONT) sizeWithFont:FONT
#define DH_STRING_DRAW_METHOD(RECT, FONT) drawInRect:RECT withFont:FONT

#define DH_POINT_VALUE_METHOD CGPointValue

#define DH_Y_POSITIVE - 1.0
#define DH_TRANSFORM_FOR_LOWER_LEFT_ORIGIN(HEIGHT) CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, HEIGHT), 1.0, -1.0);