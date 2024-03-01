//
//  LoadingGameView.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI

struct LoadingGameView: View {
    
    @StateObject var gameDataOptions = GameDataOptions()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var loadingTime = 0
    @State var loadingFinish = false
    
    @State private var rotation: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Image("ball")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                            self.rotation = 360.0
                        }
                    }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("LOADING...")
                        .font(.custom("Chalkduster", size: 42))
                        .foregroundColor(.white)
                }
                
                NavigationLink(destination: ContentView()
                    .environmentObject(gameDataOptions)
                    .navigationBarBackButtonHidden(true), isActive: $loadingFinish) {
                    EmptyView()
                }
            }
            .background(
                Image(gameDataOptions.gameBackground)
                    .opacity(6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
               AppDelegate.orientationLock = .landscape
            }
            .onReceive(timer) { time in
                loadingTime += 1
                if loadingTime == 3 {
                    loadingFinish = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
}

#Preview {
    LoadingGameView()
}
