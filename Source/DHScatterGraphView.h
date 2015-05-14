//  Douglas Hill, September 2014
//  https://github.com/douglashill/DHScatterGraph

#import "DHScatterGraphBase.h"

@class DHScatterGraphLineAttributes;

typedef NSString *(^labelFormattingBlock)(CGFloat number);

@interface DHScatterGraphView : DH_VIEW_CLASS

@property (nonatomic, strong) NSArray *pointSets;

@property (nonatomic, assign) CGSize paddingFraction; // Extra space beyond extrema of data as a fraction of the range of the data. Default: 0.1

@property (nonatomic) CGFloat xMinimum; // Minimum value for the X axis. If data goes smaller, that will be used instead. Default: 0
@property (nonatomic) CGFloat xMaximum; // Maximum value for the X axis. If data goes greater, that will be used instead. Default: 0
@property (nonatomic) CGFloat yMinimum; // Minimum value for the Y axis. If data goes smaller, that will be used instead. Default: 0
@property (nonatomic) CGFloat yMaximum; // Maximum value for the Y axis. If data goes greater, that will be used instead. Default: 0

@property (nonatomic, retain) DH_COLOUR_CLASS *positiveQuadrantColour; // Background in upper-right and lower-left. Default: 94% white, fully opaque
@property (nonatomic, retain) DH_COLOUR_CLASS *negativeQuadrantColour; // Background in upper-left and lower-right. Default: 91% white, fully opaque

@property (nonatomic, strong) NSDictionary *valueLabelAttributes; // Drawing attributes for value labels. See NSAttributedString AppKit/UIKit additions.
@property (nonatomic, getter = shouldShowValueLabelsAtOrigin) BOOL showValueLabelsAtOrigin; // Show or hide the labels for (0, 0), which are drawn on top of the axes
@property (nonatomic, copy) labelFormattingBlock xFormattingBlock; // Block that takes a CGFloat parameter and returns a string to be used as a label
@property (nonatomic, copy) labelFormattingBlock yFormattingBlock;

/// The attributes used to draw the x and y axes. The default is a 0.4 grey and a width of 1 point.
@property (nonatomic, strong) DHScatterGraphLineAttributes *axesAttributes;

/// The attributes used to draw the grid lines. The default is a 0.8 grey and a width of 1 point.
@property (nonatomic, strong) DHScatterGraphLineAttributes *gridAttributes;

@end
