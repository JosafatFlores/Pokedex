//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Josafat Flores on 19/05/21.
//

import Foundation
import Combine

final class PokemonListViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension PokemonListViewModel {
    enum State {
        case idle
        case loading
        case loaded([Results])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectPokemon(Int)
        case onPokemonLoaded([Results])
        case onFailedToLoadPokemon(Error)
    }
    
    struct Results: Identifiable{
        let id = UUID()
        let name: String?
        let url: String
        
        init(result: ResultsStruct) {
            name = result.name ?? ""
            url = result.url
        }
    }
}

extension PokemonListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadPokemon(let error):
                return .error(error)
            case .onPokemonLoaded(let results):
                return .loaded(results)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return PokemonAPI.fetchPokemon()
                .map { $0.results.map(Results.init) }
                .map(Event.onPokemonLoaded)
                .catch { Just(Event.onFailedToLoadPokemon($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
