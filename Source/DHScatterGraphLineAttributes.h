//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphBase.h"

/// Instances of DHScatterGraphLineAttributes are immutable value objects that describe the visual properties of lines.
@interface DHScatterGraphLineAttributes : NSObject

/**
 @brief Creates and returns an instance of DHScatterGraphLineAttributes with a given colour and line width.
 @param colour The colour used to draw lines.
 @param width  The width the lines are be drawn at, in points.
 @return A new instance of DHScatterGraphLineAttributes.
 */
+ (instancetype)lineAttributesWithColour:(DH_COLOUR_CLASS *)colour width:(CGFloat)width;

/**
 @brief Initialises an instance of DHScatterGraphLineAttributes with a given colour and line width.
 This is the designated initialiser
 @param colour The colour used to draw lines.
 @param width  The width the lines are be drawn at, in points.
 @return An initialised instance of DHScatterGraphLineAttributes.
 */
- (instancetype)initWithColour:(DH_COLOUR_CLASS *)colour width:(CGFloat)width __attribute((objc_designated_initializer));

/// The colour used to draw lines.
@property (nonatomic, strong, readonly) DH_COLOUR_CLASS *colour;

/// The width the lines are be drawn at, in points.
@property (nonatomic, readonly) CGFloat width;

/// Sets the fill and stroke colours and the line width in the current graphics context.
- (void)set;

@end
