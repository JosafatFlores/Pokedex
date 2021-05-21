//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Josafat Flores on 19/05/21.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListView(viewModel: PokemonListViewModel())
        }
    }
}
