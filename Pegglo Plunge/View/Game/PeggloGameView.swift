//
//  PeggloGameView.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI
import SpriteKit

struct PeggloGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var gameData: GameData
    
    @State var gameIdScoreAdded: String? = nil
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CLOSE_GAME"))) { _ in
                presMode.wrappedValue.dismiss()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("WIN_ADD_POINTS"))) { notification in
                if let data = notification.userInfo?["data"] as? Int {
                    if let gameId = notification.userInfo?["gameId"] as? String {
                        if gameId != gameIdScoreAdded {
                            gameData.addScore(data)
                            self.gameIdScoreAdded = gameId
                        }
                    }
                }
            }
    }
    
}

#Preview {
    PeggloGameView()
}
