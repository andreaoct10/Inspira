//
//  NotificationManager.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 17/05/25.
//

import Foundation
import UserNotifications

// Satu‑satunya objek yang mem‑handle seluruh penjadwalan notifikasi Meeting.
final class NotificationManager {
    
    // Gunakan `NotificationManager.shared`
    static let shared = NotificationManager()
    private init() {}
    
    // `true` → semua notifikasi diganti menjadi “mode testing” (muncul 1 detik lagi).
    var isTesting = false
    
    // MARK: – Public API
    // Jadwalkan ulang semua notifikasi untuk sebuah *Meeting* (hapus‑lama, tambah‑baru)
    func scheduleNotifications(for meeting: Meeting) {
        let center = UNUserNotificationCenter.current()
        
        // 1. hapus request lama (H‑1, H‑0, & test)
        let ids = ["\(meeting.id.uuidString)-1d",
                   "\(meeting.id.uuidString)-today",
                   "\(meeting.id.uuidString)-test"]
        center.removePendingNotificationRequests(withIdentifiers: ids)
        
        // 2. buat konten
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        let title = "Upcoming Meeting"
        let body  = "\(meeting.topic) on \(fmt.string(from: meeting.date))"
        let content = self.makeContent(title: title, body: body)
        
        // 3a. Mode testing → 1 detik
        if isTesting {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let req = UNNotificationRequest(identifier: "\(meeting.id.uuidString)-test",
                                            content: content,
                                            trigger: trigger)
            center.add(req)
            return
        }
        
        // 3b. Mode normal (H‑1 & H‑0 pukul 09:00)
        let cal  = Calendar.current
        
        // H‑1
        if let dayBefore = cal.date(byAdding: .day, value: -1, to: meeting.date) {
            var comps = cal.dateComponents([.year,.month,.day], from: dayBefore)
            comps.hour = 9; comps.minute = 0; comps.second = 0
            let trig = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            center.add(.init(identifier: "\(meeting.id.uuidString)-1d",
                             content: content,
                             trigger: trig))
        }
        
        // H‑0
        var today = cal.dateComponents([.year,.month,.day], from: meeting.date)
        today.hour = 9; today.minute = 0; today.second = 0
        
        let nineAM = cal.date(from: today)!
        let triggerToday: UNNotificationTrigger =
              (cal.isDateInToday(meeting.date) && Date() > nineAM)
                ? UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                : UNCalendarNotificationTrigger(dateMatching: today, repeats: false)
        
        center.add(.init(identifier: "\(meeting.id.uuidString)-today",
                         content: content,
                         trigger: triggerToday))
    }
    
    func cancelNotifications(for meeting: Meeting) {
        let center = UNUserNotificationCenter.current()
        let ids = ["\(meeting.id.uuidString)-1d",
                   "\(meeting.id.uuidString)-today",
                   "\(meeting.id.uuidString)-test"]
        center.removePendingNotificationRequests(withIdentifiers: ids)
        center.removeDeliveredNotifications(withIdentifiers: ids)
    }
    
    // MARK: – Helpers
    private func makeContent(title: String, body: String) -> UNMutableNotificationContent {
        let c = UNMutableNotificationContent()
        c.title = title
        c.body  = body
        c.sound = .default
        return c
    }
}
