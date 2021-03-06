//
//  CardCaruselView.swift
//  Hush-SwiftUI
//
//  Created Dima Virych on 03.04.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI

struct CardCaruselView<ViewModel: CardCuraselViewModeled>: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel
    
    @GestureState private var opacity: Double = 0
    @GestureState private var degrees: Double = 0
    @State private var translation: CGSize = .zero
    @State private var cardIndex = 0
    @State private var shouldLike = false
    @State private var shouldClose = false
    @State private var shouldAnimate = false
    @State private var overlay_opacity: Double = 0
    @State private var overlay_icon_opacity: Double = 0
    @State var showUserProfile = false
    @State var isShowing: Bool = false

    private var degreeIndex = 0
    private var showClose: Bool { translation.width < 0 }
    private var showHeart: Bool { translation.width > 0 }
    
    init(viewModel: ViewModel, showingSetting: Bool) {
        self.viewModel = viewModel

        if !showingSetting {
            self.viewModel.loadGame { (result) in
                
            }
        }
    }
    
    func gotoUserProfilePage(userID: String) {
        AuthAPI.shared.cuser(userId: userID) { (user, error) in
            if error == nil {
                if let user = user {
                    self.viewModel.selectedUser = user
                    self.viewModel.showUserProfile = true
                }
            }
        }
    }

    private func movePercent(_ translation: CGSize) -> CGFloat {
        translation.width / (SCREEN_WIDTH / 3)
    }
    
    private var topCardDrag: some Gesture {
        DragGesture().onChanged { value in
            withAnimation(.linear) {
                self.translation = value.translation
                self.overlay_icon_opacity = 1
            }
        }.onEnded { value in
            self.overlay_icon_opacity = 0
            
            let percent = self.movePercent(value.translation)
            if -1 <= percent && percent <= 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    withAnimation(.default) {
                        self.translation = .zero
                        self.overlay_opacity = 0.0
                    }
                }
            } else {
                if percent > 1 {
                    self.animateLike(like: true)
                } else if percent < -1 {
                    self.animateLike(like: false)
                }
            }
        }.updating($opacity) { value, opacity, _ in
            withAnimation(.linear) {
                //self.overlay_opacity = abs(Double(self.movePercent(value.translation))) * 0.4
            }
        }
//        .updating($degrees) { value, degrees, _ in
//            let percent = self.movePercent(value.translation)
//            degrees = 15 * Double(percent)
//        }
    }
    
    private func offset(_ card: Int) -> CGFloat {
        -10 * CGFloat((card - cardIndex) % 3)
    }
    
    private func flyAwayOffset(_ index: Int) -> CGFloat {
        var result: CGFloat = 0
        if shouldLike && index == self.getLastIndex(cardIndex) - 1 {
            result = SCREEN_WIDTH
        } else if shouldClose && index == self.getLastIndex(cardIndex) - 1 {
            result = -SCREEN_WIDTH
        }

        return result
    }
    
    private func animateLike(like: Bool) {

        if (like) {
            withAnimation(.default) {
                let size:CGSize = self.translation
                self.translation = CGSize(width: size.width + SCREEN_WIDTH, height: size.height + 100)
                self.overlay_opacity = 1.0
            }
        } else {
            withAnimation(.default) {
                let size:CGSize = self.translation
                self.translation = CGSize(width: size.width - SCREEN_WIDTH, height: size.height + 100)
                self.overlay_opacity = 1.0
            }
        }
        
        let index = self.getLastIndex(self.cardIndex) - 1
        let user_index = (2 * self.cardIndex - index + 3) % self.viewModel.games.count
        let user = self.viewModel.games[user_index]
        
        if like {
            self.viewModel.userMatch(userID: user.id ?? "0")
        } else {
            self.viewModel.userDislike(userID: user.id ?? "0")
        }

        var reload = false
        if (self.cardIndex == self.viewModel.games.count - 1) {
            self.viewModel.games.removeAll()
            reload = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.translation = .zero
            withAnimation(.default) {
                self.cardIndex += 1
                self.overlay_opacity = 0.0
                
                if (reload == true) {
                    self.viewModel.isShowingIndicator = true
                    self.viewModel.loadGame { (result) in
                        self.viewModel.isShowingIndicator = false
                        if (result) {
                            self.cardIndex = 0
                        }
                    }
                }
            }
        }
    }
        
    // MARK: - Lifecycle
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                    
                ZStack {
                    if (viewModel.games.count > 0) {
                        ForEach((cardIndex..<self.getLastIndex(cardIndex)), id: \.self) { index in
                            self.caruselElement(index)
                        }
                    }

                }.frame(width: SCREEN_WIDTH)
                .padding(.bottom, ISiPhoneX ? 30 : 0)
                .padding(.top, ISiPhoneX ? 35 : 35)
                
                Spacer()

            }.overlay(overlay)
            .overlay(overlay_icon)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.shouldAnimate = true
                }
            }
            HushIndicator(showing: self.viewModel.isShowingIndicator).padding(.top, -20)

        }.background(
            NavigationLink(destination: UserProfileView(viewModel: UserProfileViewModel(user: viewModel.selectedUser))
               .withoutBar(), isActive: self.$viewModel.showUserProfile) {
                   Spacer()
               }.buttonStyle(PlainButtonStyle())
        ).padding(.top, ISiPhoneX ? -30 : -35)
    }
    
    private func getDegree(_ index: Int ) -> Double {
        var degree:Double = -5

        switch( (index - cardIndex) % 4) {
            case 0:
                degree = -10
                break
            case 1:
                degree = 10
                break
            case 2:
                if cardIndex % 2 == 0 {
                    degree = -5
                } else {
                    degree = 5
                }
                break
            case 3:
                if cardIndex % 2 == 0 {
                    degree = 5
                } else {
                    degree = -5
                }
                break
            default:
                degree = -5
                break
        }
        
        return degree
    }
    
    private func getLastIndex(_ index: Int) -> Int {
        let retIndex = index + (viewModel.games.count > 3 ? 4 : viewModel.games.count)
        return retIndex
   }
    
    private func getOffset(_ index: Int) -> CGFloat {
        var offset:CGFloat = 0;
        let offIndex: Int = (index - cardIndex) % 4
        
        switch(offIndex) {
        case 0:
            offset = 0
            break
        case 1:
            offset = 3
            break
        case 2:
            offset = 6
            break
        case 3:
            offset = 9
            break
        default:
            offset = 0
        }
        
        return offset
    }
    
    private func caruselElement(_ index: Int) -> some View {
          
        CardCaruselElementView(rotation: .degrees(
                                //index.isMultiple(of: 2) ? -5 : 5),
                                    self.getDegree(index)),
                               user: viewModel.games[(2 * self.cardIndex - index + 3) % viewModel.games.count], showIndicator: $viewModel.isShowingIndicator)
        {
//            self.viewModel.loadGame { (result) in
//                
//            }
        }
        .offset(index == self.getLastIndex(self.cardIndex) - 1 ? self.translation : .zero)
        .offset(x: 0, y: self.getOffset(index))
        .gesture(index == self.getLastIndex(self.cardIndex) - 1 ? self.topCardDrag : nil)
        //.offset(x: self.flyAwayOffset(index), y: 0)
        .transition(.opacity)
        .rotationEffect(.degrees(index == self.getLastIndex(self.cardIndex) - 1 ? self.degrees : 0), anchor: .bottom)
        //.animation(self.shouldAnimate ? .easeOut(duration: 0.3) : nil)
    }
    
    private var overlay: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                if showClose {
                    Image("close_icon").aspectRatio(.fit).frame(width: 75, height: 75)
                    Spacer()
                }
                if showHeart {
                    Spacer()
                    Image("heart_icon").aspectRatio(.fit).frame(width: 100, height: 100)
                }
            }
        }.opacity(overlay_opacity)
    }
    
    private var overlay_icon: some View {
        ZStack {
            HStack {
                if showClose {
                    Image("close_icon").aspectRatio(.fit).frame(width: 75, height: 75)
                    Spacer()
                }
                if showHeart {
                    Spacer()
                    Image("heart_icon").aspectRatio(.fit).frame(width: 100, height: 100)
                }
            }
        }.opacity(overlay_icon_opacity)
    }
    
}

struct CardCuraselView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardCaruselView(viewModel: CardCuraselViewModel(), showingSetting: false)
                .withoutBar()
                .previewDevice(.init(rawValue: "iPhone SE 1"))
        }
    }
}
