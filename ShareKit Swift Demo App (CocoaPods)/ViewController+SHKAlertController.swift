//
//  ViewController+SHKAlertController.swift
//  ShareKit Swift Demo App (CocoaPods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import Foundation
import ShareKit

extension UIViewController {
    func presentSHKAlertController(with item: SHKItem, shareBarButtonItem: UIBarButtonItem) {
        let alertController = SHKAlertController.actionSheet(for: item)
        alertController?.modalPresentationStyle = .popover
        let popPresenter = alertController?.popoverPresentationController
        popPresenter?.barButtonItem = shareBarButtonItem
        if let alertController = alertController {
            present(alertController, animated: true, completion: nil)
        }
    }

    func presentSHKAlertController(with item: SHKItem, sourceView: UIView, sourceRect: CGRect) {
        let alertController = SHKAlertController.actionSheet(for: item)
        alertController?.modalPresentationStyle = .popover
        let popPresenter = alertController?.popoverPresentationController
        popPresenter?.sourceView = sourceView
        popPresenter?.sourceRect = sourceRect
        if let alertController = alertController {
            present(alertController, animated: true, completion: nil)
        }
    }
}
