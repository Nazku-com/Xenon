//
//  ImagePicker.swift
//  UIComponent
//
//  Created by 김수환 on 3/29/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import PhotosUI

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding var pickerResult: [UIImage]
    @Binding var isLoading: Bool
    @Binding var isPresented: Bool
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images // filter only to images
        configuration.selectionLimit = .max
        
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: PHPickerViewControllerDelegate {
        private let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.pickerResult.removeAll()
            parent.isLoading = true
            Task {
                let findableResults = results.compactMap { $0.itemProvider.canLoadObject(ofClass: UIImage.self) ? $0 : nil }
                var results: [UIImage] = []
                for result in findableResults {
                    let image = await loadImage(from: result)
                    if let image {
                        results.append(image)
                    }
                }
                parent.pickerResult = results
                parent.isLoading = false
                parent.isPresented = false
            }
        }
        
        private func loadImage(from provider: PHPickerResult) async -> UIImage? {
            await withCheckedContinuation { continuation in
                provider.itemProvider.loadObject(ofClass: UIImage.self) { newImage, _ in
                    let image = newImage as? UIImage
                    continuation.resume(returning: image)
                }
            }
        }
    }
    
    public init(pickerResult: Binding<[UIImage]>, isLoading: Binding<Bool>, isPresented: Binding<Bool>) {
        _pickerResult = pickerResult
        _isLoading = isLoading
        _isPresented = isPresented
    }
}
