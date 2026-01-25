//
//  SimpsonsView.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 11/11/25.
//

import SwiftUI

struct SimpsonsQuoteView: View {
    
    let vm = ViewModel()
    
    var body: some View {
        Text(vm.simpson.phrases.randomElement() ?? "No quote")
    }
}

#Preview {
    SimpsonsView()
}
