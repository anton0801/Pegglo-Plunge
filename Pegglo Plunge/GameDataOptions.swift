//
//  GameDataOptions.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI

class GameDataOptions: ObservableObject {
    @Published var gameBackground: String = UserDefaults.standard.string(forKey: "game_back") ?? "base_game_back" {
        didSet {
            UserDefaults.standard.set(gameBackground, forKey: "game_back")
        }
    }
    @Published var gameBall: String = UserDefaults.standard.string(forKey: "game_ball") ?? "ball" {
        didSet {
            UserDefaults.standard.set(gameBall, forKey: "game_ball")
        }
    }
    
    @Published var isGameMusicOn: Bool = UserDefaults.standard.bool(forKey: "is_music_enabled")
    @Published var isGameSoundEffectsOn: Bool = UserDefaults.standard.bool(forKey: "is_sounds_enabled")
    
    static var shared: GameDataOptions = GameDataOptions()
}
