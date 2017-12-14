//
//  AppDelegate.swift
//  ShareKit Swift Demo App (Cocoapods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import UIKit
import ShareKit
import PinterestSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //Here you load ShareKit submodule with app specific configuration
        let configurator = ShareKitDemoConfigurator()
        SHKConfiguration.sharedInstance(with: configurator)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let scheme = url.scheme else { return false }

        let pinterestSchemePrefix = String(format: "pdk%@", ShareKitDemoConfigurator().pinterestAppId())
        if scheme.hasPrefix(pinterestSchemePrefix) {
            return PDKClient.sharedInstance().handleCallbackURL(url)
        }
        return false
    }
}
