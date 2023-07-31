//
//  NetworkingManager.swift
//  MoCrypto
//
//  Created by Corptia on 25/07/2023.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError{
        case badURLResponse(url: URL , errorCode: Int)
        case unknown
        
        
        var errorDescription: String?{
            switch self{
            case .badURLResponse(url: let url , errorCode: let errorCode): return "[🔥] Bad response from URL: \(url) - code is \(errorCode)"
            case .unknown : return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        // no need to subscribe to background it goes backgound automaticly
//            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0 ,url: url)})
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output , url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
            throw NetworkingError.badURLResponse(url: url ,errorCode: (output.response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
