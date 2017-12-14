//
//  ExampleShareLinkViewController.swift
//  ShareKit Swift Demo App (CocoaPods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import UIKit
import ShareKit

class ExampleShareLinkViewController: UIViewController {

    //Configuration
    private let enhancedUrlShare = true

    private var webView: UIWebView!
    private var shareBarButtonItem: UIBarButtonItem!

    override func loadView() {
        super.loadView()
        setupWebView()
        setupToolbarItems()
    }

    private func setupWebView() {
        webView = UIWebView(frame: view.bounds)
        webView.scalesPageToFit = true
        if let url = URL(string: "https://apple.com") {
            webView.loadRequest(URLRequest(url: url))
        }
        view.addSubview(webView)
    }

    private func setupToolbarItems() {
        shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                        shareBarButtonItem,
                        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
    }

    @objc private func share() {
        SHK.setRootViewController(self)
        var item: SHKItem
        if enhancedUrlShare {
            guard let url = URL(string: "https://www.youtube.com/watch?v=KaOC9danxNo"), let pictureUrl = URL(string: "https://s-media-cache-ak0.pinimg.com/736x/3c/cb/27/3ccb278294d511a14c9c113abff830f6.jpg") else { return }
            item = SHKItem.url(url, title: "Planet Earth is blue", contentType: SHKURLContentTypeVideo) as! SHKItem
            item.urlPictureURI = pictureUrl
            item.urlDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et posuere mi."
            item.tags = ["apple inc.", "computers", "mac"]

            // bellow are examples how to preload SHKItem with some custom sharer specific settings. You can prefill them ad hoc during each particular SHKItem creation, or set them globally in your configurator, so that every SHKItem is prefilled with the same values. More info in SHKItem.h or DefaultSHKConfigurator.m.
            item.mailToRecipients = ["frodo@middle-earth.me", "gandalf@middle-earth.me"]
            item.textMessageToRecipients = ["581347615", "581344543"]
        } else {
            guard let url = webView.request?.url else { return }
            let pageTitle = webView.stringByEvaluatingJavaScript(from: "document.title")
            item = SHKItem.url(url, title: pageTitle, contentType: SHKURLContentTypeWebpage) as! SHKItem
        }
        presentSHKAlertController(with: item, shareBarButtonItem: shareBarButtonItem)
    }
}
