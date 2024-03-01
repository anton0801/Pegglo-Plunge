//
//  PrivacyPolicyGameView.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import SwiftUI
import WebKit

struct ContactFormGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var contact = "https://forms.gle/HKsxQYECTqe99Zwe6"
    
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
                Text("Contact Form")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
            }
            if let url = URL(string: contact) {
                ContactUsView(url: url)
            }
        }
        .onAppear {
            
        }
        .onDisappear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
           AppDelegate.orientationLock = .landscapeRight
        }
    }
}

struct ContactUsView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    ContactFormGameView()
}
