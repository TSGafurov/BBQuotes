//
//  Simpsons.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 11/11/25.
//

import Foundation

struct Simpsons: Decodable {
    let id: Int
    let age: Int?
    let birthdate: String?
    let name: String
    let occupation: String?
    let portraitPath: String
    let phrases: [String]
    let status: String
    
    var imageURL: URL? {
            let path = portraitPath.starts(with: "/") ? portraitPath : "/" + portraitPath
            return URL(string: "https://cdn.thesimpsonsapi.com/1280\(path)")
        }
}
