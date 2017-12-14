//
//  ShareKitDemoConfigurator.swift
//  ShareKit Swift Demo App (CocoaPods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import Foundation
import ShareKit

class ShareKitDemoConfigurator: DefaultSHKConfigurator {

    //MARK: App Description
    override func appName() -> String! {
        return "Share Kit Demo App"
    }

    override func appURL() -> String! {
        return "https://github.com/ShareKit/ShareKit/"
    }

    /*** DO NOT USE THESE CLIENT ID'S IN YOUR APP! You should get your own from particular service's URL!!!! Otherwise you may cause problems to maintainers of ShareKit ***/

    //MARK: API Keys
    override func onenoteClientId() -> String! {
        return "000000004C10E500"
    }

    override func pinterestAllowUnauthenticatedPins() -> NSNumber! {
        return NSNumber(booleanLiteral: false)
    }

    override func pinterestAppId() -> String! {
        return "4809677768964981310"
    }

    override func flickrConsumerKey() -> String! {
        return "72f05286417fae8da2d7e779f0eb1b2a"
    }

    override func flickrSecretKey() -> String! {
        return "b5e731f395031782"
    }

    override func flickrCallbackUrl() -> String! {
        return "app://flickr"
    }

    /*
    override func vkontakteAppId() -> String! {
        return "2706858"
    }

    override func facebookAppId() -> String! {
        return "232705466797125"
    }

    override func facebookLocalAppId() -> String! {
        return ""
    }

    override func forcePreIOS6FacebookPosting() -> NSNumber! {
        return NSNumber(booleanLiteral: true)
    }

    override func googlePlusClientId() -> String! {
        return "1009915768979.apps.googleusercontent.com"
    }

    override func pocketConsumerKey() -> String! {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return "14225-bdc4f6b29cd76ce0603638e8"
        } else {
            return "14225-3e2ae99c6fc078de5496577c"
        }
    }

    override func diigoKey() -> String! {
        return "f401ddc3546cdf3c"
    }

    override func forcePreIOS5TwitterAccess() -> NSNumber! {
        return NSNumber(booleanLiteral: false)
    }

    override func twitterConsumerKey() -> String! {
        return "48Ii81VO5NtDKIsQDZ3Ggw"
    }

    override func twitterSecret() -> String! {
        return "WYc2HSatOQGXlUCsYnuW3UjrlqQj0xvkvvOIsKek32g"
    }

    override func twitterCallbackUrl() -> String! {
        return "http://twitter.sharekit.com"
    }

    override func twitterUseXAuth() -> NSNumber! {
        return NSNumber(booleanLiteral: false)
    }

    override func twitterUsername() -> String! {
        return ""
    }

    override func evernoteHost() -> String! {
        return "sandbox.evernote.com"
    }

    override func evernoteConsumerKey() -> String! {
        return "hansmeyer0711-4037"
    }

    override func evernoteSecret() -> String! {
        return "e9d68467cd4c1aeb"
    }

    override func flickrConsumerKey() -> String! {
        return "72f05286417fae8da2d7e779f0eb1b2a"
    }

    override func flickrSecretKey() -> String! {
        return "b5e731f395031782"
    }

    override func flickrCallbackUrl() -> String! {
        return "app://flickr"
    }

    override func bitLyLogin() -> String! {
        return "vilem"
    }

    override func bitLyKey() -> String! {
        return "R_466f921d62a0789ac6262b7711be8454"
    }

    override func linkedInConsumerKey() -> String! {
        return "ppc8a0wlnipp"
    }

    override func linkedInSecret() -> String! {
        return "jSzl76tvzsPgKBXh"
    }

    override func linkedInCallbackUrl() -> String! {
        return "http://yourdomain.com/callback"
    }
 */
/*
    - (NSString*)readabilityConsumerKey {
    return @"ctruman";
    }

    - (NSString*)readabilitySecret {
    return @"RGXDE6wTygKtkwDBHpnjCAyvz2dtrhLD";
    }

    - (NSNumber*)readabilityUseXAuth {
    return [NSNumber numberWithInt:1];;
    }

    - (NSString*)foursquareV2ClientId {
    return @"NFJOGLJBI4C4RSZ3DQGR0W4ED5ZWAAE5QO3FW02Z3LLVZCT4";
    }

    - (NSString*)foursquareV2RedirectURI {
    return @"app://foursquare";
    }

    - (NSString*)tumblrConsumerKey {
    return @"vT0GPbmG5pwWOLTyrFo6uG0UJQEfX4RgrnXY7ZTzkAJyCrHNPF";
    }

    - (NSString *)plurkAppKey {
    return @"orexUORVkR2C";
    }

    - (NSString*)tumblrSecret {
    return @"XsYJPUNJDwCAw6B1PcmFjXuCLtgBp8chRrNuZhpLzn8gFBDg42";
    }

    - (NSString*)tumblrCallbackUrl {
    return @"tumblr.sharekit.com";
    }

    - (NSString*)hatenaConsumerKey {
    return @"rtu/vY4jfiA3DQ==";
    }

    - (NSString*)hatenaSecret {
    return @"gFtqGv4/toRYlX/PT160+9fcrAU=";
    }

    - (NSString *)plurkAppSecret {
    return @"YYQUAeAPY9YMcCP5ol0dB6epaaMFT10C";
    }

    - (NSString *)plurkCallbackURL {
    return @"https://github.com/ShareKit/ShareKit";
    }


    - (NSString *) dropboxAppKey {
    //return @"n18olaziz6f8752"; //This app key has whole dropbox permission. Do not forget to change also dropboxAppSecret, dropboxRootFolder and url scheme in ShareKit demo app-info.plist if you wish to use it.
    return @"gb82qlxy5dx728y"; //This app key has sandbox permission
    }
    - (NSString *) dropboxAppSecret {
    //return @"6cjsemxx6i2qdvc";
    return @"rrk959vgkotv9v1";
    }

    - (NSString *) dropboxRootFolder {
    return @"sandbox";
    //return @"dropbox";
    }
    - (NSNumber *)dropboxShouldOverwriteExistedFile {
    return [NSNumber numberWithBool:NO];
    }
    -(NSString *)youTubeConsumerKey
    {
    return @"210716542944.apps.googleusercontent.com";
    }

    -(NSString *)youTubeSecret
    {
    return @"aaHCtV3LhzFE6XSFcKobb7HU";
    }

    - (NSString*)bufferClientID
    {
    return @"518cdcb0872cad4744000038";
    }

    - (NSString*)bufferClientSecret
    {
    return @"1bf70db9032207624e2ad58fb24b1593";
    }

    - (NSString *)imgurClientID {
    return @"a0467900dd97d89";
    }

    - (NSString *)imgurClientSecret {
    return @"cd4b907f1de7c7a901f055d5d2cd27415e43f7f3";
    }

    - (NSString *)imgurCallbackURL {
    return @"https://imgur.com";
    }

    ///only show instagram in the application list (instead of Instagram plus any other public/jpeg-conforming apps)
    - (NSNumber *)instagramOnly {
    return [NSNumber numberWithBool:NO];
    }
*/

}
