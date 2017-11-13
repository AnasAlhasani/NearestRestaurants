//
//  NetworkRequest.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit


//MARK: - Network Request & Implementation
private protocol NetworkRequest: class {
    
    associatedtype Model
    
    func decode(_ data: Data) -> Model?
    
    func load(withURLParameters parameters: JSON?,
              onSuccess success: @escaping (Model?) -> Void,
              onFailure failure: @escaping (NetworkError) -> Void)
    
}

private extension NetworkRequest {
    
    func load(_ url: URL,
              onSuccess success: @escaping (Model?) -> Void,
              onFailure failure: @escaping (NetworkError) -> Void) {
        
        let success: (Model?) -> Void = { model in
            DispatchQueue.main.async { success(model) }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async { failure(error) }
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data else {
                    if let error = error {
                        failure(NetworkError(error: error))
                    } else {
                        failure(NetworkError(response: response))
                    }
                    return
            }
            
            success(self.decode(data))
        }
        
        task.resume()
    }
}

//MARK: - Api Request
class ApiRequest<Resource: ApiResource>: NetworkRequest {
    private let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    func decode(_ data: Data) -> [Resource.Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? JSON else {
            return nil
        }
        return resource.makeModel(from: jsonSerialization)

    }
    
    func load(withURLParameters parameters: JSON?,
              onSuccess success: @escaping ([Resource.Model]?) -> Void,
              onFailure failure: @escaping (NetworkError) -> Void) {
        
        let url = resource.getURLFromParameters(parameters ?? [:])
        load(url, onSuccess: success, onFailure: failure)
    }
    
}

//MARK: - Image Request
class ImageRequest: NetworkRequest {
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    
    func load(withURLParameters parameters: JSON?,
              onSuccess success: @escaping (UIImage?) -> Void,
              onFailure failure: @escaping (NetworkError) -> Void) {

        load(url, onSuccess: success, onFailure: failure)
    }
}
