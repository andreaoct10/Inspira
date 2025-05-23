//
//  Inspira_2App.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 07/05/25.
//

import SwiftUI

@main
struct Inspira_2App: App {
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        center.delegate = NotificationDelegate.shared 
    }
    
    var body: some Scene {
        WindowGroup {
            MeetingPage()
        }
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    private override init() { super.init() }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
