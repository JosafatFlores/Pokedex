//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Josafat Flores on 21/05/21.
//

import Foundation


struct PokemonDetailStruct: Codable, Identifiable, Equatable{
   
    
    let id: Int
    let forms: [forms]?
    let abilities: [abilitiesStruct]?
    let height: Int?
    let weight: Int?
    let frontDefault: String?
    let frontShiny: String?
    let sprites: spritesStruct?
    let types: [typesStruct]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case forms
        case abilities
        case height
        case weight
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case sprites
        case types
    }
    
    struct forms: Codable, Equatable {
        let name: String?
    }
    
    struct abilitiesStruct: Codable, Equatable, Identifiable{
        let id = UUID()
        let ability: abilityStruct?
        let isHidden: Bool?
        
        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
        }
        
        struct abilityStruct: Codable, Equatable{
            let name: String?
            let url: String?
        }
    }
    
    struct spritesStruct: Codable, Equatable{
        let frontDefault: String
        let frontShiny: String
        let other: otherStruct?
        
        enum CodingKeys: String, CodingKey {
            case other
            case frontDefault = "front_default"
            case frontShiny = "front_shiny"
        }
        
        struct  otherStruct: Codable, Equatable {
            let officialArtWork : artworkStruct?
            
            enum CodingKeys: String, CodingKey {
                case officialArtWork = "official-artwork"
            }
            
            struct artworkStruct: Codable, Equatable {
                let frontDefault: String
               
                enum CodingKeys: String, CodingKey {
                    case frontDefault = "front_default"
                }
            }
            
        }
    }
    
    struct typesStruct: Codable, Equatable, Identifiable {
        let id = UUID()
        let slot: Int
        let type: typeStruct
        
        struct typeStruct: Codable, Equatable {
            let name: String?
        }
    }
}
