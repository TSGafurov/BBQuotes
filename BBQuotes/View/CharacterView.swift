//
//  CharacterView.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 06/11/25.
//

import SwiftUI

struct CharacterView: View {
    
    let vm: ViewModel
    let character: Char
    let show: String
    
    @State private var currentQuote: String?
    @State private var isFetchingQuote = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .top){
                    Image(show.removeCaseAndSpace())
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView {
                        TabView{
                            ForEach(character.images,id: \.self) { characterImageURL in
                                AsyncImage(url: characterImageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width / 1.2, height: geo.size.height / 1.7)
                        .clipShape(.rect(cornerRadius: 25))
                        .padding(.top, 60)
                        
                        VStack(alignment: .leading){
                            Group  {
                                if isFetchingQuote {
                                    HStack(alignment: .center, spacing: 8) {
                                        ProgressView()
                                        Text("Loading quote…")
                                    }
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                } else if let characterQuote = currentQuote ?? character.quote?.quote {
                                    Text("\"\(characterQuote)\"")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .contentShape(Rectangle())
                                        .contentTransition(.opacity)
                                } else {
                                    Text("No quote available")
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .accessibilityAddTraits(.isButton)
                                }
                            }
                            .onTapGesture {
                                fetchNewQuote()
                            }
                            .frame(alignment: .center)
                            
                            Divider()
                            
                            Text(character.name)
                                .font(.largeTitle)
                            
                            Text("Portrayed by: \(character.portrayedBy)")
                                .font(.subheadline)
                            
                            Divider()
                            
                            Text("\(character.name) Character Info")
                                .font(.title2)
                            Text("Born: \(character.birthday)")
                            
                            Divider()
                            
                            Text("Occupations:")
                            
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text("• \(occupation)")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            Text("Nicknames:")
                            
                            if character.aliases.isEmpty {
                                Text("None")
                                    .font(.subheadline)
                            } else {
                                ForEach(character.aliases, id: \.self) {alias in
                                    Text("• \(alias)")
                                        .font(.subheadline)
                                }
                            }
                            
                            Divider()
                            
                            DisclosureGroup("Status (spoiler alert!) :") {
                                VStack(alignment: .leading){
                                    Text(character.status)
                                        .font(.title2)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear {
                                                    withAnimation{
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        Text("How: \(death.details)")
                                            .padding(.bottom, 7)
                                        
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                }
                                .frame(width: geo.size.width / 1.3, alignment: .leading)
                            }
                            .tint(.primary)
                        }
                        .frame(width: geo.size.width / 1.25, alignment: .leading)
                        .padding(.bottom, 50)
                        .id(1)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .ignoresSafeArea()
        .task {
            currentQuote = character.quote?.quote
        }
    }
    
    private func fetchNewQuote() {
        guard !isFetchingQuote else { return }
        isFetchingQuote = true
        Task {
            await vm.fetchNewQuoteForCurrentCharacter()
            withAnimation(.easeInOut(duration: 0.25)) {
                currentQuote = vm.character.quote?.quote
            }
            isFetchingQuote = false
        }
    }
}

#Preview {
    CharacterView(vm: ViewModel(), character: ViewModel().character, show: Constants.bbName)
}
