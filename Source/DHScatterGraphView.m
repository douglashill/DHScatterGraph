//  Douglas Hill, September 2014
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphView.h"

#import "DHScatterGraphPointSet.h"
#import <objc/runtime.h>

#if TARGET_OS_IPHONE

#define DH_GREYSCALE_COLOUR_METHOD(WHITE, ALPHA) colorWithWhite:WHITE alpha:ALPHA

#define DH_SET_NEEDS_DISPLAY_METHOD setNeedsDisplay

#define DH_POINT_VALUE_METHOD CGPointValue

#define DH_Y_POSITIVE - 1.0
#define DH_TRANSFORM_FOR_LOWER_LEFT_ORIGIN(HEIGHT) CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, HEIGHT), 1.0, -1.0);

#else

#define DH_GREYSCALE_COLOUR_METHOD(WHITE, ALPHA) colorWithDeviceWhite:WHITE alpha:ALPHA

#define DH_SET_NEEDS_DISPLAY_METHOD setNeedsDisplay:YES

#define DH_POINT_VALUE_METHOD pointValue

#define DH_Y_POSITIVE 1.0
#define DH_TRANSFORM_FOR_LOWER_LEFT_ORIGIN(HEIGHT) CGAffineTransformIdentity

#endif

static void *const displayPropertiesObservationContext = (void *)&displayPropertiesObservationContext;

@interface DHScatterGraphView ()

@property (nonatomic, strong, readonly) NSArray *observedProperties; // Array of NSStrings containing the property names.

@end

@implementation DHScatterGraphView
{
	CGFloat minX;
	CGFloat maxX;
	CGFloat minY;
	CGFloat maxY;
	
	CGFloat xScale;
	CGFloat yScale;
	
	NSArray *_observedProperties;
}

- (void)dealloc
{
	for (NSString *propertyName in [self observedProperties]) {
		[self removeObserver:self forKeyPath:propertyName context:displayPropertiesObservationContext];
	}
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		initialiseScatterGraph(self);
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
		initialiseScatterGraph(self);
	}
	return self;
}

static void initialiseScatterGraph(DHScatterGraphView *self)
{
#if TARGET_OS_IPHONE
	[self setContentMode:UIViewContentModeRedraw];
#endif
	
	[self setPaddingFraction:CGSizeMake(0.1, 0.1)];
	
	[self setPositiveQuadrantColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.94, 1.0)]];
	[self setNegativeQuadrantColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.91, 1.0)]];
	
	[self setValueLabelStepSize:CGSizeMake(-1, -1)];
	[self setShowValueLabelsAtOrigin:NO];
	
	[self setAxesWidth:1.0];
	[self setAxesColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.4, 1.0)]];
	
	[self setGridWidth:1.0];
	[self setGridColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.8, 1.0)]];
	[self setGridStepSize:CGSizeMake(-1, -1)];
	
	for (NSString *propertyName in [self observedProperties]) {
		[self addObserver:self
			   forKeyPath:propertyName
				  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew 
				  context:displayPropertiesObservationContext];
	}
}


#pragma mark - Key value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (context == displayPropertiesObservationContext
		&& ![change[NSKeyValueChangeOldKey] isEqual:change[NSKeyValueChangeNewKey]]) {
		[self DH_SET_NEEDS_DISPLAY_METHOD];
	}
}

#pragma mark - Custom accessors

- (NSArray *)observedProperties
{
	if (_observedProperties) return _observedProperties;
	
	id DHScatterGraphClass = objc_getClass("DHScatterGraph");
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(DHScatterGraphClass, &propertyCount);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:propertyCount];
	
	for (int idx = 0; idx < propertyCount; idx++) {
		const char *name = property_getName(properties[idx]);
		[array addObject:[NSString stringWithCString:name encoding:NSASCIIStringEncoding]];
	}
	
	free(properties);
	_observedProperties = array;
	return _observedProperties;
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
	if ([self hasDataPoints] == NO) {
		return;
	}
	
	[self calculateExtrema];
	
	CGContextRef const context = DHScatterGraphGetCurrentGraphicsContext();
	CGAffineTransform transform = DH_TRANSFORM_FOR_LOWER_LEFT_ORIGIN([self bounds].size.height);
	
	// Scale the coordinate system to fit the data
	xScale = [self bounds].size.width / (maxX - minX);
	yScale = [self bounds].size.height / (maxY - minY);
	transform = CGAffineTransformScale(transform, xScale, yScale);
	
	// Shift the origin
	transform = CGAffineTransformTranslate(transform, -minX, -minY);
	
	
	// Fill positive-positive and negative-negative quadrants
	CGContextAddRect(context, CGRectApplyAffineTransform(CGRectMake(0.0,
																	0.0,
																	maxX,
																	maxY), transform));
	CGContextAddRect(context, CGRectApplyAffineTransform(CGRectMake(0,
																	0,
																	minX,
																	minY), transform));
	[[self positiveQuadrantColour] setFill];
	CGContextFillPath(context);
	
	
	// Fill positive-negative and negative-positive quadrants
	CGContextAddRect(context, CGRectApplyAffineTransform(CGRectMake(0.0,
																	0.0,
																	maxX,
																	minY), transform));
	CGContextAddRect(context, CGRectApplyAffineTransform(CGRectMake(0,
																	0,
																	minX,
																	maxY), transform));
	[[self negativeQuadrantColour] setFill];
	CGContextFillPath(context);
	
	
	// Grid lines
	CGSize gridStep; // The actual step size used, resolved automatically if necessary
	{
		CGFloat lineWidth = [self gridWidth];
		CGFloat edgeFudge = 0.1;
		
		gridStep = [self gridStepSize];
		if (gridStep.width < 0) {
			gridStep.width = automaticStep(maxX - minX, [self bounds].size.width, 20);
		}
		if (gridStep.height < 0) {
			gridStep.height = automaticStep(maxY - minY, [self bounds].size.height, 20);
		}
		
		// Vertical grid lines
		for (CGFloat x = gridStep.width * ceilf(minX / gridStep.width + edgeFudge); x < maxX; x += gridStep.width) {
			[self addVerticalLineInContent:context
						   withXCoordinate:x
								 withWidth:lineWidth
							 withTransform:transform];
		}
		
		// Hoizontal grid lines
		for (CGFloat y = gridStep.height * ceilf(minY / gridStep.height + edgeFudge); y < maxY; y += gridStep.height) {
			[self addHorizontalLineInContent:context
							 withYCoordinate:y
								   withWidth:lineWidth
							   withTransform:transform];
		}
		
		[[self gridColour] setStroke];
		CGContextSetLineWidth(context, [self gridWidth]);
		CGContextStrokePath(context);
	}
	
	// Axes
	[self drawAxesInContext:context withTransform:transform];	
	
	
	// Plot
	
	for (DHScatterGraphPointSet *pointSet in [self pointSets]) {
		NSArray *const dataPoints = [pointSet dataPoints];
	 
		if ([dataPoints count] == 0) continue;
		
		CGPoint firstPoint = [dataPoints[0] DH_POINT_VALUE_METHOD];
		firstPoint = CGPointApplyAffineTransform(firstPoint, transform);
		CGContextMoveToPoint(context,
							 firstPoint.x,
							 firstPoint.y);
		
		for (NSValue *value in dataPoints) {
			CGPoint point = [value DH_POINT_VALUE_METHOD];
			point = CGPointApplyAffineTransform(point, transform);
			CGContextAddLineToPoint(context,
									point.x ,
									point.y );
		}
		
		CGContextSetLineJoin(context, kCGLineJoinBevel);
		CGContextSetLineWidth(context, [pointSet lineWidth]);
		
		[[pointSet colour] setStroke];
		
		CGContextStrokePath(context);
		
		if ([pointSet showsPointMarkers] == NO) continue;
		[[pointSet colour] setFill];
		for (NSValue *value in dataPoints) {
			CGPoint point = [value DH_POINT_VALUE_METHOD];
			point = CGPointApplyAffineTransform(point, transform);
			CGFloat radius = 3;
			CGContextFillEllipseInRect(context, CGRectMake(point.x - radius, point.y - radius, 2.0 * radius, 2.0 * radius));
		}
	};
	
	
	// Add values along axes
		
	CGFloat edgeFudge = 0.2;
	CGSize labelStep = [self valueLabelStepSize];
	if (labelStep.width <= 0) {
		labelStep.width = automaticStep(maxX - minX, [self bounds].size.width, 50);
		CGFloat maxLabelWidth = [self xAxisMaxLabelWidth] / xScale;
		// Multiple of 1, 2, 5, 10 etc. of grid step
		while (labelStep.width < maxLabelWidth) {
			labelStep.width *= 2.0;
			if (labelStep.width < maxLabelWidth) {
				labelStep.width *= 2.5;
				if (labelStep.width < maxLabelWidth) {
					labelStep.width *= 2.0;
				}
			}
		}
	}
	if (labelStep.height <= 0) {
		labelStep.height = automaticStep(maxY - minY, [self bounds].size.height, 50);
		CGFloat maxLabelHeight = [self yAxisMaxLabelHeight] / yScale;
		// Multiple of 1, 2, 5, 10 etc. of grid step
		while (labelStep.height < maxLabelHeight) {
			labelStep.height *= 2.0;
			if (labelStep.height < maxLabelHeight) {
				labelStep.height *= 2.5;
				if (labelStep.height < maxLabelHeight) {
					labelStep.height *= 2.0;
				}
			}
		}

	}
	
	CGSize const valueLabelOffset = [@"m" sizeWithAttributes:[self valueLabelAttributes]];
	
	for (CGFloat num = labelStep.width * ceilf(minX / labelStep.width + edgeFudge); num < maxX; num += labelStep.width) {
		if (num == 0.0 && ![self shouldShowValueLabelsAtOrigin])
			continue;
		
		NSString *text = [self xAxisText:num];
		CGRect textRect;
		textRect.size = [text sizeWithAttributes:[self valueLabelAttributes]];
		CGPoint textTopCentre = CGPointApplyAffineTransform(CGPointMake(num, 0), transform);
		textRect.origin.x = textTopCentre.x - textRect.size.width / 2.0;
		CGFloat offset = DH_Y_POSITIVE * 0.5 * valueLabelOffset.height + (DH_Y_POSITIVE == 1.0 ? textRect.size.height : 0);
		textRect.origin.y = textTopCentre.y - offset;
		
		// Ensure text is fully within bounds
		if (DH_Y_POSITIVE == 1.0) {
			textRect.origin.y = MAX(textRect.origin.y, 0.0);
		} else {
			textRect.origin.y = MIN(textRect.origin.y, [self bounds].size.height - textRect.size.height);
		}
		
		[text drawInRect:textRect withAttributes:[self valueLabelAttributes]];
	}
	
	for (CGFloat num = labelStep.height * ceilf(minY / labelStep.height + edgeFudge); num < maxY; num += labelStep.height) {
		if (num == 0 && ![self shouldShowValueLabelsAtOrigin])
			continue;
		
		NSString *text = [self yAxisText:num];
		CGRect textRect;
		textRect.size = [text sizeWithAttributes:[self valueLabelAttributes]];
		CGPoint textCentreRight = CGPointApplyAffineTransform(CGPointMake(0, num), transform);
		textRect.origin.x = textCentreRight.x - textRect.size.width - valueLabelOffset.width;
		textRect.origin.x = MAX(textRect.origin.x, 0.0); // Ensure text is fully within bounds
		textRect.origin.y = textCentreRight.y - textRect.size.height / 2.0;
		[text drawInRect:textRect withAttributes:[self valueLabelAttributes]];
	}
}


#pragma mark - Helpers

- (BOOL)hasDataPoints
{
	for (DHScatterGraphPointSet *pointSet in [self pointSets]) {
		if ([[pointSet dataPoints] count]) {
			return YES;
		}
	}
	return NO;
}

- (void)calculateExtrema
{
	minX = [self xMinimum];
	maxX = [self xMaximum];
	minY = [self yMinimum];
	maxY = [self yMaximum];
	
	for (DHScatterGraphPointSet *pointSet in [self pointSets]) {
		for (NSValue *value in [pointSet dataPoints]) {
			CGPoint point = [value DH_POINT_VALUE_METHOD];
			minX = MIN(minX, point.x);
			maxX = MAX(maxX, point.x);
			minY = MIN(minY, point.y);
			maxY = MAX(maxY, point.y);
		}
	}
	
	CGFloat horizontalPadding = [self paddingFraction].width * (maxX - minX);
	CGFloat verticalPadding = [self paddingFraction].height * (maxY - minY);
	
	minX -= horizontalPadding;
	maxX += horizontalPadding;
	minY -= verticalPadding;
	maxY += verticalPadding;
}

- (void)drawAxesInContext:(CGContextRef)context
			withTransform:(CGAffineTransform)transform
{
	CGFloat axesWidth = [self axesWidth];
	
	[self addVerticalLineInContent:context
				   withXCoordinate:0.0
						 withWidth:axesWidth
					 withTransform:transform];
	
	[self addHorizontalLineInContent:context
					 withYCoordinate:0.0
						   withWidth:axesWidth
					   withTransform:transform];
	
	[[self axesColour] setStroke];
	CGContextSetLineWidth(context, axesWidth);
	CGContextStrokePath(context);
}

- (void)addVerticalLineInContent:(CGContextRef)context
				 withXCoordinate:(CGFloat)x
					   withWidth:(CGFloat)lineWidth
				   withTransform:(CGAffineTransform)transform
{
	CGPoint point = CGPointMake(x, minY);
	point = CGPointApplyAffineTransform(point, transform);
	if (lineWidth == 1.0 || lineWidth == 3.0 || lineWidth == 5.0) {
		point.x = floorf(point.x) + 0.5; // rounds to nearest centre of nearest pixel
		point.y = floorf(point.y) + 0.5;
	}
	if (lineWidth == 2.0 || lineWidth == 4.0 || lineWidth == 6.0) {
		point.x = floorf(point.x + 0.5); // rounds to nearest pixel boundary
		point.y = floorf(point.y + 0.5);
	}
	CGContextMoveToPoint(context, point.x, point.y);
	
	point.x = x;
	point.y = maxY;
	point = CGPointApplyAffineTransform(point, transform);
	if (lineWidth == 1.0 || lineWidth == 3.0 || lineWidth == 5.0) {
		point.x = floorf(point.x) + 0.5; // rounds to nearest centre of nearest pixel
		point.y = floorf(point.y) + 0.5;
	}
	if (lineWidth == 2.0 || lineWidth == 4.0 || lineWidth == 6.0) {
		point.x = floorf(point.x + 0.5); // rounds to nearest pixel boundary
		point.y = floorf(point.y + 0.5);
	}
	CGContextAddLineToPoint(context, point.x, point.y);
}

- (void)addHorizontalLineInContent:(CGContextRef)context
				   withYCoordinate:(CGFloat)y
						 withWidth:(CGFloat)lineWidth
					 withTransform:(CGAffineTransform)transform
{
	CGPoint point = CGPointMake(minX, y);
	point = CGPointApplyAffineTransform(point, transform);
	if (lineWidth == 1.0 || lineWidth == 3.0 || lineWidth == 5.0) {
		point.x = floorf(point.x) + 0.5; // rounds to nearest centre of nearest pixel
		point.y = floorf(point.y) + 0.5;
	}
	if (lineWidth == 2.0 || lineWidth == 4.0 || lineWidth == 6.0) {
		point.x = floorf(point.x + 0.5); // rounds to nearest pixel boundary
		point.y = floorf(point.y + 0.5);
	}
	CGContextMoveToPoint(context, point.x, point.y);
	
	point.x = maxX;
	point.y = y;
	point = CGPointApplyAffineTransform(point, transform);
	if (lineWidth == 1.0 || lineWidth == 3.0 || lineWidth == 5.0) {
		point.x = floorf(point.x) + 0.5; // rounds to nearest centre of nearest pixel
		point.y = floorf(point.y) + 0.5;
	}
	if (lineWidth == 2.0 || lineWidth == 4.0 || lineWidth == 6.0) {
		point.x = floorf(point.x + 0.5); // rounds to nearest pixel boundary
		point.y = floorf(point.y + 0.5);
	}
	CGContextAddLineToPoint(context, point.x, point.y);
}

- (NSString *)xAxisText:(CGFloat)num
{
	return [self xFormattingBlock] ? [self xFormattingBlock](num) : [NSString stringWithFormat:@"%g", num];
}

- (NSString *)yAxisText:(CGFloat)num
{
	return [self yFormattingBlock] ? [self yFormattingBlock](num) : [NSString stringWithFormat:@"%g", num];
}

// Approximate maximum widths and heights using labels at extrema
- (CGFloat)xAxisMaxLabelWidth
{
	CGSize sizeOfMaxLabel = [[self xAxisText:maxX] sizeWithAttributes:[self valueLabelAttributes]];
	CGSize sizeOfMinLabel = [[self xAxisText:minX] sizeWithAttributes:[self valueLabelAttributes]];
	return MAX(sizeOfMaxLabel.width, sizeOfMinLabel.width);
}

- (CGFloat)xAxisMaxLabelHeight
{
	CGSize sizeOfMaxLabel = [[self xAxisText:maxX] sizeWithAttributes:[self valueLabelAttributes]];
	CGSize sizeOfMinLabel = [[self xAxisText:minX] sizeWithAttributes:[self valueLabelAttributes]];
	return MAX(sizeOfMaxLabel.height, sizeOfMinLabel.height);
}

- (CGFloat)yAxisMaxLabelWidth
{
	CGSize sizeOfMaxLabel = [[self yAxisText:maxY] sizeWithAttributes:[self valueLabelAttributes]];
	CGSize sizeOfMinLabel = [[self yAxisText:minY] sizeWithAttributes:[self valueLabelAttributes]];
	return MAX(sizeOfMaxLabel.width, sizeOfMinLabel.width);
}

- (CGFloat)yAxisMaxLabelHeight
{
	CGSize sizeOfMaxLabel = [[self yAxisText:maxY] sizeWithAttributes:[self valueLabelAttributes]];
	CGSize sizeOfMinLabel = [[self yAxisText:minY] sizeWithAttributes:[self valueLabelAttributes]];
	return MAX(sizeOfMaxLabel.height, sizeOfMinLabel.height);
}


#pragma mark - Functions

CGFloat automaticStep(CGFloat dataRange, CGFloat screenPoints, CGFloat guide)
{
	CGFloat numberOfDivisions = screenPoints / guide;
	CGFloat target = dataRange / numberOfDivisions;
	CGFloat magnitude = powf(10, floorf(log10f(target)));
	
	const int count = 4;
	int multipliers[count] = {1, 2, 5, 10};
	CGFloat smallestDifference = CGFLOAT_MAX;
	int indexOfClosestMultiplier = 0;
	
	for (int index = 0; index < count; index++) {
		CGFloat difference = ABS(multipliers[index] * magnitude - target);
		if (difference < smallestDifference) {
			smallestDifference = difference;
			indexOfClosestMultiplier = index;
		}
	}
	
	CGFloat step = multipliers[indexOfClosestMultiplier] * magnitude;
	
	return step;
}

@end

