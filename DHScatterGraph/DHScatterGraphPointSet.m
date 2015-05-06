//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphPointSet.h"

@implementation DHScatterGraphPointSet

+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints
{
	return [self pointSetWithDataPoints:dataPoints colour:nil lineWidth:0 showsPointMarkers:YES];
}

+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints colour:(DH_COLOUR_CLASS *)colour lineWidth:(CGFloat)lineWidth showsPointMarkers:(BOOL)showsPointMarkers
{
	return [[self alloc] initWithDataPoints:dataPoints colour:colour lineWidth:lineWidth showsPointMarkers:showsPointMarkers];
}

- (instancetype)init
{
	return [self initWithDataPoints:nil colour:nil lineWidth:0 showsPointMarkers:NO];
}

- (instancetype)initWithDataPoints:(NSArray *)dataPoints colour:(DH_COLOUR_CLASS *)colour lineWidth:(CGFloat)lineWidth showsPointMarkers:(BOOL)showsPointMarkers
{
	self = [super init];
	if (self == nil) return nil;
	
	_dataPoints = [dataPoints copy];
	_colour = colour;
	_lineWidth = lineWidth;
	_showsPointMarkers = showsPointMarkers;
	
	return self;
}

@end
