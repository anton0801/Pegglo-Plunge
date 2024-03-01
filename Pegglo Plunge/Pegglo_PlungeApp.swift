//
//  Pegglo_PlungeApp.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.landscapeRight

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
}

@main
struct Pegglo_PlungeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LoadingGameView()
        }
    }
}
