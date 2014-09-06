//  Douglas Hill, September 2014
//  https://github.com/douglashill/DHScatterGraph

#import "ScatterAppDelegate.h"

#import "ScatterViewController.h"

@implementation ScatterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	
	[[self window] setBackgroundColor:[UIColor blackColor]];
	[[self window] setRootViewController:[[ScatterViewController alloc] init]];
	[[self window] makeKeyAndVisible];
	
	return YES;
}

@end
