//
//  InstanceListService.swift
//  xenon
//
//  Created by 김수환 on 12/9/25.
//

import Foundation
import NetworkingFeature

final class InstanceListService {
    
    func list() async throws -> [InstanceInfoEntity] {
        let result = await service.request(api: InstanceSocialAPI.list, dtoType: InstancesInfoDTO.self)
        switch result {
        case .success(let success):
            return success.data
        case .failure(let failure):
            throw failure
        }
    }
    
    func search(name: String) async throws -> [InstanceInfoEntity] {
        let result = await service.request(api: InstanceSocialAPI.search(name), dtoType: InstancesInfoDTO.self)
        switch result {
        case .success(let success):
            return success.data
        case .failure(let failure):
            throw failure
        }
    }
    
    let service = NetworkingService()
}

enum InstanceSocialAPI {
    
    case list
    case search(String)
}

extension InstanceSocialAPI: NetworkingAPIType {
    
    var baseURL: URL {
        URL(string: "https://instances.social/api/1.0/instances/")!
    }
    
    var path: String? {
        switch self {
        case .list:
            "list"
        case .search:
            "search"
        }
    }
    
    var method: NetworkingFeature.HttpMethod {
        .get
    }
    
    var headers: [String : String] {
        [
            "Authorization": "Bearer Fb3Wvhdm1aXlbSM9jTFFutpbx5AyLJ0j0PtRLG5DM5DD9SNgChm8rchY9VsLJuA1vZtY0YcytCl2nSrxJ2dVwPx5V7TtmiBjuCijQZ367pjQfH1PWK0SmdJzEca3HQNo"
        ]
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .list:
            [
                .init(name: "count", value: "1000"),
                .init(name: "include_closed", value: "false"),
                .init(name: "include_dead", value: "false")
            ]
        case .search(let searchText):
            [
                .init(name: "q", value: searchText)
            ]
        }
    }
    
    var uploadData: NetworkingFeature.MultipartFormData? { nil }
    
    var body: [String : Any] { [:] }
}

struct InstancesInfoDTO: NetworkingDTOType {
    
    let instances: [Instance]
    
    struct Instance: Codable {
        
        let id: String?
        let name: String?
        let version: String?
        let https_score: Int?
        let https_rank: String?
        let users: String?
        let open_registrations: Bool?
        let info: Info?
        let thumbnail: String?
        let email: String?
        let admin: String?
        
        struct Info: Codable {
            
            let short_description: String?
            let full_description: String?
            let topic: String?
            let languages: [String]?
            let other_languages_accepted: Bool?
            let prohibited_content: [String]?
        }
    }
    func toEntity() async -> [InstanceInfoEntity] {
        instances.compactMap { instance in
            guard let id = instance.id,
                  let name = instance.name,
                  let version = instance.version
            else {
                return nil
            }
            let info: InstanceInfoEntity.Info? = instance.info.map {
                InstanceInfoEntity.Info(
                    shortDescription: $0.short_description ?? "",
                    fullDescription: $0.full_description ?? "",
                    topic: $0.topic ?? "",
                    languages: $0.languages ?? [],
                    otherLanguagesAccepted: $0.other_languages_accepted ?? false,
                    prohibitedContent: $0.prohibited_content ?? []
                )
            }
            guard let info else {
                return nil
            }
            return .init(
                id: id,
                name: name,
                version: version,
                httpsScore: instance.https_score,
                httpsRank: instance.https_rank,
                users: instance.users ?? "Unknown",
                openRegistrations: instance.open_registrations ?? false,
                info: info,
                thumbnail: .init(string: instance.thumbnail ?? ""),
                email: instance.email ?? "Unknown",
                admin: instance.admin ?? "Unknown"
            )
        }
    }
}
struct InstanceInfoEntity: NetworkingEntityType, Identifiable, Equatable {
    
    let id: String
    let name: String
    let version: String
    
    let httpsScore: Int?
    let httpsRank: String?
    
    let users: String
    
    let openRegistrations: Bool
    let info: Info
    
    let thumbnail: URL?
    let email: String
    let admin: String
    
    struct Info: Codable, Equatable {
        
        let shortDescription: String
        let fullDescription: String
        let topic: String
        let languages: [String]
        let otherLanguagesAccepted: Bool
        let prohibitedContent: [String]
    }
}
