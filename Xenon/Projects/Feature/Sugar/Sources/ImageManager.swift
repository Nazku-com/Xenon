//
//  ImageManager.swift
//  xenon
//
//  Created by 김수환 on 12/10/25.
//

import UIKit
import NetworkingFeature

public final class ImageManager {
    
    // MARK: - Interface
    
    public static let shared = ImageManager()
    
    @BackgroundActor
    public func loadImage(with url: URL) async -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        if let existingTask = loadingTasks[url] {
            return await existingTask.value
        }
        
        let task = Task { @BackgroundActor () -> UIImage? in
            defer { self.loadingTasks[url] = nil }
            
            guard let data = try? await service.request(api: DirectRequestAPI.init(baseURL: url, method: .get)).throw().0,
                  let image = UIImage(data: data)
            else {
                return nil
            }
            
            cache.setObject(image, forKey: url as NSURL)
            return image
        }
        
        loadingTasks[url] = task
        return await task.value
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    // MARK: - Attribute
    
    private let service: NetworkingServiceType
    private var loadingTasks: [URL: Task<UIImage?, Never>] = [:]
    private let cache: NSCache<NSURL, UIImage>
    
    // MARK: - Initialization
    
    init (
        service: NetworkingServiceType = NetworkingService(),
        cache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>()
    ) {
        self.service = service
        self.cache = cache
    }
}
