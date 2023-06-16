//
//  TaskModel.swift
//  Fuji
//
//  Created by Maximilian Samne on 22.03.23.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct TaskModel: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var userUID: String
    var taskTitle: String
    var taskDetail: String
    var taskDeadline: Date
    var taskImportant: Bool
    var taskColor: String
    var taskWeekly: Bool
    var taskMonthly: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case userUID
        case taskTitle
        case taskDetail
        case taskDeadline
        case taskImportant
        case taskColor
        case taskWeekly
        case taskMonthly
    }
}

