//
//  Character.swift
//  Marvel
//
//  Created by Bruno Silva on 07/01/2019.
//

import Foundation

extension Request {

    struct Character: HTTPRequest {
        var endpoint: HTTPEndpoint { return MarvelAPI.characters }
    }
}


