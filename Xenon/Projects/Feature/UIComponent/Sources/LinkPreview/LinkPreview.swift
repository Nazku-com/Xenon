//
//  LinkPreview.swift
//  UIComponent
//
//  Created by 김수환 on 12/17/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import NetworkingFeature
import LinkPresentation
import UniformTypeIdentifiers

@Observable
@MainActor
final class PreviewViewModel {
    
    // MARK: - Interface
    
    var isError: Bool = false
    var image: UIImage?
    var title: String?
    let previewURL: URL?
    
    // MARK: - Initialization
    
    init(_ url: URL?) {
        self.previewURL = url
    }
    
    @LinkPreviewActor
    func fetchMetadata() async {
        let isError = await isError
        let image = await image
        guard !isError,
              image == nil
        else {
            return
        }
        guard let previewURL else {
            Task { @MainActor in
                self.isError = true
            }
            return
        }
        let provider = LPMetadataProvider()
        
        do {
            let metadata = try await provider.startFetchingMetadata(for: previewURL)
            try await convertToImage(metadata.imageProvider)
            Task { @MainActor in
                title = metadata.title
            }
        } catch {
            Task { @MainActor in
                self.isError = true
            }
            return
        }
    }
    
    @LinkPreviewActor
    private func convertToImage(_ imageProvider: NSItemProvider?) async throws {
        let type = String(describing: UTType.image)
        guard let imageProvider,
              imageProvider.hasItemConformingToTypeIdentifier(type)
        else {
            return
        }
        let item = try await imageProvider.loadItem(forTypeIdentifier: type)
        
        if item is UIImage {
            Task { @MainActor in
                image = item as? UIImage
            }
            return
        }
        
        if item is URL {
            guard let url = item as? URL,
                  let data = try? Data(contentsOf: url)
            else {
                return
            }
            Task { @MainActor in
                image = UIImage(data: data)
            }
            return
        }
        
        if item is Data {
            guard let data = item as? Data else { return }
            Task { @MainActor in
                image = UIImage(data: data)
            }
            return
        }
    }
}

public struct LinkPreview: View {
    
    @State var model: PreviewViewModel
    
    public var body: some View {
        HStack {
            if let image = model.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(.rect(cornerRadius: 4))
            } else {
                ProgressView()
                    .frame(width: 80, height: 80)
            }
            VStack(alignment: .leading) {
                Text(model.title ?? "Loading...")
                Text(model.previewURL?.absoluteString ?? "")
            }
            .font(.styled(.caption))
        }
        .frame(height: 80)
        .frame(maxWidth: 300, alignment: .leading)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.black.opacity(0.3))
        }
        .animation(.easeInOut, value: model.image)
        .animation(.easeInOut, value: model.title)
        .task {
            await model.fetchMetadata()
        }
    }
    
    public init(url: URL) {
        model = .init(url)
    }
    public init(url: String) {
        model = .init(.init(string: url))
    }
}

#Preview {
    VStack {
        LinkPreview(url: .init(string: "https://xenon.social")!)
        LinkPreview(url: .init(string: "https://xenon.social")!)
    }
}
