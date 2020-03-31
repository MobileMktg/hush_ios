//
//  LoginButtons.swift
//  Hush-SwiftUI
//
//  Created by Dima Virych on 30.03.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI

struct LoginButtons<Presenter: SignUpViewPresenter>: View {
    
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        VStack(spacing: 14) {
            LoginButton(title: "Sign Up with Email", img: Image("mail_icon"), color: Color(0x56CCF2)) {
                self.presenter.emailPressed()
            }.padding(.horizontal, 24)
            LoginButton(title: "Connect with Google", img: Image("google_icon"), color: Color(0xFB4949)) {
                self.presenter.googlePressed()
            }.padding(.horizontal, 24)
            LoginButton(title: "Connect with Facebook", img: Image("facebook_icon"), color: Color(0x2672CB)) {
                self.presenter.facebookPressed()
            }.padding(.horizontal, 24)
            LoginButton(title: "Sign in with Apple", titleColor: .black, img: Image("apple_icon"), color: Color(0xFFFFFF)) {
                self.presenter.applePressed()
            }.padding(.horizontal, 24)
            LoginButton(title: "Continue with Snapchat", titleColor: .black, img: Image("snap_icon"), color: Color(0xFFFC01)) {
                self.presenter.snapPressed()
            }.padding(.horizontal, 24)
        }
    }
}

struct LoginButton: View {
    
    let title: String
    var titleColor: Color = .white
    let img: Image
    let color: Color
    let action: () -> Void
    
    var body: some View {
        HapticButton(action: action) {
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 48)
                    .cornerRadius(6)
                    .foregroundColor(color)
                HStack {
                    img
                        .resizable()
                        .foregroundColor(titleColor)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                    Text(title)
                        .font(.medium(20))
                        .foregroundColor(titleColor)
                }.padding(.leading, 50)
            }
        }
    }
}