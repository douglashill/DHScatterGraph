//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphBase.h"

@interface DHScatterGraphPointSet : NSObject

/// Shows point markers with no line
+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints;

+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints colour:(DH_COLOUR_CLASS *)colour lineWidth:(CGFloat)lineWidth showsPointMarkers:(BOOL)showsPointMarkers;

/// Designated initialiser
- (instancetype)initWithDataPoints:(NSArray *)dataPoints colour:(DH_COLOUR_CLASS *)colour lineWidth:(CGFloat)lineWidth showsPointMarkers:(BOOL)showsPointMarkers __attribute((objc_designated_initializer));

/// Ordered CGPoints in NSValues. Default: no data
@property (nonatomic, copy, readonly) NSArray *dataPoints;

/// Colour of plotted line
@property (nonatomic, strong, readonly) DH_COLOUR_CLASS *colour;

/// Width in points for plotted lines. Default: 2
@property (nonatomic, readonly) CGFloat lineWidth;

@property (nonatomic, readonly) BOOL showsPointMarkers;

@end
