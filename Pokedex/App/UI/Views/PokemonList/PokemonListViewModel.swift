//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Josafat Flores on 19/05/21.
//

import Foundation
import Combine

final class PokemonListViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    var pokemonsFinded = 0
    var pokemonsTemp: [PokemonDetailStruct] = []
    
    func fetchNextOffSetIfPossible() {
        guard state.canLoadNextPage else { return }
        
        PokemonAPI.fetchPokemon(offSet: state.offSet)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceivePokemons)
            .store(in: &subscriptions)
        state.offSet += 20
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            print(completion)
            state.canLoadNextPage = false
        }
    }
    
    private func onReceivePokemons(_ batch: PokemonResponseStruct) {
        state.pokemons += batch.results
        state.canLoadNextPage = batch.count > state.offSet
        for pokemon in batch.results{
            self.fechtPokemonDetail(url: pokemon.url)
        }
    }
    
    private func fechtPokemonDetail(url: String){
        PokemonAPI.fetchPokemonDetail(url: url)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceivePokemonDetail)
            .store(in: &subscriptions)
    }
    

    private func onReceivePokemonDetail(_ batch: PokemonDetailStruct) {
       
        pokemonsFinded += 1
        pokemonsTemp.append(batch)
        
        
        if pokemonsFinded > 19{
            pokemonsTemp.sort{$0.id < $1.id}
            
            state.pokemonsDetail += pokemonsTemp
            pokemonsTemp = []
            pokemonsFinded = 0
        }
        
        
    }
    
    struct State {
        var pokemons: [ResultsStruct] = []
        var pokemonsDetail: [PokemonDetailStruct] = []
        var offSet: Int = 0
        var canLoadNextPage = true
    }
}
