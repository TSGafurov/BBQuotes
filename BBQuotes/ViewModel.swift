//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 05/11/25.
//

import Foundation

@Observable
@MainActor
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case successCharacter
        case failed(error: Error)
    }
    
    let fetcher = FetchService()
    var status: FetchStatus = .notStarted
    
    var quote: Quote
    var character: Char
    var episode: Episode
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Char.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    func getQuote(for show: String) async {
        status = .fetching
        
        do {
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(from: character.name)
                        
            character.quote = try await fetcher.fetchRandomQuoteFromCharacter(from: character.name)
            
            status = .successQuote
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getEpisode(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
            }
            status = .successEpisode
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getCharacter(from show: String) async {
        status = .fetching
        
        do {
            if let unwrappedCharacter = try await fetcher.fetchRandomCharacter(from: show) {
                character = unwrappedCharacter
                character.death = try await fetcher.fetchDeath(from: character.name)
            }
            status = .successCharacter
        } catch {
            status = .failed(error: error)
        }
    }
    
    func fetchNewQuoteForCurrentCharacter() async {
        do {
            let newQuote = try await fetcher.fetchRandomQuoteFromCharacter(from: character.name)
            character.quote = newQuote
        } catch {
            print("Failed to fetch quote for current character: \(error)")
        }
    }
}

