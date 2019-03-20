//
//  Endpoint.swift
//  Marvel
//
//  Created by Bruno Silva on 01/12/2018.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum MarvelAPI: HTTPEndpoint {
    case characters
    case empty
    
    var info: EndpointInfo {
        switch self {
        case .characters:
            return (.get, "characters")
        case .empty:
            return (.get, "")
        }
    }
}

extension HTTPRequest {
    var url: String {
        return "\(Configuration.API.url)\(self.endpoint.info.endpoint)"
    }
}

//extension MarvelAPI: HTTPRequest {
//
//    var environmentBaseURL : String {
//        switch NetworkManager.environment {
//        case .production:
//            return "https://gateway.marvel.com:443/v1/public/"
//        }
//    }
//
//    var baseURL: URL {
//        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
//        return url
//    }
//
//
//
//    var headers: HTTPHeaders? {
//        return nil
//    }
//
//}
