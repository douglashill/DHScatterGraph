//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphPointSet.h"

#import "DHScatterGraphLineAttributes.h"

@implementation DHScatterGraphPointSet

+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints
{
	return [self pointSetWithDataPoints:dataPoints lineAttributes:[DHScatterGraphLineAttributes lineAttributesWithColour:[DH_COLOUR_CLASS darkGrayColor] width:0] showsPointMarkers:YES];
}

+ (instancetype)pointSetWithDataPoints:(NSArray *)dataPoints lineAttributes:(DHScatterGraphLineAttributes *)lineAttributes showsPointMarkers:(BOOL)showsPointMarkers
{
	return [[self alloc] initWithDataPoints:dataPoints lineAttributes:lineAttributes showsPointMarkers:showsPointMarkers];
}

- (instancetype)init
{
	return [self initWithDataPoints:nil lineAttributes:nil showsPointMarkers:NO];
}

- (instancetype)initWithDataPoints:(NSArray *)dataPoints lineAttributes:(DHScatterGraphLineAttributes *)lineAttributes showsPointMarkers:(BOOL)showsPointMarkers
{
	self = [super init];
	if (self == nil) return nil;
	
	_dataPoints = [dataPoints copy];
	_lineAttributes = lineAttributes;
	_showsPointMarkers = showsPointMarkers;
	
	return self;
}

@end
