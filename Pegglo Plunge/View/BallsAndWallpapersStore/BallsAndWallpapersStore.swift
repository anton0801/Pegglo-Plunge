//
//  BallsAndWallpapersStore.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI

struct BallsAndWallpapersStoreView: View {
    
    @EnvironmentObject var gameDataOptions: GameDataOptions
    @EnvironmentObject var gameData: GameData
    
    @Environment(\.presentationMode) var presMode
    
    @State var selectedType = "balls"
    
    @State var storeItems: [StoreItem] = []
    
    @State var buyStoreItemResultShowAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("close")
                        .resizable()
                        .frame(width: 62, height: 62)
                }
                Spacer()
                Text("Store")
                    .font(.custom("Chalkduster", size: 42))
                    .foregroundColor(.white)
                Spacer()
                
                HStack {
                    ZStack {
                        Image("btn_bg")
                            .resizable()
                            .frame(width: 52, height: 52)
                        
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    
                    Text("\(gameData.score)")
                        .font(.custom("Chalkduster", size: 24))
                        .foregroundColor(.white)
                }
            }
            .padding(.top)
            
            HStack {
                if selectedType == "balls" {
                    Text("Balls")
                        .padding(EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12))
                        .foregroundColor(.white)
                        .font(.custom("Chalkduster", size: 24))
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.orange)
                            
                        )
                } else {
                    Button {
                        selectedType = "balls"
                        storeItems = storeData.filter { $0.type == .ball }
                    } label: {
                        Text("Balls")
                            .padding(EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12))
                            .foregroundColor(.white)
                            .font(.custom("Chalkduster", size: 24))
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.purple)
                            )
                    }
                }
                
                Spacer().frame(width: 12)
                
                if selectedType == "fields" {
                    Text("Game fields")
                        .padding(EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12))
                        .foregroundColor(.white)
                        .font(.custom("Chalkduster", size: 24))
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.orange)
                        )
                } else {
                    Button {
                        selectedType = "fields"
                        storeItems = storeData.filter { $0.type == .wallpaper }
                    } label: {
                        Text("Game fields")
                            .padding(EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12))
                            .foregroundColor(.white)
                            .font(.custom("Chalkduster", size: 24))
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.purple)
                            )
                    }
                }
                
                
            }
            Spacer()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(storeItems, id: \.id) { storeItem in
                        VStack {
                            ZStack {
                                if storeItem.type == .ball {
                                    Button {
                                        if gameData.buyiedBalls.contains(where: { $0 == storeItem.src }) {
                                            gameDataOptions.gameBall = storeItem.src
                                        }
                                    } label: {
                                        Image(storeItem.src)
                                            .resizable()
                                            .frame(width: 82, height: 82)
                                    }
                                    if !gameData.buyiedBalls.contains(where: { $0 == storeItem.src }) {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 52, height: 52)
                                            
                                            Image(systemName: "lock.fill")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 52, height: 52)
                                        .offset(x: 30, y: -30)
                                    }
                                    
                                    if gameDataOptions.gameBall == storeItem.src {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 52, height: 52)
                                            
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 52, height: 52)
                                        .offset(x: 30, y: -30)
                                    }
                                } else {
                                    Button {
                                        if gameData.buyiedGameFields.contains(where: { $0 == storeItem.src }) {
                                            gameDataOptions.gameBackground = storeItem.src
                                        }
                                    } label: {
                                        Image(storeItem.src)
                                            .resizable()
                                            .frame(width: 200, height: 120)
                                            .scaledToFill()
                                            .cornerRadius(12)
                                    }
                                    if !gameData.buyiedGameFields.contains(where: { $0 == storeItem.src }) {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 52, height: 52)
                                            
                                            Image(systemName: "lock.fill")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.white)
                                        }
                                        .offset(x: 90, y: -50)
                                    }
                                    
                                    if gameDataOptions.gameBackground == storeItem.src {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 52, height: 52)
                                            
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 52, height: 52)
                                        .offset(x: 90, y: -50)
                                    }
                                }
                            }
                            
                            let arrayConcatenated = gameData.buyiedBalls + gameData.buyiedGameFields
                            if !arrayConcatenated.contains(where: { $0 == storeItem.src }) {
                                HStack {
                                    Button {
                                        if storeItem.type == .ball {
                                            buyStoreItemResultShowAlert = !(gameData.buyBall(price: storeItem.price, name: storeItem.src))
                                        } else {
                                            buyStoreItemResultShowAlert = !(gameData.buyField(price: storeItem.price, name: storeItem.src))
                                        }
                                    } label: {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 52, height: 52)
                                            
                                            Image(systemName: "dollarsign.circle")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    Text("Buy: \(storeItem.price)")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                .onAppear {
                                    print("Store items \(arrayConcatenated) storeItem \(storeItem)")
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.white)
                        )
                        .shadow(radius: 10)
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
            storeItems = storeData.filter { $0.type == .ball }
        }
        .alert(isPresented: $buyStoreItemResultShowAlert) {
            Alert(
                title: Text("Error!"),
                message: Text("You don't have enough points earned to buy this item!"),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
}

#Preview {
    BallsAndWallpapersStoreView()
        .environmentObject(GameDataOptions())
        .environmentObject(GameData())
}
