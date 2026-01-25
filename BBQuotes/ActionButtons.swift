//
//  Buttons.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 09/11/25.
//

import SwiftUI

struct Buttons: View {
    
    @ObservedObject var vm: ViewModel
    let buttonsTitles = ["Get random quote", "Get random episode", "Get random character"]
    let show: String
    @Binding var quoteLoaded: Bool
    
    var body: some View {
        HStack(spacing: 10){
            ForEach(buttonsTitles, id: \.self) { title in
                Button {
                    Task {
                        switch title {
                        case "Get random quote":
                            await vm.getQuote(for: show)
                        case "Get random episode":
                            await vm.getEpisode(for: show)
                        case "Get random character":
                            await vm.getCharacter(from: show)
                        default:
                            break
                        }
                    }
                } label: {
                    Text(title)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(show.removeSpaces()+"Button"))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: Color(show.removeSpaces()+"Shadow"), radius: 2)
                }
                .disabled(quoteLoaded)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 6)
    }
}

#Preview {
    Buttons(show: "Breaking Bad")
}
