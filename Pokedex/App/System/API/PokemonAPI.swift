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
    
    static func fetchPokemon(offSet: Int) -> AnyPublisher<PokemonResponseStruct, Error> {
        let request = URLComponents(url: base.appendingPathComponent("pokemon/"), resolvingAgainstBaseURL: true)?
            .addParamsUrl(value: String(offSet))
            .request
        return agent.run(request!)
    }
    
    static func fetchPokemonDetail(url: String) -> AnyPublisher<PokemonDetailStruct, Error> {
        let request = URLComponents(url: URL(string:  url)!, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
    
    static func fetchAbility(url: String) -> AnyPublisher<AbilityStruct, Error> {
        let request = URLComponents(url: URL(string:  url)!, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

private extension URLComponents {
    
    func addParamsUrl( value: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: "offset", value: value), URLQueryItem(name: "limit", value: "20")]
        return copy
    }
    
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}



