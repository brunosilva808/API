//
//  Link.swift
//  Marvel
//
//  Created by Carbon on 20/03/2019.
//

import Foundation

extension Request {
    
    struct Link: HTTPRequestString {
        var url: String = ""
        var endpoint: HTTPEndpoint { return MarvelAPI.empty }
        var body: [String : Any] { return [:] }
    }
}
