//
//  NetworkRequest.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

protocol ApiResource {
    associatedtype Model
    func makeModel(from json: JSON) -> [Model]
}

private extension ApiResource {
    
    func getURLFromParameters(_ parameters: [String: Any]) -> URL {
        var components = URLComponents()
        components.scheme = Foursquare.URL.Scheme
        components.host = Foursquare.URL.Host
        components.path = Foursquare.URL.Path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
}

class ApiRequest<Resource> where Resource: ApiResource {
    
    private let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }

    func loadData(withParameters parameters: JSON,
                  onSuccess success: @escaping ([Resource.Model]?) -> Void,
                  onFailure failure: @escaping (NetworkError) -> Void) {
        
        let success: ([Resource.Model]?) -> Void = { model in
            DispatchQueue.main.async { success(model) }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async { failure(error) }
        }
        
        let session = URLSession.shared
        
        let url = resource.getURLFromParameters(parameters)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data),
                let json = jsonObject as? JSON else {
                    if let error = error {
                        failure(NetworkError(error: error))
                    } else {
                        failure(NetworkError(response: response))
                    }
                    return
            }
            
            success(self.resource.makeModel(from: json))
            
        }
        task.resume()
        
    }
}













