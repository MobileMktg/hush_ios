//
//  CardCuraselViewModel.swift
//  Hush-SwiftUI
//
//  Created Dima Virych on 03.04.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class CardCuraselViewModel: CardCuraselViewModeled {
        
    // MARK: - Properties
    
    @Published var message = "Hellow World!"
    @Published var isShowingIndicator: Bool = false
    //@Published var photos: [String] = []
    @Published var name: String = "Alex"
    @Published var age: String = "32"
    @Published var address: String = "London, UK"
    @Published var games: [Game] = []
    @Published var isBlock: Bool = false
    @Published var showUserProfile: Bool = false
    @Published var showUpgrade: Bool = false
    @Published var selectedUser: User = User()

    init() {
        self.loadGame { (result) in
            
        }
    }
    
    func userLike(userID: String, like: String) {
        UserAPI.shared.game_like(toUserID: userID, like: like) { (error) in
            if (error == nil) {
                
            }
        }
    }
    
    func loadGame(result: @escaping (Bool) -> Void) {
       
        self.isShowingIndicator = true
        AuthAPI.shared.game { (userList, error) in
            self.isShowingIndicator = false
            self.games.removeAll()
            
            if error == nil {
               if let userList = userList {
                    for user in userList {
//                        if self.games.count == 8 {
//                            break;
//                        }
                        self.games.append(user!)

                    }
               }
                result(true)
            } else {
                result(false)
            }

        }
    }
        
    func updateMessage() {
        
        message = "New Message"
    }
    
}

struct CardCuraselViewModel_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
