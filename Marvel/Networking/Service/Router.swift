//
//  Router.swift
//  Marvel
//
//  Created by Bruno Silva on 01/12/2018.
//

import Foundation

class RouterNew {
    private var task: URLSessionTask?
    private var md5Digest: String {
        let digest = APIConstant.Value.timeStamp +
            APIConstant.Value.privateKey +
            APIConstant.Value.publicKey

        return "\(digest.utf8.md5)"
    }

    fileprivate func buildRequest(request: HTTPRequest, page: Int, url: URL) throws -> URLRequest {
        var customRequest = URLRequest(url: url,
                                       cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                       timeoutInterval: APIConstant.Value.timeoutInterval)
        customRequest.httpMethod = request.endpoint.info.method.rawValue
        
        if !request.body.isEmpty {
            do {
                try JSONParameterEncoder.encode(urlRequest: &customRequest, with: request.body)
            } catch {
                throw error
            }
        }
        
        self.addURLQueryItems(request: &customRequest, page: page)
        
        return customRequest
    }
    
    func request(with request: HTTPRequest, page: Int, completion: @escaping NetworkRouterCompletion) {
        guard let url = URL(string: request.url) else { return }
        
        do {
            let customRequest = try self.buildRequest(request: request, page: page, url: url)
            print(request.debugDescription)
            let session = URLSession.shared
            self.task = session.dataTask(with: customRequest, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
            self.task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func addURLQueryItems(request: inout URLRequest, page: Int) {
        let queryItems = [URLQueryItem(name: APIConstant.Parameter.timeStamp, value: APIConstant.Value.timeStamp),
                          URLQueryItem(name: APIConstant.Parameter.apiKey, value: APIConstant.Value.publicKey),
                          URLQueryItem(name: APIConstant.Parameter.hash, value: md5Digest),
                          URLQueryItem(name: APIConstant.Parameter.limit, value: "\(APIConstant.Value.limit)"),
                          URLQueryItem(name: APIConstant.Parameter.offset, value: "\(APIConstant.Value.limit * page)")]

        if let urlString = request.url?.absoluteString {
            var urlComps = URLComponents(string: urlString)
            urlComps?.queryItems = queryItems
            request.url = urlComps?.url
        }
    }
    
}


//class Router<Endpoint: HTTPRequest>: NetworkRouter {
//    private var task: URLSessionTask?
//    private var timeStamp: String {
//        return APIConstant.Parameter.timeStamp + APIConstant.Value.timeStamp
//    }
//    
//    private var apiKey: String {
//        return APIConstant.Parameter.apiKey + APIConstant.Value.publicKey
//    }
//    
//    private var md5Digest: String {
//        let digest = APIConstant.Value.timeStamp +
//            APIConstant.Value.privateKey +
//            APIConstant.Value.publicKey
//        
//        return "\(digest.utf8.md5)"
//    }
//    
//    func request(urlString: String, completion: @escaping NetworkRouterCompletion) {
//        guard let url = URL(string: urlString) else { return }
//        
//        var request = URLRequest(url: url,
//                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
//                                 timeoutInterval: APIConstant.Value.timeoutInterval)
//        
//        request.httpMethod = HTTPMethod.get.rawValue
//        self.addURLQueryItems(request: &request, page: 0)
//    
////        print(request.url?.absoluteString ?? "")
//        let session = URLSession.shared
//        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
//            completion(data, response, error)
//        })
//        task?.resume()
//    }
//    
//    func request(_ route: Endpoint, page: Int, completion: @escaping NetworkRouterCompletion) {
//        let session = URLSession.shared
//        do {
//            let request = try self.buildRequest(from: route, page: page)
//            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
//                completion(data, response, error)
//            })
//            task?.resume()
//        } catch  {
//            completion(nil, nil, error)
//        }
//    }
//    
//    func cancel() {
//        self.task?.cancel()
//    }
//    
//    fileprivate func buildRequest(from route: Endpoint, page: Int) throws -> URLRequest {
//        
//        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.info.endpoint),
//                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
//                                 timeoutInterval: APIConstant.Value.timeoutInterval)
//        
//        request.httpMethod = route.info.method.rawValue
//        
//        do {
//            switch route.info.task {
//            case .request:
//                request.setValue(HeaderConstant.value.applicationJson,
//                                 forHTTPHeaderField: HeaderConstant.type.contentType)
//            case .requestParameters(let bodyParameters,
//                                    let urlParameters):
//                
//                try self.configureParameters(bodyParameters: bodyParameters,
//                                             urlParameters: urlParameters,
//                                             request: &request)
//                
//            case .requestParametersAndHeaders(let bodyParameters,
//                                              let urlParameters,
//                                              let additionalHeaders):
//                
//                self.addAdditionalHeaders(additionalHeaders, request: &request)
//                try self.configureParameters(bodyParameters: bodyParameters,
//                                             urlParameters: urlParameters,
//                                             request: &request)
//            }
//            
//            self.addURLQueryItems(request: &request, page: page)
//            
//            return request
//        } catch {
//            throw error
//        }
//    }
//    
//    func addURLQueryItems(request: inout URLRequest, page: Int) {
//        let queryItems = [URLQueryItem(name: APIConstant.Parameter.timeStamp, value: APIConstant.Value.timeStamp),
//                          URLQueryItem(name: APIConstant.Parameter.apiKey, value: APIConstant.Value.publicKey),
//                          URLQueryItem(name: APIConstant.Parameter.hash, value: md5Digest),
//                          URLQueryItem(name: APIConstant.Parameter.limit, value: "\(APIConstant.Value.limit)"),
//                          URLQueryItem(name: APIConstant.Parameter.offset, value: "\(APIConstant.Value.limit * page)")]
//
//        if let urlString = request.url?.absoluteString {
//            var urlComps = URLComponents(string: urlString)
//            urlComps?.queryItems = queryItems
//            request.url = urlComps?.url
//        }
//    }
//        
//    fileprivate func configureParameters(bodyParameters: Parameters?,
//                                         urlParameters: Parameters?,
//                                         request: inout URLRequest) throws {
//        do {
//            if let bodyParameters = bodyParameters {
//                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
//            }
//            if let urlParameters = urlParameters {
//                try JSONParameterEncoder.encode(urlRequest: &request, with: urlParameters)
//            }
//        } catch {
//            throw error
//        }
//    }
//    
//    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
//        guard let headers = additionalHeaders else { return }
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//    }
//    
//}
