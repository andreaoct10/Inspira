//
//  Meeting.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 09/05/25.
//

import Foundation

struct Meeting: Identifiable, Equatable, Hashable, Codable, Sendable {
    var id = UUID()
    var topic: String
    var date: Date
    var sessions: [Session] = []
    var isPinned: Bool = false
    
    init(id: UUID = UUID(), topic: String, date: Date, sessions: [Session] = [], isPinned: Bool = false) {
            self.id = id
            self.topic = topic
            self.date = date
            self.sessions = sessions
            self.isPinned = isPinned
        }
}
