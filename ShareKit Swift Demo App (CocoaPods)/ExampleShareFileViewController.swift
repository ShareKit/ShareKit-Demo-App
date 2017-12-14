//
//  ExampleShareFileViewController.swift
//  ShareKit Swift Demo App (CocoaPods)
//
//  Created by Vilém Kurz on 14/12/2017.
//  Copyright © 2017 Vilém Kurz. All rights reserved.
//

import UIKit
import ShareKit

class ExampleShareFileViewController: UITableViewController {

    //Configuration
    let shareFileWithPath = true
    let shareLargeVideo = true

    let cellIdentifier = "fileTypeToShare"
    let tableViewModel = ["PDF", "Video", "Audio", "Image"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UITableViewHeaderFooterView(frame: .zero)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        result.textLabel?.text = tableViewModel[indexPath.row]
        return result
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: SHKItem

        switch indexPath.row {
        case 0:
            item = makePDFItem()
        case 1:
            item = makeVideoItem()
        case 2:
            item = makeAudioItem()
        case 3:
            item = makeImageItem()
        default:
            return
        }

        if let sourceView = tableView.cellForRow(at: indexPath) {
            presentSHKAlertController(with: item, sourceView: sourceView, sourceRect: sourceView.bounds)
        }
    }

    private func makePDFItem() -> SHKItem {
        let filePath = Bundle.main.path(forResource: "example", ofType: "pdf")!
        if shareFileWithPath {
            return SHKItem.filePath(filePath, title: "My Awesome PDF") as! SHKItem
        } else {
            return makeDataItem(from: filePath, filename: "Awesome.pdf", title: "My Awesome PDF")
        }
    }

    private func makeVideoItem() -> SHKItem {
        var filePath: String
        if shareLargeVideo {
            filePath = Bundle.main.path(forResource: "demo_large_video_share", ofType: "mp4")!
        } else {
            filePath = Bundle.main.path(forResource: "demo_video_share", ofType: "mov")!
        }

        if shareFileWithPath {
            return SHKItem.filePath(filePath, title: "Impressionism - blue ball") as! SHKItem
        } else {
            return makeDataItem(from: filePath, filename: "demo_video_share.mov", title: "Impressionism - blue ball")
        }
    }

    private func makeAudioItem() -> SHKItem {
        let filePath = Bundle.main.path(forResource: "demo_audio_share", ofType: "mp3")!
        if shareFileWithPath {
            return SHKItem.filePath(filePath, title: "Demo audio beat") as! SHKItem
        } else {
            return makeDataItem(from: filePath, filename: "demo_audio_share.mp3", title: "Demo audio beat")
        }
    }

    private func makeImageItem() -> SHKItem {
        let filePath = Bundle.main.path(forResource: "sanFran", ofType: "jpg")!
        if shareFileWithPath {
            return SHKItem.filePath(filePath, title: "San Francisco") as! SHKItem
        } else {
            return makeDataItem(from: filePath, filename: "sanFran.jpg", title: "San Francisco")
        }
    }

    private func makeDataItem(from filePath: String, filename: String, title: String) -> SHKItem {
        let fileURL = URL(fileURLWithPath: filePath)
        let fileData = try? Data(contentsOf: fileURL)
        return SHKItem.fileData(fileData, filename: filename, title: title) as! SHKItem
    }
}
