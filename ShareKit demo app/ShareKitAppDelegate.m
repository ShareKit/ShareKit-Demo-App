//
//  ShareKitAppDelegate.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/4/10.
//  Copyright Idea Shower, LLC 2010. All rights reserved.
//

#import "ShareKitAppDelegate.h"
#import "RootViewController.h"

//#import "SHKDropbox.h"
//#import "SHKGooglePlus.h"
#import "SHKFacebook.h"
#import "EvernoteSDK.h"
//#import "SHKBuffer.h"
#import "PocketAPI.h"

#if !COCOAPODS
#import "PDKClient.h"
#endif

#import "SHKConfiguration.h"
#import "ShareKitDemoConfigurator.h"
#import "SHK.h"

@implementation ShareKitAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
    //Here you load ShareKit submodule with app specific configuration
    DefaultSHKConfigurator *configurator = [[ShareKitDemoConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	navigationController.topViewController.title = SHKLocalizedString(@"Examples");
	[navigationController setToolbarHidden:NO];
	
	[self performSelector:@selector(testOffline) withObject:nil afterDelay:0.5];
	
	return YES;
}

- (void)testOffline
{	
	[SHK flushOfflineQueue];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[SHKFacebook handleDidBecomeActive];
    [[EvernoteSession sharedSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	// Save data if appropriate
	[SHKFacebook handleWillTerminate];
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    NSRange pocketPrefixKeyRange = [(NSString *)SHKCONFIG(pocketConsumerKey) rangeOfString:@"-"];
    NSRange range = {0, pocketPrefixKeyRange.location - 1};
    NSString *pocketPrefixKeyPart = [(NSString *)SHKCONFIG(pocketConsumerKey) substringWithRange:range];
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url sourceApplication:sourceApplication];
    } else if ([[scheme lowercaseString] isEqualToString:[bundleID lowercaseString]]) {
        //return [SHKGooglePlus handleURL:url sourceApplication:sourceApplication annotation:annotation];
        return false;
    } else if ([scheme hasPrefix:[NSString stringWithFormat:@"db-%@", SHKCONFIG(dropboxAppKey)]]) {
        //return [SHKDropbox handleOpenURL:url];
        return false;
    } else if ([[NSString stringWithFormat:@"en-%@", [[EvernoteSession sharedSession] consumerKey]] isEqualToString:[url scheme]]) {
        return [[EvernoteSession sharedSession] canHandleOpenURL:url];
    } else if ([scheme hasPrefix:[NSString stringWithFormat:@"buffer%@", SHKCONFIG(bufferClientID)]]) {
        //return [SHKBuffer handleOpenURL:url];
    } else if ([scheme hasPrefix:[NSString stringWithFormat:@"pocketapp%@", pocketPrefixKeyPart]]) {
        return [[PocketAPI sharedAPI] handleOpenURL:url];
    }
    #if !COCOAPODS
    else if ([scheme hasPrefix:[NSString stringWithFormat:@"pdk%@", SHKCONFIG(pinterestAppId)]]) {
        return [[PDKClient sharedInstance] handleCallbackURL:url];
    }
#endif
    
    return YES;
}

@end
