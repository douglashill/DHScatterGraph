//  Douglas Hill, September 2014
//  https://github.com/douglashill/DHScatterGraph

#import "Document.h"

#import "DHScatterGraphView.h"
#import "DHScatterGraphPointSet.h"

@interface Document ()

@property (strong) NSArray *dataPoints;
@property (weak) IBOutlet DHScatterGraphView *scatterGraph;

@end

@implementation Document

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (id)initWithType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
	self = [super initWithType:typeName error:outError];
	if (self == nil) return nil;
	
	// Generate random points to plot
	NSUInteger numberOfPoints = 21;
	NSMutableArray *dataPoints = [NSMutableArray arrayWithCapacity:numberOfPoints];
	for (NSUInteger index = 0; index < numberOfPoints; index++) {
		CGPoint point = CGPointMake(index, (int)arc4random_uniform(21) - 10);
		[dataPoints addObject:[NSValue valueWithPoint:point]];
	}
	
	_dataPoints = dataPoints;
	
	[self updateChangeCount:NSChangeDone];
	
	return self;
}

- (NSString *)windowNibName
{
	return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
	[super windowControllerDidLoadNib:windowController];
	
	[[self scatterGraph] setPointSets:@[[DHScatterGraphPointSet pointSetWithDataPoints:[self dataPoints] colour:[NSColor darkGrayColor] lineWidth:2 showsPointMarkers:YES]]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	return [NSKeyedArchiver archivedDataWithRootObject:[self dataPoints]];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	[self setDataPoints:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
	
	return YES;
}

@end
