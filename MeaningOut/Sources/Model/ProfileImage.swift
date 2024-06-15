//
//  ProfileImage.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

struct ProfileImage: Hashable {
    let id: String
    let image: UIImage?
    
    init(
        id: String = UUID().uuidString,
        image: UIImage?
    ) {
        self.id = id
        self.image = image
    }
}

extension Array where Element == ProfileImage {
    static let bundle = (0...11).map {
        ProfileImage(image: UIImage(named: "profile_\($0)"))
    }
}
