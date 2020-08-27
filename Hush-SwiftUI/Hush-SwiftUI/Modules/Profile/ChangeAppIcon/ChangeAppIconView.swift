//
//  ChangeAppIconView.swift
//  Hush-SwiftUI
//
//  Created by fulldev on 8/27/20.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI

struct ChangeAppIconView<ViewModel: ChangeAppIconModeled>: View {
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var app: App
    @Environment(\.presentationMode) var mode
    @State var selectedIconIndex: Int = 1
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Change Icon").font(.thin(48)).foregroundColor(.hOrange).padding(.top, ISiPhoneX ? 0 : 0).padding(.leading, 10)
                    HStack(alignment: .top) {
                        HapticButton(action: {
                            
                            self.mode.wrappedValue.dismiss()
                        }) {
                           HStack(spacing: 23) {
                               Image("onBack_icon")
                               Text("Back to My Profile").foregroundColor(.white).font(.thin())
                           }
                       }.padding(.leading, 10)
                       Spacer()
                    }
                }.padding([.horizontal])
                
                HStack(spacing: 0) {
                    AppIcon(icon: "Icon-1", index: 1)
                    AppIcon(icon: "Icon-2", index: 2)
                    AppIcon(icon: "Icon-3", index: 3)
                }
                HStack(spacing: 0) {
                    AppIcon(icon: "Icon-4", index: 4)
                    AppIcon(icon: "Icon-5", index: 5)
                    AppIcon(icon: "Icon-6", index: 6)
                }
                Spacer()
            }
        }
    }
    
    func AppIcon(icon: String, index: Int) -> some View {
        ZStack {
            
            Image(icon).frame(width: 100, height: 100)
            
            RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white, lineWidth: self.selectedIconIndex == index ? 4 : 1)
            .foregroundColor(.clear)
                .frame(width: 80, height: 80)
            
            
        }.onTapGesture {
            self.selectedIconIndex = index
            
            guard UIApplication.shared.supportsAlternateIcons else {
              return
            }
            
            UIApplication.shared.setAlternateIconName("Icon-2") { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Success!")
                }
            }
        }
    }
}

struct ChangeAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ChangeAppIconView(viewModel: ChangeAppIconModel()).withoutBar()
            }.previewDevice(.init(rawValue: "iPhone 8"))
            NavigationView {
                ChangeAppIconView(viewModel: ChangeAppIconModel()).withoutBar()
            }.previewDevice(.init(rawValue: "iPhone 11")).withoutBar()
        }
    }
}

