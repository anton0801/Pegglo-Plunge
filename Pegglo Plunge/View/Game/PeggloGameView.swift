//
//  PeggloGameView.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI
import SpriteKit

struct PeggloGameView: View {
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PeggloGameView()
}
