//
//  ViewController.swift
//  ShareKit Swift Demo App (Cocoapods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import UIKit
import ShareKit

class ViewController: UITableViewController {
     let cellIdentifier = "Cell"

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbarButtons()
        observeShareKitNotifications() //For demonstration purpose. Your app can observe ShareKit's progress notifications.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: CGRect.zero)
        title = "Example"
    }

    private func setupToolbarButtons() {
        let accountsBarButton = UIBarButtonItem(title: "Accounts", style: .plain, target: self, action: #selector(showAccounts))
        let uploadsBarButton = UIBarButtonItem(title: "Uploads", style: .plain, target: self, action: #selector(showUploads))
        toolbarItems = [accountsBarButton, uploadsBarButton]
    }

    private func observeShareKitNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(authDidFinish(notification:)), name: NSNotification.Name.SHKAuthDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendDidCancel(notification:)), name: NSNotification.Name.SHKSendDidCancel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendDidStart(notification:)), name: NSNotification.Name.SHKSendDidStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendDidFinish(notification:)), name: NSNotification.Name.SHKSendDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendDidFail(notification:)), name: NSNotification.Name.SHKSendDidFailWithError, object: nil)
    }

    @objc private func showAccounts() {
        SHKAccountsViewController.open(from: self)
    }

    @objc private func showUploads() {
        SHKUploadsViewController.open(from: self)
    }

    //MARK: UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Sharing a Link"
        case 1:
            cell.textLabel?.text = "Sharing an Image"
        case 2:
            cell.textLabel?.text = "Sharing Text"
        case 3:
            cell.textLabel?.text = "Sharing a File"
        default:
            break
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var shareController: UIViewController
        switch indexPath.row {
        case 0:
            shareController = ExampleShareLinkViewController(nibName: nil, bundle: nil)
        case 1:
            shareController = ExampleShareImageViewController(nibName: nil, bundle: nil)
        case 2:
            shareController = ExampleShareTextViewController(nibName: nil, bundle: nil)
        case 3:
            shareController = ExampleShareFileViewController(nibName: nil, bundle: nil)
        default:
            return
        }
        navigationController?.pushViewController(shareController, animated: true)
    }

    //MARK: ShareKit notification handling
    @objc private func authDidFinish(notification: Notification) {
        if let success = notification.userInfo?["success"] as? Bool {
            let logString = success ? "authorization did finish successfully" : "authorization failed"
            NSLog(logString)
        }
    }

    @objc private func sendDidCancel(notification: Notification) {
        NSLog("sendDidCancel")
    }

    @objc private func sendDidStart(notification: Notification) {
        NSLog("sendDidStart")
    }

    @objc private func sendDidFinish(notification: Notification) {
        NSLog("sendDidFinish")
    }

    @objc private func sendDidFail(notification: Notification) {
        NSLog("sendDidFail")
    }
}

