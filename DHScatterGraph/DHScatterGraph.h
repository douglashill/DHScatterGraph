//
//  DHScatterGraph.h
//
//  Douglas Hill, 11 January 2012
//  https://github.com/douglashill/DHScatterGraph
//

#import "DHScatterGraphPlatformDefines.h"

typedef NSString *(^labelFormattingBlock)(CGFloat number);

@interface DHScatterGraph : DH_VIEW_CLASS

@property (nonatomic, retain) NSArray *dataPoints; // Ordered CGPoints in NSValues. Convenient alternative to multipleDataPoints if only one set of data is to be shown
@property (nonatomic, strong) NSArray *multipleDataPoints; // Array of NSArrays of ordered CGPoints in NSValues. For drawing multiple lines

@property (nonatomic, assign) CGSize paddingFraction; // Extra space beyond extrema of data as a fraction of the range of the data. Default 0.1.

@property (nonatomic) CGFloat xMinimum; // Minimum value for the X axis. If data goes smaller, that will be used instead.
@property (nonatomic) CGFloat xMaximum; // Maximum value for the X axis. If data goes greater, that will be used instead.
@property (nonatomic) CGFloat yMinimum; // Minimum value for the Y axis. If data goes smaller, that will be used instead.
@property (nonatomic) CGFloat yMaximum; // Maximum value for the Y axis. If data goes greater, that will be used instead.

@property (nonatomic, retain) DH_COLOUR_CLASS *positiveQuadrantColour; // Background in upper-right and lower-left
@property (nonatomic, retain) DH_COLOUR_CLASS *negativeQuadrantColour; // Background in upper-left and lower-right

@property (nonatomic) CGFloat lineWidth; // Width in points for plotted lines
@property (nonatomic, strong) NSArray *lineWidths; // Array of NSNumbers with floats. Widths of multiple plotted lines

@property (nonatomic, retain) DH_COLOUR_CLASS *lineColour; // Colour of first plotted line
@property (nonatomic, strong) NSArray *lineColours; // Array of DH_COLOUR_CLASS objects. Colours for multiple plotted lines

@property (nonatomic) CGSize valueLabelOffset; // Offset of centre of labels from axis, below or to the left positive (graph coordinate system)
@property (nonatomic) CGSize valueLabelStepSize; // Step between value labels along the axes. Set to any negative value for automatic.
@property (nonatomic, retain) DH_FONT_CLASS *valueLabelFont; // Typeface and size for value labels
@property (nonatomic, retain) DH_COLOUR_CLASS *valueLabelColour; // Colour of value labels
@property (nonatomic, getter = shouldShowValueLabelsAtOrigin) BOOL showValueLabelsAtOrigin; // Show or hide the labels for (0, 0), which are drawn on top of the axes
@property (nonatomic, copy) labelFormattingBlock xFormattingBlock; // Block that takes a CGFloat parameter and returns a string to be used as a label
@property (nonatomic, copy) labelFormattingBlock yFormattingBlock;

@property (nonatomic) CGFloat axesWidth; // Thickness of lines for axes
@property (nonatomic, retain) DH_COLOUR_CLASS *axesColour; // Colour of axes

@property (nonatomic) CGFloat gridWidth; // Thickness of lines for grid
@property (nonatomic, retain) DH_COLOUR_CLASS *gridColour; // Colour of grid
@property (nonatomic) CGSize gridStepSize; // Step between grid lines. Set to any negative value for automatic.

@end
