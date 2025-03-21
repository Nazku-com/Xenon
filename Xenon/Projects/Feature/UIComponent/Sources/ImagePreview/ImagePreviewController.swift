//
//  ImagePreviewController.swift
//  FediverseClient
//
//  Created by 김수환 on 1/12/25.
//

import QuickLook
import SDWebImage
import UIKit
import Kingfisher

private let previewContentDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
    .appendingPathComponent(Bundle.main.bundleIdentifier!)
    .appendingPathComponent("Preview")

class ImagePreviewController: QLPreviewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    var imageData: Data? {
        didSet { prepareFile() }
    }
    
    var targetLocation: URL? {
        didSet { reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }
    
    init(url: URL, previewURL: URL?) {
        super.init(nibName: nil, bundle: nil)
        Task {
            if let previewURL {
                await loadImageDataFromURL(previewURL)
            }
            await loadImageDataFromURL(url)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(#file) \(#function)")
        if let location = targetLocation {
            try? FileManager.default.removeItem(at: location)
        }
    }
    
    private func loadImageDataFromURL(_ url: URL) async {
        await withCheckedContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                guard let self else {
                    continuation.resume()
                    return
                }
                switch result {
                case .success(let image):
                    guard let data = image.data() else {
                        continuation.resume()
                        return
                    }
                    Task { @MainActor in
                        self.imageData = data
                        continuation.resume()
                    }
                case .failure:
                    continuation.resume()
                    return
                }
            }
        }
    }
    
    func prepareFile() {
        if let location = targetLocation {
            try? FileManager.default.removeItem(at: location)
        }
        targetLocation = nil
        reloadData()
        guard let data = imageData,
              let image = UIImage(data: data)
        else {
            return
        }
        try? FileManager.default.createDirectory(at: previewContentDirectory, withIntermediateDirectories: true)
        let tempLocation = previewContentDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(image.sd_imageFormat.possiblePathExtension)
        try? data.write(to: tempLocation, options: .atomic)
        guard FileManager.default.fileExists(atPath: tempLocation.path) else { // TODO: - Show error
            return
        }
        targetLocation = tempLocation
    }
    
    func numberOfPreviewItems(in _: QLPreviewController) -> Int {
        targetLocation == nil ? 0 : 1
    }
    
    func previewController(_: QLPreviewController, previewItemAt _: Int) -> QLPreviewItem {
        targetLocation! as QLPreviewItem
    }
}

extension SDImageFormat {
    var possiblePathExtension: String {
        switch self {
        case .undefined: ""
        case .JPEG: "jpg"
        case .PNG: "png"
        case .GIF: "gif"
        case .TIFF: "tiff"
        case .webP: "webp"
        case .HEIC: "heic"
        case .HEIF: "heif"
        case .PDF: "pdf"
        case .SVG: "svg"
        default: ""
        }
        //        static const SDImageFormat SDImageFormatUndefined = -1;
        //        static const SDImageFormat SDImageFormatJPEG      = 0;
        //        static const SDImageFormat SDImageFormatPNG       = 1;
        //        static const SDImageFormat SDImageFormatGIF       = 2;
        //        static const SDImageFormat SDImageFormatTIFF      = 3;
        //        static const SDImageFormat SDImageFormatWebP      = 4;
        //        static const SDImageFormat SDImageFormatHEIC      = 5;
        //        static const SDImageFormat SDImageFormatHEIF      = 6;
        //        static const SDImageFormat SDImageFormatPDF       = 7;
        //        static const SDImageFormat SDImageFormatSVG       = 8;
    }
}
