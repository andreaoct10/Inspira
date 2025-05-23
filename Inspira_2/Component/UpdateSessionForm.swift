//
//  UpdateSessionForm.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 15/05/25.
//

import SwiftUI

struct UpdateSessionForm: View {
    @Binding var isPresented: Bool
    var existingSession: Session
    var onSave: (Session) -> Void

    @State private var subtopic: String = ""
    @State private var duration: Int = 0
    @State private var isPinned: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primary.opacity(0.5).edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Session subtopic")
                            .font(.subheadline)
                        TextField("Enter subtopic", text: $subtopic)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Duration")
                            .font(.subheadline)
                        DurationPicker(duration: $duration)
                            .frame(maxWidth: .infinity, maxHeight: 150)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3)))
                    .padding(.horizontal)

//                    Toggle(isOn: $isPinned) {
//                        Label("Pin Session", systemImage: "pin")
//                    }
//                    .padding()

                    Button(action: {
                        if !subtopic.trimmingCharacters(in: .whitespaces).isEmpty && duration > 0 {
                            let updatedSession = Session(
                                id: existingSession.id,
                                subtopic: subtopic,
                                duration: DateComponents(
                                    hour: duration / 3600,
                                    minute: (duration % 3600) / 60,
                                    second: duration % 60
                                ),
                                notes: existingSession.notes,
                                timeRemaining: existingSession.timeRemaining,
                                summary: existingSession.summary,
                                isFinished: existingSession.isFinished,
                                isPinned: isPinned
                            )
                            onSave(updatedSession)
                            isPresented = false
                        }
                    }) {
                        Text("Update Session")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(subtopic.isEmpty && duration == 0 ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(subtopic.trimmingCharacters(in: .whitespaces).isEmpty || duration == 0)
                    .padding()

                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                    .padding(.bottom)
                }
                .padding()
                .frame(maxWidth: 400)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
        .onAppear {
            subtopic = existingSession.subtopic
            //isPinned = existingSession.isPinned
            duration = (existingSession.duration.hour ?? 0) * 3600 + (existingSession.duration.minute ?? 0) * 60 + (existingSession.duration.second ?? 0)
        }
    }
}

