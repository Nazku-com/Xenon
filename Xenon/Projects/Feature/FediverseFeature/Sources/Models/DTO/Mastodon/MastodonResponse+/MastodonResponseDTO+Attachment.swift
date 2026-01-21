//
//  Attachment.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    struct  Attachment: NetworkingDTOType, Hashable {
        /// ID of the attachment.
        public let id: String
        /// Type of the attachment.
        public let type: AttachmentType
        /// URL of the locally hosted version of the image.
        public let url: String
        /// For remote images, the remote URL of the original image.
        public let remoteURL: String?
        /// URL of the preview image.
        public let previewURL: String?
        /// A description of the image for the visually impaired.
        public let description: String?
        /// A free-form object that might contain information about the attachment.
        public let meta: Meta?
        /// blurhash
        public let blurhash: String?
        
        public enum AttachmentType: String, Codable, Hashable, Sendable {
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
        
        public struct Meta: Codable, Hashable, Sendable {
            
            public let original: Info?
            
            public struct Info: Codable, Hashable, Sendable {
                public let aspect: Double?
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case type
            case url
            case remoteURL = "remote_url"
            case previewURL = "preview_url"
            case description
            case blurhash
            case meta
        }
        
        
        public func toEntity() async throws -> FediverseResponseEntity.Attachment {
            .init(
                id: id,
                type: .init(rawValue: type.rawValue) ?? .unknown,
                url: url,
                remoteURL: remoteURL,
                previewURL: previewURL,
                description: await description?.parseHTMLToMarkdown() ?? "",
                aspect: meta?.original?.aspect,
                blurhash: blurhash
            )
        }
    }
}
