//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphBase.h"

@class DHScatterGraphLineAttributes;

@interface DHScatterGraphPointSet : NSObject

/// Dark grey, no line, shows point markers.
+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints;

+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints lineAttributes:(DHScatterGraphLineAttributes *)lineAttributes showsPointMarkers:(BOOL)showsPointMarkers;

/// Designated initialiser
- (instancetype)initWithDataPoints:(NSArray *)dataPoints lineAttributes:(DHScatterGraphLineAttributes *)lineAttributes showsPointMarkers:(BOOL)showsPointMarkers __attribute((objc_designated_initializer));

/// Ordered CGPoints in NSValues.
@property (nonatomic, copy, readonly) NSArray *dataPoints;

/// The attributes of the line to be plotted between the points. Use a width of 0 if there should be no line. The colour is also used for point markers.
@property (nonatomic, strong, readonly) DHScatterGraphLineAttributes *lineAttributes;

@property (nonatomic, readonly) BOOL showsPointMarkers;

@end
