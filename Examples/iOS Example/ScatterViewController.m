//
//  ScatterViewController.m
//  DHScatterGraph iOS example
//
//  Douglas Hill, 5 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import "ScatterViewController.h"
#import "DHScatterGraph.h"

@interface ScatterViewController ()

@property (nonatomic, weak) DHScatterGraph *scatterGraph;

@end

@implementation ScatterViewController

- (void)loadView
{
	DHScatterGraph *scatterGraph = [[DHScatterGraph alloc] init];
	
	// Generate random points to plot
	NSUInteger numberOfPoints = 21;
	NSMutableArray *dataPoints = [NSMutableArray arrayWithCapacity:numberOfPoints];
	for (NSUInteger index = 0; index < numberOfPoints; index++) {
		CGPoint point = CGPointMake(index, (int)arc4random_uniform(21) - 10);
		[dataPoints addObject:[NSValue valueWithCGPoint:point]];
	}
	
	[scatterGraph setDataPoints:dataPoints];
	
	[self setView:scatterGraph];
	[self setScatterGraph:scatterGraph];
}

@end
