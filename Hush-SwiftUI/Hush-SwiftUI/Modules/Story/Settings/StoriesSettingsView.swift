//
//  StoriesSettingsView.swift
//  Hush-SwiftUI
//
//  Created by Serge Vysotsky on 12.05.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI
import PartialSheet

struct StoriesSettingsView<ViewModel: StoriesSettingsViewModeled>: View {
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject private var app: App
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    @EnvironmentObject private var modalPresenterManager: ModalPresenterManager
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Filter").font(.bold(24)).foregroundColor(Color(0x010101))
                Spacer()
            }.padding(.bottom, 40)
            VStack {
                HStack {
                    Text("Search").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                    Button(action: {
                        self.partialSheetManager.showPartialSheet({
                            self.app.isFirstResponder = false
                        }, content: {
                            TextQuerySelectorView(provider: UsernamesAPI { username in
                                self.viewModel.username = username ?? "Username"
                                self.viewModel.closeAPISelectorCompletion?()
                            })
                        })
                    }) {
                        Text(viewModel.username).font(.light()).foregroundColor(Color(0x8E8786))
                    }
                    Spacer()
                    Text("Edit").font(.light()).hidden()
                }
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }
            VStack {
                HStack {
                    Text("Location").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                    Text("Los Angeles").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                    Button(action: {
                        self.partialSheetManager.showPartialSheet({
                            self.app.isFirstResponder = false
                        }, content: {
                            TextQuerySelectorView(provider: SelectLocationAPI { newLocation in
                                if let result = newLocation {
                                    self.viewModel.location = result
                                }
                                
                                self.viewModel.closeAPISelectorCompletion?()
                            })
                        })
                    }) {
                        Text("Edit").font(.light()).foregroundColor(Color(0x8E8786))
                    }
                }
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }
            VStack {
                HStack {
                    Text("Show Me").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                    Text(viewModel.genderDescription).font(.light()).foregroundColor(Color(0x010101)).animation(nil)
                    Spacer()
                    Button(action: selectGender) {
                        Text("Edit").font(.light()).foregroundColor(Color(0x8E8786))
                    }
                }
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }
            VStack {
                HStack {
                    Text("Maximum distance").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                    Text(viewModel.maxDistanceDescription)
                        .font(.light())
                        .foregroundColor(Color(0x010101))
                }.animation(nil)
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }
            VStack {
                SingleSlider(value: $viewModel.maxDistance)
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }.animation(nil)
            VStack {
                HStack {
                    Text("Age range").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                }
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }
            VStack {
                ZStack {
                    HStack {
                        Text(viewModel.ageMinDescription)
                        Spacer()
                        Text(viewModel.ageMaxDescription)
                    }
                    
                    HStack {
                        Text("99").opacity(0)
                        DoubleSlider(lower: $viewModel.ageMin, upper: $viewModel.ageMax)
                        Text("99").opacity(0)
                    }
                }.font(.light(18)).animation(nil)
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }
            VStack {
                HStack {
                    Text("Online users").font(.light()).foregroundColor(Color(0x010101))
                    Spacer()
                    Toggle("", isOn: $viewModel.onlineUsers)
                }
                Rectangle().foregroundColor(Color(0xC6C6C8)).frame(height: 0.5)
            }.padding(.top, 20)
        }.padding(.horizontal, 20)
        .fixedSize(horizontal: false, vertical: true)
        .withoutBar()
    }
    
    private func selectGender() {
        let alert = TextAlert(style: .actionSheet, title: nil, message: nil, actions: Gender.allCases.map { gender in
            UIAlertAction(title: gender.title, style: .default, handler: { _ in self.viewModel.gender = gender })
        } + [UIAlertAction(title: "Cancel", style: .cancel)])
        modalPresenterManager.present(controller: UIAlertController(alert: alert))
    }
}

struct StoriesSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        StoriesSettingsView(viewModel: StoriesSettingsViewModel())
    }
}