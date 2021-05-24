//
//  StringExtension.swift
//  Pokedex
//
//  Created by Josafat Flores on 23/05/21.
//

import Foundation

extension String {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
