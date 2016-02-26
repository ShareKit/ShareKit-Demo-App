ShareKit-Demo-App
=================
[![Build Status](https://travis-ci.org/ShareKit/ShareKit-Demo-App.svg?branch=master)](https://travis-ci.org/ShareKit/ShareKit-Demo-App)

The demo app for [ShareKit iOS library] (https://github.com/sharekit/sharekit). ShareKit allows you to share content easily (URLs, text, images, files) to various web services (Facebook, Twitter, Tumblr, YouTube and many, many more) without studying their APIs, handling authorization etc. For more info check [ShareKit's readme](https://github.com/ShareKit/ShareKit) or study the demo.

There are two targets in the demo app:

1. **"ShareKit Demo App"** target demonstrates ShareKit library added to the app using Xcode subproject and git submodules. This target is ready to run right after you clone. *Use this target if you quickly want to get a preview of what ShareKit is.* If you encounter missing files during build, make sure to run `git submodule update --recursive`, so that ShareKit submodule gets what it needs
2. **"ShareKit Demo App (CocoaPods)"** target demonstrates ShareKit library added to the app using CocoaPods. Tu run this target you have to open terminal.app, navigate to the cloned demo app directory and run `pod install` first. For more info about CocoaPods library dependecy manager check [their official web](http://cocoapods.org).
