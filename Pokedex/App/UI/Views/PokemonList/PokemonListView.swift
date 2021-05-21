//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Josafat Flores on 19/05/21.
//

import SwiftUI
struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Pokedex By Cronox")
        }
                .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let results):
            return list(of: results).eraseToAnyView()
        }
    }
    
    private func list(of results: [PokemonListViewModel.Results]) -> some View {
        return List(results) { result in
             ListItem(result: result)
        }
    }
}
struct ListItem: View {
    let result: PokemonListViewModel.Results
   
    
    var body: some View {
        Text(result.name ?? "Name not found")
    }
}


struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
