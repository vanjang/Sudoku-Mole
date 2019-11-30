//
//  Game Solved VC UIActivityVC Delegate.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit
import LinkPresentation

extension GameSolvedViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
         // An empty UIImage is sufficient to ensure share sheet shows right actions
        return UIImage()
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        // Returns record screenshot as an attached image
        return recordsImage
    }
    
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        DispatchQueue.main.async {
            metadata.title = "Share record and get free chance!".localized() // Preview Title
            metadata.originalURL = self.thumbnailImage // determines the Preview Subtitle
            metadata.url = self.thumbnailImage
            metadata.iconProvider = NSItemProvider.init(contentsOf: self.thumbnailImage)
        }
        return metadata
    }
}
