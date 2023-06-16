//
//  UserModel.swift
//  Fuji
//
//  Created by Maximilian Samne on 21.03.23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct UserModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userUID: String
    var userNote: String
    // var userOnline: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case userUID
        case userNote
        // case userOnline
    }
}
