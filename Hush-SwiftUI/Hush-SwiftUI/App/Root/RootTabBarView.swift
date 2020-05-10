//
//  RootTabBarView.swift
//  Hush-SwiftUI
//
//  Created Dima Virych on 02.04.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI
import PartialSheet

struct RootTabBarView<ViewModel: RootTabBarViewModeled>: View, HeaderedScreen {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var app: App
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @State var currentTab = 0//2
    
    init(viewModel model: ViewModel) {
        viewModel = model
        UITabBar.appearance().barTintColor = .black
    }
    
    
    // MARK: - Lifecycle
    
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: self.$currentTab) {
                self.discovery().tabItem {
                    
                    Image("discoverySelected").resizable().frame(width: 38, height: 38)
                    Text("")
                }.tag(0)
                self.stories().tabItem {
                    
                    Image("bookmarks").resizable().frame(width: 38, height: 38)
                    Text("")
                }.tag(1)
                self.photoBoth().tabItem {
                    
                    Image("cards").resizable().frame(width: 38, height: 38)
                    Text("")
                }.tag(2)
                MessagesView(viewModel: MessagesViewModel()).withoutBar().tabItem {
                    
                    Image("messages").resizable().frame(width: 38, height: 38)
                    Text("")
                }.tag(3)
                MyProfileView(viewModel: self.app.profile).withoutBar().tabItem {
                    
                    Image("user-circle").resizable().frame(width: 38, height: 38)
                    Text("")
                }.tag(4)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .accentColor(.hOrange)
            .sheet(isPresented: self.$app.showPremium) {
                UpgradeView(viewModel: UpgradeViewModel())
            }
        }
    }
    
    func photoBoth() -> some View {
        HeaderedView(header: {
            VStack(alignment: .leading, spacing: 0) {
                Text("Photo").foregroundColor(.hOrange).font(.bold(48))
                +
                Text("Booth").foregroundColor(.white).font(.ultraLight(48))
            }
        }, content: {
            CardCuraselView(viewModel: CardCuraselViewModel())
        })
    }
    
    func stories() -> some View {
        
        HeaderedView(header: {
            VStack(alignment: .leading, spacing: 0) {
                Text("Stories").foregroundColor(.hOrange).font(.ultraLight(48)).padding(.leading, 30)
                Text("Profiles Nearby").foregroundColor(.white).font(.thin()).padding(.leading, 30)
            }
        }, content: {
            StoriesView(viewModel: StoriesViewModel())
        })
    }
    
    func discovery() -> some View {
        
        HeaderedView(header: {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Discovery").foregroundColor(.hOrange).font(.ultraLight(48)).padding(.leading, 30)
                    Text("Location").foregroundColor(.white).font(.thin()).padding(.leading, 30)
                }
                Spacer()
                HapticButton(action: self.showSettings) {
                    Image("settings_icon").resizable().frame(width: 25, height: 25).padding(30)
                }
            }
        }, content: {
            DiscoveryView(viewModel:  self.app.discovery)
        }).padding(.top, 0)
        .addPartialSheet()
        .withoutBar()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $app.selectingGender, TextAlert(style: .actionSheet, title: nil, message: nil, actions: Gender.allCases.map { gender in
            UIAlertAction(toggling: $app.selectingGender, title: gender.title, style: .default) { _ in
                self.app.discovery.settingsViewModel.gender = gender
            }
        } + [UIAlertAction(toggling: $app.selectingGender, title: "Cancel", style: .cancel)]))
        .onAppear {
            self.app.discovery.settingsViewModel.selectLocationCompletion = self.showSettings
        }
    }
    
    func showSettings() {
        partialSheetManager.showPartialSheet {
            SettingsView(viewModel: self.app.discovery.settingsViewModel)
        }
    }
}

struct RootTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RootTabBarView(viewModel: RootTabBarViewModel())
        }.environmentObject(App())
        .environmentObject(PartialSheetManager())
//        Group {
//            NavigationView {
//                RootTabBarView(viewModel: RootTabBarViewModel())
//            }.previewDevice(.init(rawValue: "iPhone SE"))
//            NavigationView {
//                RootTabBarView(viewModel: RootTabBarViewModel())
//            }.previewDevice(.init(rawValue: "iPhone 8"))
//            NavigationView {
//                RootTabBarView(viewModel: RootTabBarViewModel())
//            }.previewDevice(.init(rawValue: "iPhone XS Max"))
//        }
    }
}
