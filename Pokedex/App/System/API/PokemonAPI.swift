//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by Josafat Flores on 20/05/21.
//

import Foundation
import Combine

class PokemonAPI {
    private static let base = URL(string: "https://pokeapi.co/api/v2/")!

    private static let agent = Agent()
    
    static func fetchPokemon() -> AnyPublisher<PokemonResponseStruct, Error> {
        let request = URLComponents(url: base.appendingPathComponent("pokemon/"), resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

private extension URLComponents {
    
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}



