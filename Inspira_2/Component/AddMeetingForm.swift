//
//  AddMeetingForm.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 07/05/25.
//

import SwiftUI
import UserNotifications
import Foundation

struct AddMeetingForm: View {
    @Binding var isPresented: Bool
    @State private var topic: String = ""
    @State private var date: Date = Date()
    var onSave: (Meeting) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primary.opacity(0.5) // Overlay adaptif
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Meeting Topic")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            TextField("Enter topic", text: $topic)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground)) // Adaptif background
                                .cornerRadius(10)
                                .autocorrectionDisabled()
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Meeting Date")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3)))
                    .padding(.horizontal)
                    
                    Button(action: {
                        if !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            let newMeeting = Meeting(topic: topic, date: date)
                            onSave(newMeeting)
                            NotificationManager.shared.scheduleNotifications(for: newMeeting)
                            isPresented = false
                        }
                    }) {
                        Text("Save Meeting")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(topic.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal)
                    //                    Button(action: {
                    //                        if !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    //                            let newMeeting = Meeting(topic: topic, date: date)
                    //                            onSave(newMeeting)
                    //                            isPresented = false
                    //                        }
                    //                    }) {
                    //                        Text("Save Meeting")
                    //                            .fontWeight(.semibold)
                    //                            .frame(maxWidth: .infinity)
                    //                            .padding()
                    //                            .background(topic.isEmpty ? Color.gray : Color.blue)
                    //                            .foregroundColor(.white)
                    //                            .cornerRadius(10)
                    //                    }
                    //                    .disabled(topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    //                    .padding(.horizontal)
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .padding(.bottom)
                    }
                }
                .padding()
                .frame(maxWidth: 400)
                .background(Color(UIColor.systemBackground)) // Adaptif background
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
                // Centering form vertically and horizontally
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}
    //    let isTestingNotifications = true
    //
    //    private func scheduleMeetingNotifications(for meeting: Meeting) {
    //
    //        let center = UNUserNotificationCenter.current()
    //        // Mode untuk (H-1 dan H-0, pukul 9:00)
    //        let calendar = Calendar.current
    //        let now = Date()
    //
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .medium
    //
    //        let title = "Upcoming Meeting"
    //        let body = "\(meeting.topic) on \(formatter.string(from: meeting.date))"
    //        let content = makeNotificationContent(title: title, body: body)
    //
    //        // Untuk testing
    //        if isTestingNotifications {
    //
    //            let quickTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    //
    //            let request = UNNotificationRequest(
    //                identifier: "\(meeting.id.uuidString)-test",
    //                content: content,
    //                trigger: quickTrigger
    //            )
    //            center.add(request)
    //            return
    //        }
    //
    //        // 1 day before (jam 9:00)
    //        if let dayBefore = calendar.date(byAdding: .day, value: -1, to: meeting.date) {
    //            var comps = calendar.dateComponents([.year, .month, .day], from: dayBefore)
    //            comps.hour = 9
    //            comps.minute = 0
    //            comps.second = 0
    //
    //            let scheduleDate = calendar.date(from: comps)!
    ////            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
    //
    //            let trigger: UNNotificationTrigger = scheduleDate > now ? UNCalendarNotificationTrigger(dateMatching: comps, repeats: false) : UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    //
    //
    //            let request = UNNotificationRequest(
    //                identifier: "\(meeting.id.uuidString)-1d",
    //                content: content,
    //                trigger: trigger
    //            )
    //            center.add(request)
    //        }
    //
    //        // Hari-h
    //        var compsToday = calendar.dateComponents([.year, .month, .day], from: meeting.date)
    //        compsToday.hour = 9
    //        compsToday.minute = 0
    //        compsToday.second = 0
    //
    //        let nineAM = calendar.date(from: compsToday)!
    //
    //        //let triggerToday: UNNotificationTrigger/*(dateMatching: compsToday, repeats: false)*/
    //
    //        let triggerToday: UNNotificationTrigger = nineAM > now ? UNCalendarNotificationTrigger(dateMatching: compsToday, repeats: false) : UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    //
    ////        if calendar.isDate(meeting.date, inSameDayAs: now) && now >= nineAM {
    ////            triggerToday = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    ////        } else {
    ////            triggerToday = UNCalendarNotificationTrigger(dateMatching: compsToday, repeats: false)
    ////        }
    //        let requestToday = UNNotificationRequest(
    //            identifier: "\(meeting.id.uuidString)-today",
    //            content: content,
    //            trigger: triggerToday
    //        )
    //        center.add(requestToday)
    //
    ////        let requestToday = UNNotificationRequest(
    ////            identifier: "\(meeting.id.uuidString)-today",
    ////            content: makeNotificationContent(title: title, body: body),
    ////            trigger: triggerToday
    ////        )
    ////        center.add(requestToday)
    //    }
    //
    //    private func makeNotificationContent(title: String, body: String) -> UNNotificationContent {
    //        let content = UNMutableNotificationContent()
    //        content.title = title
    //        content.body = body
    //        content.sound = .default
    //        return content
    //    }
    //}

