//
//  ScatterDocument.h
//  DHScatterGraph OS X example
//
//  Douglas Hill, 5 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import <Cocoa/Cocoa.h>
#import "DHScatterGraph.h"

@interface ScatterDocument : NSPersistentDocument

@property (nonatomic, strong) IBOutlet DHScatterGraph *scatterGraph;

@end
