//
//  ScoreGame.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import Foundation

protocol Scorable {
    var score: Int { get set }
}

struct ScoreGame: Scorable {
    var score: Int
}
