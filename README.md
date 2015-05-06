# DHScatterGraph #

View class for simple, property-driven scatter graphs on iOS and OS X.

<img src="http://douglashill.co/files/DHScatterGraph-iPhone-screen-shot.png" alt="screen shot of scatter graph example on iPhone">


## Requirements ##

iOS 8 or OS X 10.10. It might work on older versions, but they are not tested. Older versions of iOS will need to copy the source files instead of using the framework.


## Usage ##

The `DHScatterGraph` Xcode project builds two frameworks with the same name: one each for iOS and OS X. Add to your target the framework that matches your platform, then import using `@import DHScatterGraph`. If it does not work, you probably added the framework for the wrong platform.

Put instances of `DHScatterGraphView` on screen like any other view. The graph’s appearance is controlled by properties. The data to plot is provided as an array of `NSValue` objects wrapping `CGPoint` structs containing the (x, y) coordinates to plot.

	DHScatterGraphView *scatterGraph = [[DHScatterGraphView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[someSuperview addSubview:scatterGraph];
	
	[scatterGraph setPointSets:@[[DHScatterGraphPointSet pointSetWithDataPoints:@[
		[NSValue valueWithCGPoint:CGPointMake(0.1, 2.0)],
		[NSValue valueWithCGPoint:CGPointMake(0.9, 0.3)],
		[NSValue valueWithCGPoint:CGPointMake(2.4, 3.1)],
	]]]];

