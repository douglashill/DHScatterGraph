//  Douglas Hill, September 2014
//  https://github.com/douglashill/DHScatterGraph

#import "ScatterViewController.h"

@import DHScatterGraph;

@implementation ScatterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self init];
}

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	return self;
}

- (void)loadView
{
	DHScatterGraphView *const scatterGraph = [[DHScatterGraphView alloc] init];
	
	// Generate random points to plot
	NSUInteger numberOfPoints = 21;
	NSMutableArray *dataPoints = [NSMutableArray arrayWithCapacity:numberOfPoints];
	for (NSUInteger index = 0; index < numberOfPoints; index++) {
		CGPoint point = CGPointMake(index, (int)arc4random_uniform(21) - 10);
		[dataPoints addObject:[NSValue valueWithCGPoint:point]];
	}
	
	[scatterGraph setPointSets:@[[DHScatterGraphPointSet pointSetWithDataPoints:dataPoints lineAttributes:[DHScatterGraphLineAttributes lineAttributesWithColour:[UIColor darkGrayColor] width:2] showsPointMarkers:YES]]];
	
	[self setView:scatterGraph];
}

@end
