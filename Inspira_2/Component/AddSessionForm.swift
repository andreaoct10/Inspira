//
//  AddSessionForm.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 09/05/25.
//

import SwiftUI

struct AddSessionForm: View {
    @Binding var isPresented: Bool
    var onSave: (Session) -> Void
    
    @State private var subtopic: String = ""
    @State private var duration: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primary.opacity(0.5) // Overlay adaptif
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Session subtopic")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        TextField("Enter subtopic", text: $subtopic)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Duration")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        DurationPicker(duration: $duration)
                            .frame(maxWidth: .infinity, maxHeight: 150)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3)))
                    .padding(.horizontal)
                    
                    // Save session button
                    Button(action: {
                        if !subtopic.trimmingCharacters(in: .whitespaces).isEmpty && duration > 0 {
                            let newSession = Session(
                                id: UUID(),
                                subtopic: subtopic,
                                duration: DateComponents(hour: duration / 3600, minute: (duration % 3600) / 60, second: duration % 60),
                                notes: "",
                                timeRemaining: nil,
                                summary: nil,
                                isFinished: false,
                                isPinned: false
                            )
                            onSave(newSession)
                            isPresented = false
                        }
                    }) {
                        Text("Save Session")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(subtopic.isEmpty && duration == 0 ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(subtopic.trimmingCharacters(in: .whitespaces).isEmpty || duration == 0)
                    .padding()
//                    Button(action: {
//                        if !subtopic.trimmingCharacters(in: .whitespaces).isEmpty {
//                            let session = Session(subtopic: subtopic, duration: DateComponents(hour: duration / 3600, minute: (duration % 3600) / 60, second: duration % 60))
//                            onSave(session)
//                            isPresented = false
//                        }
//                    }) {
//                        Text("Save Session")
//                            .fontWeight(.semibold)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(subtopic.isEmpty ? Color.gray : Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .disabled(subtopic.trimmingCharacters(in: .whitespaces).isEmpty)
//                    .padding()
                    
                    // Cancel Button
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                    .padding(.bottom)
                }
                .padding()
                .frame(maxWidth: 400)
                .background(Color(UIColor.systemBackground)) // Adaptif background
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
}
