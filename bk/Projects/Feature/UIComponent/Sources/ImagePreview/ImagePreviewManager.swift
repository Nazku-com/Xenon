//
//  ImagePreviewManager.swift
//  FediverseClient
//
//  Created by 김수환 on 1/12/25.
//

import SwiftUI
import SDWebImage

final class ImagePreviewManager {
    
    func showPreview(url: URL, previewURL: URL?) {
        let preview = ImagePreviewController(url: url, previewURL: previewURL)
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }
        DispatchQueue.main.async {
            window.rootViewController?.present(preview, animated: true)
        }
    }
}
