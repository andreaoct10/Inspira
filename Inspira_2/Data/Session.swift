//
//  Session.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 09/05/25.
//

import Foundation

struct Session: Identifiable, Equatable, Hashable, Codable, Sendable {
    var id = UUID()
    var subtopic: String
    var duration: DateComponents
    var notes: String = ""
    var timeRemaining: Int?
    var summary: String?
    
    var isFinished: Bool = false
    var isPinned: Bool = false
    
    
}
