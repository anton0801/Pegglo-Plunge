//
//  ContentView.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var gameData = GameData()
    @EnvironmentObject var gameDataOptions: GameDataOptions
    
    @State private var rotation: Double = 0.0
    
    @State var showAboutInfoGameApp: Bool = false
    @State var showSettingsView: Bool = false
    @State var goToContactUsForm: Bool = false
    
    @State var isBackMusicOn = false {
        didSet {
            gameDataOptions.isGameMusicOn = isBackMusicOn
            UserDefaults.standard.set(isBackMusicOn, forKey: "is_music_enabled")
            print("Didset isBackMusicOn \(isBackMusicOn)")
        }
    }
    @State var isSoundsOn = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                if showAboutInfoGameApp {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    showAboutInfoGameApp = false
                                }
                            } label: {
                                Image("close")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                            }
                        }
                        VStack {
                            Text("About App")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                            ScrollView {
                                Text("In this game you need to roll balls into the green holes to score points and earn the opportunity to have more balls in the game. At the beginning of the game you have 10 balls and to start dropping balls you need to put at least 5 obstacles, for each knocked down obstacle you will get +1 extra point, and on earned points you can buy other skins on the ball and also buy new locations of the game.")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.white)
                        )
                        .shadow(radius: 10)
                    }
                    .frame(maxWidth: 400, maxHeight: 300)
                    Spacer()
                } else if showSettingsView {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    showSettingsView = false
                                }
                            } label: {
                                Image("close")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                            }
                        }
                        VStack {
                            Text("Settings")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                            
                            HStack {
                                Text("Background music")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Spacer()
                                
                                Toggle(isOn: $isBackMusicOn, label: {
                                    
                                })
                                .onChange(of: isBackMusicOn) { value in
                                    gameDataOptions.isGameMusicOn = isBackMusicOn
                                    UserDefaults.standard.set(isBackMusicOn, forKey: "is_music_enabled")
                                }
                            }
                            .padding(.top, 6)
                            
                            HStack {
                                Text("Sounds effects")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Spacer()
                                
                                Toggle(isOn: $isSoundsOn, label: {
                                    
                                })
                                .onChange(of: isSoundsOn) { value in
                                    gameDataOptions.isGameSoundEffectsOn = isSoundsOn
                                    UserDefaults.standard.set(isSoundsOn, forKey: "is_sounds_enabled")
                                }
                            }
                            .padding(.top, 6)
                            
                            Button {
                                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                               AppDelegate.orientationLock = .portrait
                                goToContactUsForm = true
                            } label: {
                                Text("Contact Us")
                                    .underline()
                                    .font(.system(size: 18, weight: .medium))
                                    .padding(.top, 6)
                            }
                            
                            NavigationLink(destination: ContactFormGameView().navigationBarBackButtonHidden(true), isActive: $goToContactUsForm) {
                                EmptyView()
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.white)
                        )
                        .shadow(radius: 10)
                    }
                    .frame(maxWidth: 400, maxHeight: 300)
                    Spacer()
                } else {
                    HStack {
                        Button {
                            withAnimation {
                                showSettingsView = true
                            }
                        } label: {
                            Image("settings")
                                .resizable()
                                .frame(width: 82, height: 82)
                        }
                        
                        Spacer()
                        Button {
                            let text = "Check out this awesome app!"
                            let url = URL(string: "https://apps.apple.com/es/app/microsoft-word/id462054704")!
                            let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
                                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                        } label: {
                            Image("share")
                                .resizable()
                                .frame(width: 82, height: 82)
                        }
                        Spacer().frame(width: 12)
                        Button {
                            withAnimation {
                                showAboutInfoGameApp = true
                            }
                        } label: {
                            Image("app_info")
                                .resizable()
                                .frame(width: 82, height: 82)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    NavigationLink(destination: PeggloGameView()
                        .environmentObject(gameData)
                        .navigationBarBackButtonHidden(true)) {
                        ZStack {
                            Image("bouncer")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(rotation))
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                                        self.rotation = 360.0
                                    }
                                }
                            
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 52, height: 52)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: BallsAndWallpapersStoreView()
                            .environmentObject(gameData)
                            .environmentObject(gameDataOptions)
                            .navigationBarBackButtonHidden(true)) {
                            ZStack {
                                Image("btn_bg")
                                    .resizable()
                                    .frame(width: 84, height: 84)
                                
                                Image(systemName: "cart")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                Spacer()
                
                
            }
            .background(
                Image(gameDataOptions.gameBackground)
                    .opacity(6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "first_configuration_setup") {
                    setUpFirstConfiguration()
                    gameData.buyBall(price: 0, name: "ball")
                    gameData.buyField(price: 0, name: "base_game_back")
                } else {
                    isBackMusicOn = gameDataOptions.isGameMusicOn
                    isSoundsOn = gameDataOptions.isGameSoundEffectsOn
                }
                
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
               AppDelegate.orientationLock = .landscape
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
    
    private func setUpFirstConfiguration() {
        isBackMusicOn = true
        isSoundsOn = true
        UserDefaults.standard.set(true, forKey: "is_music_enabled")
        UserDefaults.standard.set(true, forKey: "is_sounds_enabled")
        gameDataOptions.isGameMusicOn = true
        gameDataOptions.isGameSoundEffectsOn = true
        UserDefaults.standard.set(true, forKey: "first_configuration_setup")
    }
    
}


struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}

    typealias UIViewControllerType = UIActivityViewController

    class Coordinator: NSObject {
        var parent: ShareSheet

        init(_ parent: ShareSheet) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


#Preview {
    ContentView()
        .environmentObject(GameDataOptions())
}
