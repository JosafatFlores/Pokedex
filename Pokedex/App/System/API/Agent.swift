//
//  Agent.swift
//  Pokedex
//
//  Created by Josafat Flores on 20/05/21.
//

import Foundation
import Combine

struct Agent {
    func run<T: Decodable>(_ url: URLRequest) -> AnyPublisher<T, Error> {
    
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(T.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
