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
            PokemonsList(
                pokemons: viewModel.state.pokemons,
                pokemonsDetail: viewModel.state.pokemonsDetail,
                isLoading: viewModel.state.canLoadNextPage,
                onScrolledAtBottom: viewModel.fetchNextOffSetIfPossible
                
            )
            .navigationBarTitle("Pokedex")
           
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: viewModel.fetchNextOffSetIfPossible)
    }
}

struct PokemonsList: View {
    let pokemons: [ResultsStruct]
    let pokemonsDetail: [PokemonDetailStruct]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            pokemonsList
            if isLoading {
                loadingIndicator
            }
        }
    }
    
    private var pokemonsList: some View {
        ForEach(pokemonsDetail) { pokemon in
            
            NavigationLink(destination: PokemonDetailView(viewModel: PokemonDetailViewModel(pokemon: pokemon)),
                               label: { pokemonsitoryRow(pokemon: pokemon) })
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("shadowTheme"), Color(pokemon.types?[0].type.name ?? "shadowTheme")]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(10)
                .padding(5)
                .frame( height: 150, alignment: .center)
                .onAppear {
                if self.pokemonsDetail.last == pokemon && self.pokemonsDetail.count % 20 == 0{
                    self.onScrolledAtBottom()
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(isAnimating: true, style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct pokemonsitoryRow: View {
    let pokemon: PokemonDetailStruct
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            pokemonImage
            VStack{
                pokemonName
                label
            }
            .frame(alignment: .top)
        }
        .frame(idealWidth: .infinity, idealHeight: .infinity, alignment: .leading)
    }
    
    private var pokemonImage: some View {
        AsyncImage(
            url: URL(string: pokemon.sprites!.frontDefault)!,
            cache: cache,
            placeholder: loadingIndicator,
            configuration: { $0.resizable().renderingMode(.original) }
        )
        .aspectRatio(contentMode: .fit)
        .frame(idealWidth:  UIScreen.main.bounds.width / 4, idealHeight: .infinity, alignment: .center)
        .shadow(color: Color("theme"), radius: 10)
        
    }
    
    private var pokemonName: some View {
        Text(pokemon.forms?[0].name?.firstUppercased ?? "no hay nombre")
            .foregroundColor(Color.white)
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .top)

    }
    
    private var label: some View{
        Text(pokemon.types?[0].type.name?.firstUppercased ?? "no hay tipo")
            .foregroundColor(Color.white)

    }
    
    private var loadingIndicator: some View {
        Spinner(isAnimating: true, style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

extension PokemonListView{
    
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
