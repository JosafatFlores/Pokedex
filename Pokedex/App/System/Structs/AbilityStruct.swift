//
//  AbilityStruct.swift
//  Pokedex
//
//  Created by Josafat Flores on 22/05/21.
//

import Foundation


struct AbilityStruct: Codable, Equatable{
    let name: String
    let effectEntries: [effectEntriesStruct]
    
    enum CodingKeys: String, CodingKey {
        case name
        case effectEntries = "effect_entries"
    }
    
    struct effectEntriesStruct: Codable, Equatable{
        let effect: String
        let language: languageStruct
        
        struct languageStruct: Codable, Equatable{
            let name: String
        }
    }
}
