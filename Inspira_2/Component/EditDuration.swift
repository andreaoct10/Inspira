//
//  EditDuration.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 12/05/25.
//

import SwiftUI

struct EditDuration: View {
    @Binding var session: Session
    @Binding var durationInSeconds: Int
    @Environment(\.dismiss) private var dismiss
    var onSave: (Int) -> Void
    var onCancel: () -> Void
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Edit Duration")
                    .font(.headline)
                    .padding(.top)
                
                HStack(spacing: 16) {
                    Picker("Hours", selection: $hours) {
                        ForEach(0..<6) { Text("\($0) h").tag($0) }
                    }
                    .frame(width: 100)
                    .clipped()
                    .pickerStyle(.wheel)
                    
                    Picker("Minutes", selection: $minutes) {
                        ForEach(0..<60) { Text("\($0) m").tag($0) }
                    }
                    .frame(width: 100)
                    .clipped()
                    .pickerStyle(.wheel)
                    
                    Picker("Seconds", selection: $seconds) {
                        ForEach(0..<60) { Text("\($0) s").tag($0) }
                    }
                    .frame(width: 100)
                    .clipped()
                    .pickerStyle(.wheel)
                }
                .frame(maxWidth: .infinity)
                //Spacer()
                
                VStack {
                    Button(action: {
                        durationInSeconds = (hours * 3600) + (minutes * 60) + seconds
                        onSave(durationInSeconds)
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .padding(.bottom)
                    
                    //                Button("Save") {
                    //                    session.duration.hour = hours
                    //                    session.duration.minute = minutes
                    //                    session.duration.second = seconds
                    //                    onSave()
                    //                    dismiss()
                    //                }
                    //                .buttonStyle(.borderedProminent)
                    //                .padding(.bottom)
                }
            }
            .padding()
            .frame(maxWidth: 400)
            .onAppear {
                hours = durationInSeconds / 3600
                minutes = (durationInSeconds % 3600) / 60
                seconds = durationInSeconds % 60
//                hours = session.duration.hour ?? 0
//                minutes = session.duration.minute ?? 0
//                seconds = session.duration.second ?? 0
            }
        }
    }
}
