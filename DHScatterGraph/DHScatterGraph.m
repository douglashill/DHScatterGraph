//
//  DHScatterGraph.m
//
//  Douglas Hill, 5 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import "DHScatterGraph.h"

@implementation DHScatterGraph
{
	CGFloat minX;
	CGFloat maxX;
	CGFloat minY;
	CGFloat maxY;
	
	CGFloat xScale;
	CGFloat yScale;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setDefaultProperties];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
		[self setDefaultProperties];
	}
	return self;
}

- (void)setDefaultProperties
{
	DH_CONTENT_MODE_CONFIGURATION;
	
	[self setPadding:CGSizeMake(5.0, 5.0)];
	
	[self setPositiveQuadrantColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.94, 1.0)]];
	[self setNegativeQuadrantColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.91, 1.0)]];
	
	[self setLineWidth:2.0];
	[self setLineColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.4, 1.0)]];
	
	[self setValueLabelOffset:CGSizeMake(2.0, 2.0)];
	[self setValueLabelStepSize:CGSizeMake(10.0, 10.0)];
	[self setValueLabelFont:[DH_FONT_CLASS systemFontOfSize:14]];
	[self setValueLabelColour:[DH_COLOUR_CLASS blackColor]];
	[self setShowValueLabelsAtOrigin:NO];
	[self setXFormattingBlock:^NSString *(CGFloat number) {
		return [NSString stringWithFormat:@"%.0f", number];
	}];
	[self setYFormattingBlock:^NSString *(CGFloat number) {
		return [NSString stringWithFormat:@"%.0f", number];
	}];
	
	[self setAxesWidth:1.0];
	[self setAxesColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.4, 1.0)]];
	
	[self setGridWidth:1.0];
	[self setGridColour:[DH_COLOUR_CLASS DH_GREYSCALE_COLOUR_METHOD(0.8, 1.0)]];
	[self setGridStepSize:CGSizeMake(5.0, 5.0)];
}


#pragma mark - Custom accessors

- (void)setDataPoints:(NSArray *)dataPoints
{
	_dataPoints = dataPoints;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setPadding:(CGSize)padding
{
	_padding = padding;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setXMinimum:(CGFloat)xMinimum
{
	_xMinimum = xMinimum;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setXMaximum:(CGFloat)xMaximum
{
	_xMaximum = xMaximum;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setYMinimum:(CGFloat)yMinimum
{
	_yMinimum = yMinimum;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setYMaximum:(CGFloat)yMaximum
{
	_yMaximum = yMaximum;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setPositiveQuadrantColour:(DH_COLOUR_CLASS *)positiveQuadrantColour
{
	_positiveQuadrantColour = positiveQuadrantColour;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setNegativeQuadrantColour:(DH_COLOUR_CLASS *)negativeQuadrantColour
{
	_negativeQuadrantColour = negativeQuadrantColour;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
	_lineWidth = lineWidth;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setLineColour:(DH_COLOUR_CLASS *)lineColour
{
	_lineColour = lineColour;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setValueLabelOffset:(CGSize)valueLabelOffset
{
	_valueLabelOffset = valueLabelOffset;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setValueLabelStepSize:(CGSize)valueLabelStepSize
{
	_valueLabelStepSize = valueLabelStepSize;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setValueLabelFont:(DH_FONT_CLASS *)valueLabelFont
{
	_valueLabelFont = valueLabelFont;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setValueLabelColour:(DH_COLOUR_CLASS *)valueLabelColour
{
	_valueLabelColour = valueLabelColour;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setShowValueLabelsAtOrigin:(BOOL)showValueLabelsAtOrigin
{
	_showValueLabelsAtOrigin = showValueLabelsAtOrigin;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

//- (void)setXFormattingBlock:(labelFormattingBlock)xFormattingBlock
//{
//	_xFormattingBlock = [xFormattingBlock copy];
//	[self DH_SET_NEEDS_DISPLAY_METHOD];
//}
//
//- (void)setYFormattingBlock:(labelFormattingBlock)yFormattingBlock
//{
//	_yFormattingBlock = [yFormattingBlock copy];
//	[self DH_SET_NEEDS_DISPLAY_METHOD];
//}

- (void)setAxesWidth:(CGFloat)axesWidth
{
	_axesWidth = axesWidth;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setAxesColour:(DH_COLOUR_CLASS *)axesColour
{
	_axesColour = axesColour;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setGridWidth:(CGFloat)gridWidth
{
	_gridWidth = gridWidth;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setGridColour:(DH_COLOUR_CLASS *)gridColour
{
	_gridColour = gridColour;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}

- (void)setGridStepSize:(CGSize)gridStepSize
{
	_gridStepSize = gridStepSize;
	[self DH_SET_NEEDS_DISPLAY_METHOD];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
	[self calculateExtrema];
	
	CGContextRef context = DH_CGCONTEXT_CREATE;
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
	
	
	// Axes and grid lines
	[self drawGridLinesInContent:context withTransform:transform];
	[self drawAxesInContent:context withTransform:transform];	
	
	
	// Plot
	
	CGPoint firstPoint = [[self dataPoints][0] DH_POINT_VALUE_METHOD];
	firstPoint = CGPointApplyAffineTransform(firstPoint, transform);
	CGContextMoveToPoint(context,
						 firstPoint.x,
						 firstPoint.y);
	
	for (NSValue *value in [self dataPoints]) {
		CGPoint point = [value DH_POINT_VALUE_METHOD];
		point = CGPointApplyAffineTransform(point, transform);
		CGContextAddLineToPoint(context,
								point.x ,
								point.y );
	}
	
	CGContextSetLineWidth(context, [self lineWidth]);
	[[self lineColour] setStroke];
	CGContextStrokePath(context);
	
	
	// Add values along axes
	
	[[self valueLabelColour] setFill];
	
	CGFloat edgeFudge = 0.2;
	CGFloat step = [self valueLabelStepSize].width;
	
	for (CGFloat num = step * ceilf(minX / step + edgeFudge); num < maxX; num += step) {
		if (num == 0.0 && ![self shouldShowValueLabelsAtOrigin])
			continue;
		
		NSString *text = [self xFormattingBlock](num);
		CGRect textRect;
		textRect.size = [text DH_STRING_SIZE_METHOD([self valueLabelFont])];
		CGPoint textCentre = CGPointApplyAffineTransform(CGPointMake(num, - [self valueLabelOffset].width), transform);
		textRect.origin.x = textCentre.x - textRect.size.width / 2;
		textRect.origin.y = textCentre.y - textRect.size.height / 2;
		[text DH_STRING_DRAW_METHOD(textRect, [self valueLabelFont])];
	}
	
	step = [self valueLabelStepSize].height;
	
	for (CGFloat num = step * ceilf(minY / step + edgeFudge); num < maxY; num += step) {
		if (num == 0 && ![self shouldShowValueLabelsAtOrigin])
			continue;
		
		NSString *text = [self yFormattingBlock](num);
		CGRect textRect;
		textRect.size = [text DH_STRING_SIZE_METHOD([self valueLabelFont])];
		CGPoint textCentre = CGPointApplyAffineTransform(CGPointMake(- [self valueLabelOffset].height, num), transform);
		textRect.origin.x = textCentre.x - textRect.size.width / 2;
		textRect.origin.y = textCentre.y - textRect.size.height / 2;
		[text DH_STRING_DRAW_METHOD(textRect, [self valueLabelFont])];
	}
}


#pragma mark - Helpers

- (void)calculateExtrema
{
	minX = [self xMinimum];
	maxX = [self xMaximum];
	minY = [self yMinimum];
	maxY = [self yMaximum];
	
	for (NSValue *value in [self dataPoints]) {
		CGPoint point = [value DH_POINT_VALUE_METHOD];
		minX = MIN(minX, point.x);
		maxX = MAX(maxX, point.x);
		minY = MIN(minY, point.y);
		maxY = MAX(maxY, point.y);
	}
	
	minX -= [self padding].width;
	maxX += [self padding].width;
	minY -= [self padding].height;
	maxY += [self padding].height;
}

- (void)drawGridLinesInContent:(CGContextRef)context
				 withTransform:(CGAffineTransform)transform
{
	CGFloat lineWidth = [self gridWidth];
	CGFloat edgeFudge = 0.1;
	CGFloat step = [self gridStepSize].width;
	
	// Vertical grid lines
	for (CGFloat x = step * ceilf(minX / step + edgeFudge); x < maxX; x += step) {
		[self addVerticalLineInContent:context
					   withXCoordinate:x
							 withWidth:lineWidth
						 withTransform:transform];
	}
	
	// Hoizontal grid lines
	step = [self gridStepSize].height;
	for (CGFloat y = step * ceilf(minY / step + edgeFudge); y < maxY; y += step) {
		[self addHorizontalLineInContent:context
						 withYCoordinate:y
							   withWidth:lineWidth
						   withTransform:transform];
	}
	
	[[self gridColour] setStroke];
	CGContextSetLineWidth(context, [self gridWidth]);
	CGContextStrokePath(context);
}

- (void)drawAxesInContent:(CGContextRef)context
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

@end

