# DHScatterGraph #

Objective-C view class for drawing scatter graphs on iOS and OS X.

<img src="http://douglashill.co/files/DHScatterGraph-iPhone-screen-shot.png" alt="screen shot of scatter graph example on iPhone">


## Requirements ##

Compiler with automatic property synthesis (Xcode 4.4 or later). DHScatterGraph uses automatic reference counting (ARC).


## Usage ##

Add the two DHScatterGraph class files and one platform-specific definitions header file (`DHScatterGraphPlatformDefines.h` for either iOS or OS X) to your project.

Put the graph on screen like any other view. The graph’s appearance is entirely controlled by properties. The data to plot is provided as an array of `NSValue`s wrapping `CGPoint`s containing the x, y coordinates to plot.

	DHScatterGraph *scatterGraph = [[DHScatterGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[[self view] addSubview:scatterGraph];
	
	[scatterGraph setDataPoints:@[
	 [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)],
	 [NSValue valueWithCGPoint:CGPointMake(1.5, 2.0)]]];

