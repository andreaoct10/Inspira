//
//  MeetingManager.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 17/05/25.
//

//import Foundation
//import Observation
//
//@Observable
//@MainActor
//final class MeetingManager {
//    static let shared = MeetingManager()
//    
//    @Published @ObservationIgnored private var _meetings: [Meeting] = []
//    
//    private init() { load() }
//    
//    //private(set) var meetings: [Meeting] = []
//    
//    func add(_ meeting: Meeting) {
//        _meetings.append(meeting)
//        save()
//    }
//    
//    private let key = "MeetingStorage"
//    
//    private func save() {
//        if let data = try? JSONEncoder().encode(_meetings) {
//            UserDefaults.standard.set(data, forKey: key)
//        }
//    }
//    
//    private func load() {
//        guard let data = UserDefaults.standard.data(forKey: key),
//              let list = try? JSONDecoder().decode([Meeting].self, from: data) else { return }
//        _meetings = list
//    }
//}
