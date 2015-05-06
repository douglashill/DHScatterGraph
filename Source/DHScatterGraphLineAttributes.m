//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphLineAttributes.h"

@implementation DHScatterGraphLineAttributes

+ (instancetype)lineAttributesWithColour:(DH_COLOUR_CLASS *)colour width:(CGFloat)width
{
	return [[self alloc] initWithColour:colour width:width];
}

- (instancetype)init
{
	return [self initWithColour:nil width:0];
}

- (instancetype)initWithColour:(DH_COLOUR_CLASS *)colour width:(CGFloat)width
{
	self = [super init];
	if (self == nil) return nil;
	
	_colour = colour;
	_width = width;
	
	return self;
}

- (void)set
{
	[[self colour] set];
	CGContextSetLineWidth(DHScatterGraphGetCurrentGraphicsContext(), [self width]);
}

@end
