//
//  Attachment.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension FediverseResponseEntity {
    
    struct  Attachment: NetworkingEntityType, Hashable, Equatable {
        /// ID of the attachment.
        public let id: String
        /// Type of the attachment.
        public let type: AttachmentType
        /// URL of the locally hosted version of the image.
        public let url: URL?
        /// For remote images, the remote URL of the original image.
        public let remoteURL: URL?
        /// URL of the preview image.
        public let previewURL: URL?
        /// A description of the image for the visually impaired.
        public let description: String?
        /// aspect of attachment
        public let aspect: Double?
        /// blurhash
        public let blurhash: String?
        
        public enum AttachmentType: String, Codable, Hashable {
            /// The attachment contains a static image.
            case image
            /// The attachment contains a video.
            case video
            /// The attachment contains a gif image.
            case gifv
            /// The attachment contains an audio file.
            case audio
            /// The attachment contains an unknown image file.
            case unknown
        }
        
        init(
            id: String,
            type: AttachmentType,
            url: String,
            remoteURL: String?,
            previewURL: String?,
            description: String?,
            aspect: Double?,
            blurhash: String?
        ) {
            self.id = id
            self.type = type
            self.url = .init(string: url)
            self.remoteURL = .init(string: remoteURL ?? "")
            self.previewURL = .init(string: previewURL ?? "")
            self.description = description
            self.aspect = aspect
            self.blurhash = blurhash
        }
    }
}
