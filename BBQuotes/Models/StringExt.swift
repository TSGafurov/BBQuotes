//
//  StringExt.swift
//  BBQuotes
//
//  Created by Timur Gafurov on 07/11/25.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.lowercased().removeSpaces()
    }
}
