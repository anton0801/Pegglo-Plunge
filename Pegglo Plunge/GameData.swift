//
//  GameData.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import Foundation

class GameData: ObservableObject {
    
    @Published var buyiedBalls: [String] = []
    @Published var buyiedGameFields: [String] = []
    @Published var score: Int = UserDefaults.standard.integer(forKey: "score")
    
    init() {
        let ballsSaved = UserDefaults.standard.string(forKey: "balls_buyied") ?? ""
        let ballComponents = ballsSaved.components(separatedBy: ",")
        for ball in ballComponents {
            buyiedBalls.append(ball)
        }
        
        let fieldsSaved = UserDefaults.standard.string(forKey: "fields_buyied") ?? ""
        let fieldsComponents = fieldsSaved.components(separatedBy: ",")
        for field in fieldsComponents {
            buyiedGameFields.append(field)
        }
        
        print("Data balls \(buyiedBalls)")
        print("Data fields \(buyiedGameFields)")
    }
    
    func addScore(_ score: Int) {
        self.score += score
        UserDefaults.standard.set(self.score, forKey: "score")
    }
    
    func buyBall(price: Int, name: String) -> Bool {
        if score >= price {
            let ballsSaved = UserDefaults.standard.string(forKey: "balls_buyied") ?? ""
            var ballComponents = ballsSaved.components(separatedBy: ",")
            ballComponents.append(name)
            score -= price
            UserDefaults.standard.set(score, forKey: "score")
            UserDefaults.standard.set(ballComponents.joined(separator: ","), forKey: "balls_buyied")
            
            for ball in ballComponents {
                buyiedBalls.append(ball)
            }
            
            return true
        }
        return false
    }
    
    func buyField(price: Int, name: String) -> Bool {
        if score >= price {
            let fieldsSaved = UserDefaults.standard.string(forKey: "fields_buyied") ?? ""
            var fieldsComponents = fieldsSaved.components(separatedBy: ",")
            fieldsComponents.append(name)
            score -= price
            UserDefaults.standard.set(score, forKey: "score")
            UserDefaults.standard.set(fieldsComponents.joined(separator: ","), forKey: "fields_buyied")
            
            for field in fieldsComponents {
                buyiedGameFields.append(field)
            }
            
            return true
        }
        return false
    }
    
}
