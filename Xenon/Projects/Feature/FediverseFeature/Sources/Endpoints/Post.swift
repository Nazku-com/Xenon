//
//  Post.swift
//  FediverseFeature
//
//  Created by 김수환 on 3/1/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func post(
        content: String,
        medias:[NetworkingFeature.MultipartFormData],
        visibility: FediverseResponseEntity.Visibility
    ) async -> Result<FediverseResponseEntity, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            async let mediaIDs = await uploadMedias(medias)
            let result = await NetworkingService().request(
                api: MastodonAPI.post(
                    from: url,
                    token: token,
                    content: content,
                    mediaIDs: mediaIDs,
                    visibility: visibility
                ),
                dtoType: MastodonResponseDTO.self
            )
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    private func uploadMedias(_ medias: [NetworkingFeature.MultipartFormData]) async -> [String] {
        await withTaskGroup(of: (Int, String?).self) { group in
            var results = Array<String?>(repeating: nil, count: medias.count)  // Placeholder array
            
            for (index, media) in medias.enumerated() {
                group.addTask {
                    let uploadedID = await uploadMedia(formData: media)
                    return (index, uploadedID)  // Return index with result
                }
            }
            
            // Collect results while preserving order
            for await (index, result) in group {
                results[index] = result  // Store result in correct position
            }
            
            return results.compactMap { $0 }  // Remove nil values
        }
    }
    
    private func uploadMedia(formData: NetworkingFeature.MultipartFormData) async -> String? {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            guard let data = await NetworkingService().request(api: MastodonAPI.media(from: url, token: token, content: formData)) else {
                return nil
            }
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return dictionary?["id"] as? String
        case .misskey:
            return nil
        }
    }
}
