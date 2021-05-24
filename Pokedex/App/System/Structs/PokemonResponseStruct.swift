//
//  PokemonResponse.swift
//  Pokedex
//
//  Created by Josafat Flores on 20/05/21.
//

import Foundation

struct PokemonResponseStruct: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [ResultsStruct]
}

struct ResultsStruct: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String?
    let url: String
}
