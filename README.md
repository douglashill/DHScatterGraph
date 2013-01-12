# DHScatterGraph #

View class for simple, property-driven scatter graphs on iOS and OS X.

<img src="http://douglashill.co/files/DHScatterGraph-iPhone-screen-shot.png" alt="screen shot of scatter graph example on iPhone">


## Requirements ##

Compiler with automatic property synthesis (Xcode 4.4 or later). `DHScatterGraph` uses automatic reference counting (ARC).


## Usage ##

Add the two `DHScatterGraph` class files and one platform-specific definitions header file (`DHScatterGraphDefinitions.h` for either iOS or OS X) to your project.

Put the graph on screen like any other view. The graph’s appearance is entirely controlled by properties. The data to plot is provided as an array of `NSValue` objects wrapping `CGPoint` structs containing the (x, y) coordinates to plot.

	DHScatterGraph *scatterGraph = [[DHScatterGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[someSuperview addSubview:scatterGraph];
	
	[scatterGraph setDataPoints:@[
	 [NSValue valueWithPoint:CGPointMake(0.0, 0.0)],
	 [NSValue valueWithPoint:CGPointMake(1.5, 2.0)]]];

