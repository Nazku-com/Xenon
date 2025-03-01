//
//  ImagePreviewManager.swift
//  FediverseClient
//
//  Created by 김수환 on 1/12/25.
//

import SwiftUI
import SDWebImage

final class ImagePreviewManager {
    
    func showPreview(image: UIImage) {
        let imageData: Data? = image.sd_imageData() ?? image.pngData()
        guard let data = imageData else { return }
        let preview = ImagePreviewController()
        preview.imageData = data
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }
        DispatchQueue.main.async {
            window.rootViewController?.present(preview, animated: true)
        }
    }
}

extension UIApplication {
    
    var firstKeyWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        return (scene as? UIWindowScene)?.keyWindow
    }
}
