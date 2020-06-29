//
//  UserProfileViewModel.swift
//  Hush-SwiftUI
//
//  Created Dima Virych on 09.04.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI
import Combine

class UserProfileViewModel: UserProfileViewModeled {

    // MARK: - Properties
    
    @Published var photoUrls: [String] = []
    @Published var mode: UserProfileMode = .photo
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var bio: String = ""
    @Published var lookfor: String = "Female"
    @Published var herefor: String = "Fun"
    @Published var gender: String = "Male"

    
    var aboutMe = "Hello World!"
    var location = "Hello World!"
    //let photos: [UIImage] = Array(0..<3).compactMap { UIImage(named: "image\($0.isMultiple(of: 2) ? 2 : 3)") }
    
    let stories: [UIImage] = Array(0..<20).compactMap { UIImage(named: "image\($0.isMultiple(of: 2) ? 2 : 3)") }
    
    init(user: User?) {
        var userInfo: User
        if user == nil {
            userInfo = Common.userInfo()
        } else {
            userInfo = user!
        }
        name = userInfo.name ?? "Jane"
        address = userInfo.address ?? "London, UK"
        bio = userInfo.bio ?? "I'm Jain, is 20 years old."
        
        let nLookFor = Int(userInfo.looking ?? "1")
        switch nLookFor {
        case 0:
            lookfor = "Male"
            break;
        case 1:
            lookfor = "Female"
            break;
        case 2:
            lookfor = "Guy"
            break;
        default:
            lookfor = "Male"

        }
        herefor = userInfo.hereFor ?? "1"
        gender = userInfo.gender ?? "0"
        let photos = userInfo.photos ?? []
        let photo_count = photos.count
        for index in (0 ..< photo_count) {
            let photo:Photo = photos[index]
            photoUrls.append(photo.photo)
        }
    
    }
    
    func updateMessage() {
        
    }
    
    func switchMode() {
        
        mode.toggle()
    }
}
