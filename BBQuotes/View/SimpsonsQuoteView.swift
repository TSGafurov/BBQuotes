//
//  SimpsonsQuoteView.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 11/11/25.
//

import SwiftUI

struct SimpsonsQuoteView: View {
    
    let vm = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if let quote = vm.simpson.phrases.randomElement() {
                    Text("\"\(quote)\"")
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal)
                }
                
                ZStack(alignment: .bottom) {
                    if let url = vm.simpson.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Text("No image available")
                    }
                    
                    Text(vm.simpson.name)
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                }
                .frame(width: geo.size.width / 1.1 , height: geo.size.height / 1.8)
                .clipShape(RoundedRectangle(cornerRadius: 50))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .task {
            await vm.getSimpson()
        }
    }
}

#Preview {
    SimpsonsQuoteView()
        .preferredColorScheme(.dark)
}
