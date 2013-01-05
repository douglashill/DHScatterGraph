//
//  ScatterDocument.m
//  DHScatterGraph OS X example
//
//  Douglas Hill, 5 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import "ScatterDocument.h"

@implementation ScatterDocument

- (NSString *)windowNibName
{
	return @"ScatterDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
	[super windowControllerDidLoadNib:windowController];
	
	// Generate random points to plot
	NSUInteger numberOfPoints = 21;
	NSMutableArray *dataPoints = [NSMutableArray arrayWithCapacity:numberOfPoints];
	for (NSUInteger index = 0; index < numberOfPoints; index++) {
		CGPoint point = CGPointMake(index, (int)arc4random_uniform(21) - 10);
		[dataPoints addObject:[NSValue valueWithPoint:point]];
	}

	[[self scatterGraph] setDataPoints:dataPoints];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
