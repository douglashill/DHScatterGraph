//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphBase.h"

@class DHScatterGraphLineAttributes;

/// A DHScatterGraphPointSet object is used by DHScatterGraph to draw a set of related points. Instances hold both the data visual attributes describing how the data should be drawn.
@interface DHScatterGraphPointSet : NSObject

/**
 @brief Creates and returns an instance of DHScatterGraphPointSet with given data points, and a dark grey point markers with no line.
 @param dataPoints An array containing the data points to plot, as CGPoints wrapped in NSValues.
 @return A new instance of DHScatterGraphPointSet.
 */
+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints;

/**
 @brief Creates and returns an instance of DHScatterGraphPointSet with given data points and visual attributes.
 @param dataPoints        An array containing the data points to plot, as CGPoints wrapped in NSValues.
 @param lineAttributes    The attributes of the line to be plotted between the points.
 @param showsPointMarkers A Boolean value that specifies whether markers should be drawn on each data point.
 @return A new instance of DHScatterGraphPointSet.
 */
+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints lineAttributes:(DHScatterGraphLineAttributes *)lineAttributes showsPointMarkers:(BOOL)showsPointMarkers;

/**
 @brief Initialises an instance of DHScatterGraphPointSet with given data points and visual attributes.
 This is the designated initialiser.
 @param dataPoints        An array containing the data points to plot, as CGPoints wrapped in NSValues.
 @param lineAttributes    The attributes of the line to be plotted between the points.
 @param showsPointMarkers A Boolean value that specifies whether markers should be drawn on each data point.
 @return An initialised instance of DHScatterGraphPointSet.
 */
- (instancetype)initWithDataPoints:(NSArray *)dataPoints lineAttributes:(DHScatterGraphLineAttributes *)lineAttributes showsPointMarkers:(BOOL)showsPointMarkers __attribute((objc_designated_initializer));

/// An array containing the data points to plot, as CGPoints wrapped in NSValues. The order of values in the array is used when drawing a line between the points.
@property (nonatomic, copy, readonly) NSArray *dataPoints;

/// The attributes of the line to be plotted between the points. Use a width of 0 if there should be no line. The colour is also used for point markers.
@property (nonatomic, strong, readonly) DHScatterGraphLineAttributes *lineAttributes;

 /// A Boolean value that determines whether markers are drawn on each data point. If NO, the data points are only visible by the line between them.
@property (nonatomic, readonly) BOOL showsPointMarkers;

@end
