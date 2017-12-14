//
//  ExampleShareText.swift
//  ShareKit Swift Demo App (CocoaPods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import UIKit
import ShareKit

class ExampleShareTextViewController: UIViewController {
    private var textView: UITextView!
    private var shareBarButtonItem: UIBarButtonItem!
    
    override func loadView() {
        super.loadView()
        setupTextView()
        setupToolbarItems()
    }

    private func setupTextView() {
        textView = UITextView(frame: view.bounds)
        textView.text = "This is a chunk of text.  If you highlight it, you'll be able to share the selection.  If you tap the share button below, it will share all of it."
        textView.isEditable = false
        view.addSubview(textView)
    }

    private func setupToolbarItems() {
        shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                        shareBarButtonItem,
                        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
    }

    @objc private func share() {
        SHK.setRootViewController(self)
        var text: String
        if textView.selectedRange.length > 0, let selectedRange = Range(textView.selectedRange, in: textView.text) {
            text = String(textView.text[selectedRange])
        } else {
            text = textView.text
        }
        let item = SHKItem.text(text) as! SHKItem
        item.tags = ["sharekit", "testing", "text example"]
        presentSHKAlertController(with: item, shareBarButtonItem: shareBarButtonItem)
    }
}
