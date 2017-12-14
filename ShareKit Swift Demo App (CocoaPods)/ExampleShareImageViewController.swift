//
//  ExampleShareImageViewController.swift
//  ShareKit Swift Demo App (CocoaPods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import UIKit
import ShareKit

class ExampleShareImageViewController: UIViewController {

    //Configuration
    private let shareLargeImage = true

    private var imageView: UIImageView!
    private var shareBarButtonItem: UIBarButtonItem!

    override func loadView() {
        super.loadView()
        setupImageView()
        setupToolbarItems()
    }

    private func setupImageView() {
        if (shareLargeImage) {
            imageView = UIImageView(image: #imageLiteral(resourceName: "largeImage.JPG"))
        } else {
            imageView = UIImageView(image: #imageLiteral(resourceName: "sanFran.jpg"))
        }
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }

    private func setupToolbarItems() {
        shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        shareBarButtonItem,
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
    }

    @objc private func share() {
        SHK.setRootViewController(self)
        let item = SHKItem.image(imageView.image, title: "San Francisco") as? SHKItem

        //only for Pinterest sharer testing,
        item?.url = URL(string: "https://www.apple.com")

        /* optional configuration examples. There is more to configure, see SHKItem */
        item?.tags = ["bay bridge", "architecture", "california"]
        if let toolbarBounds = navigationController?.toolbar.bounds, let popoverSourceRect = navigationController?.toolbar.convert(toolbarBounds, to: view) {
            //give a source rect in the coords of the view set with setRootViewController:
            item?.popOverSourceRect = popoverSourceRect
        }
        if let item = item {
            presentSHKAlertController(with: item, shareBarButtonItem: shareBarButtonItem)
        }
    }
}
