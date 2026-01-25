//
//  Death.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 04/11/25.
//

import Foundation

struct Death: Decodable {
    let character: String
    let image: URL
    let details: String
    let lastWords: String
}
