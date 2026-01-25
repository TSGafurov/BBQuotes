//
//  FetchView.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 04/11/25.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    @State var showCharacterInfo = false
    @State var showEpisode = false
    @State var isLoading = true
    
    @State private var quoteCounter = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                    .onAppear{
                        Task{
                            await vm.getQuote(for: show)
                            isLoading = false
                        }
                    }
                VStack{
                    VStack{
                        Spacer(minLength: 60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            ZStack(alignment: .bottom ){
                                TabView {
                                    AsyncImage(url: vm.character.images.randomElement()) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .tabViewStyle(.page)
                                
                                
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                                
                                
                                Text(vm.character.name)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            
                            
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                            
                        case .successCharacter:
                            RandomCharacterView(character: vm.character, show: show)
                                .background(.black.opacity(0.5))
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.5)
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.top, 20)
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                            
                        }
                        Spacer(minLength: 20)
                    }
                    
                    ActionButtons(show: show, isLoading: isLoading) { action in
                        Task {
                            switch action {
                            case .quote:
                                await vm.getQuote(for: show)
                            case .episode:
                                await vm.getEpisode(for: show)
                            case .character:
                                await vm.getCharacter(from: show)
                            }
                        }
                    }
                    Spacer(minLength: 95)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(vm: vm, character: vm.character, show: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
