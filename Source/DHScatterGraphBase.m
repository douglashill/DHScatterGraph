//  Douglas Hill, May 2015
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphBase.h"

CGContextRef DHScatterGraphGetCurrentGraphicsContext(void)
{
#if TARGET_OS_IPHONE
	return UIGraphicsGetCurrentContext();
#else
	return [[NSGraphicsContext currentContext] graphicsPort];
#endif
}
