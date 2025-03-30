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
            
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            print("Can't load image \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                            self?.parent.pickerResult.append(image)
                        }
                    }
                } else {
                    print("Can't load asset")
                }
            }
            
            parent.isPresented = false
        }
    }
    
    public init(pickerResult: Binding<[UIImage]>, isPresented: Binding<Bool>) {
        _pickerResult = pickerResult
        _isPresented = isPresented
    }
}
