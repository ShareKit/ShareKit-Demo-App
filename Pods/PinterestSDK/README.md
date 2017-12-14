# PinterestSDK for iOS

The PinterestSDK for iOS will allow you to authenticate an account with Pinterest and make requests on behalf of the authenticated user. For details on the supported endpoint, visit [the Pinterest API](https://developers.pinterest.com/docs/api/overview/).

## Installation

The PinterestSDK is a cocoapod. In order to use it you will need to create a `Podfile` if you do not already have one. Information on installing cocoapods and creating a Podfile can be found at [Cocoapods.org](http://cocoapods.org/). (Hint — to install cocoapods, run `sudo gem install cocoapods` from the command line; to create a Podfile, run `pod init`).

Open up the Podfile and add the following dependency:

```bash
pod "PinterestSDK", :git => "git@github.com:pinterest/ios-pdk.git"
```

Save your Podfile and run 'pod install' from the command line.

You can also just give the example app a try:

```bash
pod try https://github.com/pinterest/ios-pdk.git
```

## Setting up your App 

### Registering Your App
Visit the [Pinterest Developer Site](https://developers.pinterest.com/apps/) and register your application. This will generate an appId for you which you will need in the next steps. Make sure to add your redirect URIs. For iOS your redirect URI will be `pdk[your-appId]`. For example, if you appId is 1234 your redirect URI will be `pdk1234`.

### Configuring Xcode
The PinterestSDK will authenticate using OAuth either via the Pinterest app or, if the Pinterest app isn't installed, Safari. In order to redirect back to your app after authentication you will need set up a custom URL scheme. To do this, go to your app's plist and add a URL scheme named `pdk[your-appId]`. 

![Xcode Screenshot](https://raw.githubusercontent.com/pinterest/ios-pdk/master/Example/PinterestSDK/Images.xcassets/XcodeScreenshot.png)

### Configuring PDKClient
Before you make any calls using the PDKClient in your app, you will need to configure it with your appId: 

```objective-c
[PDKClient configureSharedInstanceWithAppId:@"12345"];
```

The end of `application:didFinishLaunchingWithOptions:` seems like a reasonable place.

### Authenticating

To authenticate a user, call authenticateWithPermissions:withSuccess:andFailure: on PDKClient. If the current auth token isn't valid or this is the first time you've requested a token, this call will cause an app switch to either the Pinterest app or Safari. To handle the switch back to your app, implement your app's application:openURL:sourceApplication:annotation: as follows:

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
return [[PDKClient sharedInstance] handleCallbackURL:url];
}
```

For iOS9 and latter application:openURL:sourceApplication:annotation: was deprecated, so you should implement application:openURL:options as follows:

```
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
return [[PDKClient sharedInstance] handleCallbackURL:url];
}
```

## Example App

A good place to start exploring the PDK is with the example app. To run it browse to the Example directory and run `pod install`.  Next open `PinterestSDK.xcworkspace` in XCode and run it.

## Documentation

For the full documentation and more information about the Pinterest Developer Platform, please visit:

[PinterestSDK for iOS](https://developers.pinterest.com/docs/sdks/ios/)

[Pinterest API Docs](https://developers.pinterest.com/docs/getting-started/)

[Pinterest API signup](https://developers.pinterest.com/apps/)

