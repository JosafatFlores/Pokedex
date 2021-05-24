//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Josafat Flores on 22/05/21.
//

import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    var body: some View {
        pokemonView(
            viewModel: viewModel,
            pokemon: viewModel.state.pokemon!
            
        )
        .navigationTitle("#" + String(viewModel.state.pokemon!.id))
        .navigationBarTitleDisplayMode(.inline)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
        
    }
    
    
}

struct pokemonView: View{
    @ObservedObject var viewModel: PokemonDetailViewModel
    let pokemon: PokemonDetailStruct
    
    
    @Environment(\.imageCache) var cache: ImageCache
    
    
    var body: some View {
        VStack{
            
            pokemonImage
                .frame(alignment: .top)
                .padding(.top, 60)
            infoPokemon
        }
        .frame(width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
        .background(Color((pokemon.types?[0].type.name!)!))
        
    }
    
    private var pokemonImage: some View {
        HStack{
            AsyncImage(
                url: URL(string: (pokemon.sprites?.other?.officialArtWork?.frontDefault)!)!,
                cache: cache,
                placeholder: loadingIndicator,
                configuration: { $0.resizable().renderingMode(.original) }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width:  UIScreen.main.bounds.width / 2, alignment: .center)
            .shadow(color: Color("shadowTheme"), radius: 20)
        }
        .frame(alignment: .top)
        
    }
    
    private var infoPokemon: some View{
        VStack{
            namePokemon
            ScrollView(.vertical, showsIndicators: true){
                types
                charateristics
                Divider()
                abilities
                Divider()
                sprites
                Spacer(minLength: 50)
            }
            
        }
        .background(Color((pokemon.types?[0].type.name!)! + "Dark"))
    }
    
    private var abilities: some View {
        VStack{
            HStack{
                ForEach((pokemon.abilities)!){ ability in
                    Button {
                        viewModel.changeAbilitySelected(ability: (ability.ability?.name)!)
                    } label: {
                        Text((ability.ability?.name?.firstUppercased)!)
                            .font(.body)
                            .padding(5)
                            .foregroundColor(Color(ability.isHidden! ? .lightGray : .white))
                            .background(
                                Color(
                                    viewModel.state.abilitySelected == ability.ability?.name
                                        ? (pokemon.types![0].type.name)!
                                        : (pokemon.types![0].type.name)! + "Dark"
                                )
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color((pokemon.types![0].type.name)!), lineWidth: 2)
                            )
                        
                        
                    }
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            Text(viewModel.state.abilityDescription)
                .padding()
                .lineLimit(nil)
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
        }
        
    }
    
    private var namePokemon:  some View {
        Text((pokemon.forms?[0].name!.firstUppercased)!)
            .font(.largeTitle)
            .padding(10)
    }
    
    private var charateristics: some View{
        HStack{
            Text("Weight: " + String(pokemon.weight!) + " kg")
                .font(.body)
                .padding(5)
            Text("Height: " + String(pokemon.height!) + " m")
                .font(.body)
                .padding(5)
        }
    }
    
    private var types: some View {
        
        HStack{
            ForEach(pokemon.types!){ type in
                Text(type.type.name!.firstUppercased)
                    .font(.body)
                    .padding(5)
                
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
    }
    
    private var sprites: some View{
        HStack{
            VStack{
                Text("Common")
                AsyncImage(
                    url: URL(string: pokemon.sprites!.frontDefault)!,
                    cache: cache,
                    placeholder: loadingIndicator,
                    configuration: { $0.resizable().renderingMode(.original) }
                )
                .aspectRatio(contentMode: .fit)
                .frame(width:  UIScreen.main.bounds.width / 2, alignment: .center)
                .shadow(color: Color("shadowTheme"), radius: 20)
            }
            VStack{
                Text("Shiny")
                AsyncImage(
                    url: URL(string: pokemon.sprites!.frontShiny)!,
                    cache: cache,
                    placeholder: loadingIndicator,
                    configuration: { $0.resizable().renderingMode(.original) }
                )
                .aspectRatio(contentMode: .fit)
                .frame(width:  UIScreen.main.bounds.width / 2, alignment: .center)
                .shadow(color: Color("shadowTheme"), radius: 20)
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(isAnimating: true, style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

