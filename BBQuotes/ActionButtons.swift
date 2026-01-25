//
//  Buttons.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 09/11/25.
//

import SwiftUI

struct ActionButtons: View {
    let show: String
    let isLoading: Bool
    let onAction: (ActionType) -> Void
    
    enum ActionType {
        case quote, episode, character
    }
    
    var body: some View {
        HStack(spacing: 10) {
            button("Get random quote", action: .quote)
            button("Get random episode", action: .episode)
            button("Get random character", action: .character)
        }
        .padding(.horizontal)
    }
    
    private func button(_ title: String, action: ActionType) -> some View {
        Button(title) {
            onAction(action)
        }
        .font(.title3)
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(show.removeSpaces() + "Button"))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: Color(show.removeSpaces() + "Shadow"), radius: 2)
        .disabled(isLoading)
    }
}

#Preview {
    ActionButtons(show: "Breaking Bad", isLoading: false) { action in
        switch action {
        case .quote:
            print("Get random quote tapped")
        case .episode:
            print("Get random episode tapped")
        case .character:
            print("Get random character tapped")
        }
    }
    .preferredColorScheme(.dark)
    .padding()
    .background(.black)
}
