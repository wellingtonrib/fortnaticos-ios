//
//  ApiClient.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

class ApiManager {
    
    var clientID: String = ""
    var clientSecret: String = ""
    
    static let shared = ApiManager()
    
    private init() {}
    
    func request<T: Decodable>(requestPath: String,
                               method: HTTPMethod = .get,
                               parameters: [String:Any] = [:],
                               multipartData: [String:Any]? = nil,
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        var headers: HTTPHeaders = HTTPHeaders()
        headers["Accept"] = "application/json"
        
        if let token = UserDefaultsManager.shared
            .standard.string(forKey: "access_token") {
        
            headers["Authorization"] = "Bearer \(token)"
        }
                
        let url = AppURL.BaseURL + "\(requestPath)".regexReplace(pattern: "^(.+?)\\?(.+?)\\?(.+)$", replace: "$1?$2&$3")
        
        let responseHandler : ((DataResponse<T, AFError>) -> Void) = { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        }
        
        if let multipart = multipartData {
            AF.upload(multipartFormData: { (formdata) in
                for (key, value) in multipart  {
                    if let uiImage = value as? UIImage {
                        let image = uiImage.jpegData(compressionQuality: 1)
                        formdata.append(image!, withName: key, fileName: key.appending(".jpeg"), mimeType: "image/*")
                    }
                    if let string = value as? String {
                        formdata.append(string.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            }, to: url, method: method, headers: headers).apiResponseDecodable(of: T.self) { response in
                    responseHandler(response)
            }
        } else {
            AF.request(url, method: method, parameters: parameters, headers: headers)
                .apiResponseDecodable(of: T.self) { response in
                    responseHandler(response)
            }
        }
    }        
}

struct ApiToken: Decodable {
    var access_token: String
}

struct ApiResponse: Decodable {
    var message: String
}

struct ApiError: Decodable, Error, LocalizedError {
    
    var message : String
    var error : String?
    var errors : JSON?
    
    init(message: String) {
        self.message = message
    }
    
    var errorDescription: String? {
        if let errors = errors.dictionary {
            var fieldErrorsMessage = "Erro na validação dos dados\n"
            for field in errors.keys {
                if let fieldErrors = errors[field] as? [String] {
                    fieldErrorsMessage.append(fieldErrors.joined(separator: "\n"))
                }
                fieldErrorsMessage.append("\n")
            }
            return fieldErrorsMessage
        }
        return self.message
    }
}

class ApiResponseSerializer<T: Decodable>: ResponseSerializer {
    
    let decoder: DataDecoder
    
    init(decoder: DataDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        
        guard error == nil else { throw error! }
        
        guard let response = response else { throw ApiError(message: "NoResponse") }
        
        if 200..<300 ~= response.statusCode {
            do {
                return try decoder.decode(T.self, from: data!)
            } catch {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
            }
        } else {
            let apiError = try decoder.decode(ApiError.self, from: data!)
            throw AFError.responseSerializationFailed(reason: .customSerializationFailed(error: apiError))
        }
    }
}

extension DataRequest {
    
    @discardableResult func apiResponseDecodable<T: Decodable>(queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), of t: T.Type, completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        
        return response(queue: queue, responseSerializer: ApiResponseSerializer<T>(), completionHandler: completionHandler)
    }
}
