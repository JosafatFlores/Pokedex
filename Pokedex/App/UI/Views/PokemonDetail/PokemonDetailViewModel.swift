//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Josafat Flores on 22/05/21.
//

import Foundation
import Combine

final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    init(pokemon: PokemonDetailStruct) {
        state.pokemon = pokemon
        fetchAbilities()
        state.abilitySelected = (state.pokemon?.abilities?[0].ability?.name)!
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            print(completion)
        }
    }
    
    private func fetchAbilities(){
        for ability in state.pokemon?.abilities ?? []{
            PokemonAPI.fetchAbility(url: (ability.ability?.url)!)
                .sink(receiveCompletion: onReceive,
                      receiveValue: onReciveAbility)
                .store(in: &subscriptions)
        }
    }
    
    private func onReciveAbility(_ batch: AbilityStruct) {
        state.abilities.append(batch)
        changeAbilitySelected(ability: state.abilitySelected)
    }
    
    func changeAbilitySelected(ability: String){
        state.abilitySelected = ability
        for abil in state.abilities {
            if abil.name == ability{
                for effect in abil.effectEntries{
                    effect.language.name == "en"
                        ? state.abilityDescription = effect.effect
                        : nil
                }
            }
        }
    }
    
    struct State {
        var pokemon: PokemonDetailStruct? = nil
        var abilities: [AbilityStruct] = []
        var abilitySelected: String = ""
        var abilityDescription: String = ""
    }
}
