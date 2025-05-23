//
//  UpdateMeetingForm.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 15/05/25.
//

import SwiftUI

struct UpdateMeetingForm: View {
    @Binding var isPresented: Bool
    var meeting: Meeting
    var onUpdated: (Meeting) -> Void
    
    @State private var topic: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primary.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Edit Topic")
                                .font(.subheadline)
                                .foregroundColor(.primary)

                            TextField("Enter topic", text: $topic)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .autocorrectionDisabled()
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Edit Date")
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
                            let updatedMeeting = Meeting(
                                id: meeting.id,
                                topic: topic,
                                date: date,
                                sessions: meeting.sessions,
                                isPinned: meeting.isPinned // 👈 mempertahankan pin
                            )
                            onUpdated(updatedMeeting)
                            NotificationManager.shared.scheduleNotifications(for: updatedMeeting)
                            isPresented = false
                        }
                    }) {
                        Text("Update Meeting")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(topic.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal)

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
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .onAppear {
            topic = meeting.topic
            date = meeting.date
        }
    }
}
