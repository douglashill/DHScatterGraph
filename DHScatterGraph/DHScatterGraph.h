//
//  DHScatterGraph.h
//
//  Douglas Hill, 5 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import "DHScatterGraphPlatformDefines.h"

typedef NSString *(^labelFormattingBlock)(CGFloat number);

@interface DHScatterGraph : DH_VIEW_CLASS

@property (nonatomic, retain) NSArray *dataPoints; // Ordered CGPoints in NSValues

@property (nonatomic) CGSize padding; // Extra space beyond extrema of data (graph coordinate system)

@property (nonatomic) CGFloat xMinimum; // Minimum value for the X axis. If data goes smaller, that will be used instead.
@property (nonatomic) CGFloat xMaximum; // Maximum value for the X axis. If data goes greater, that will be used instead.
@property (nonatomic) CGFloat yMinimum; // Minimum value for the Y axis. If data goes smaller, that will be used instead.
@property (nonatomic) CGFloat yMaximum; // Maximum value for the Y axis. If data goes greater, that will be used instead.

@property (nonatomic, retain) DH_COLOUR_CLASS *positiveQuadrantColour; // Background in upper-right and lower-left
@property (nonatomic, retain) DH_COLOUR_CLASS *negativeQuadrantColour; // Background in upper-left and lower-right

@property (nonatomic) CGFloat lineWidth; // Width in points of plotted line
@property (nonatomic, retain) DH_COLOUR_CLASS *lineColour; // Colour of plotted line

@property (nonatomic) CGSize valueLabelOffset; // Offset of centre of labels from axis, below or to the left positive (graph coordinate system)
@property (nonatomic) CGSize valueLabelStepSize; // Step between value labels by the axes
@property (nonatomic, retain) DH_FONT_CLASS *valueLabelFont; // Typeface and size for value labels
@property (nonatomic, retain) DH_COLOUR_CLASS *valueLabelColour; // Colour of value labels
@property (nonatomic, getter = shouldShowValueLabelsAtOrigin) BOOL showValueLabelsAtOrigin; // Show or hide the labels for (0, 0), which are drawn on top of the axes
@property (nonatomic, copy) labelFormattingBlock xFormattingBlock; // Block that takes a CGFloat parameter and returns a string to be used as a label
@property (nonatomic, copy) labelFormattingBlock yFormattingBlock;

@property (nonatomic) CGFloat axesWidth; // Thickness of lines for axes
@property (nonatomic, retain) DH_COLOUR_CLASS *axesColour; // Colour of axes

@property (nonatomic) CGFloat gridWidth; // Thickness of lines for grid
@property (nonatomic, retain) DH_COLOUR_CLASS *gridColour; // Colour of grid
@property (nonatomic) CGSize gridStepSize; // Step between grid lines

@end
