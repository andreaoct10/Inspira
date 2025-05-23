//
//  Sidebar.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 07/05/25.
//

import SwiftUI

//struct Sidebar: View {
//    @Binding var showForm: Bool
//    @Binding var meetings: [Meeting]
//    @Binding var selectedMeeting: Meeting?
//    
//    var body: some View {
//        ZStack {
//            List(selection: $selectedMeeting) {
//                Section {
//                    Button {
//                        showForm = true
//                    } label: {
//                        Label("Add Meeting", systemImage: "plus.circle")
//                            .foregroundColor(.blue)
//                            .padding(.leading)
//                    }
//                }
//                
//                ForEach(meetings) { meeting in
//                    Text(meeting.topic)
//                        .tag(meeting as Meeting?)
//                }
//            }
//            .listStyle(SidebarListStyle())
//            .navigationTitle("Meetings")
//            
//            Text("No Meeting")
//                .foregroundColor(.gray)
//                .font(.title)
//        }
//    }
//}

struct Sidebar: View {
    @Binding var showForm: Bool
    @Binding var meetings: [Meeting]
    @Binding var selectedMeeting: Meeting?
    
    var onEditMeeting: (Meeting) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //                Text("Meetings")
            //                    .font(.title)
            //                    .bold()
            //                    .padding(.leading)
            
            //Spacer(minLength: 10)
            
            //            Button {
            //                showForm = true
            //            } label: {
            //                Label("Add Meeting", systemImage: "plus.circle")
            //                    .foregroundColor(.blue)
            //                    .padding(.leading)
            //            }
            
            List(selection: $selectedMeeting) {
                Section {
                    Button {
                        selectedMeeting = nil
                        showForm = true // Trigger add form
                    } label: {
                        Label("Add Meeting", systemImage: "plus.circle")
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
                
                Section {
                    ForEach(meetings.sorted { $0.isPinned && !$1.isPinned }) { meeting in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(meeting.topic)
                                    .font(.headline)
                                if meeting.isPinned {
                                    Image(systemName: "pin.fill")
                                        .foregroundColor(.orange)
                                }
                            }
                            Text(meeting.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
                        .contentShape(Rectangle())
                        .tag(meeting)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            pinButton(for: meeting)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            editButton(for: meeting)
                            deleteButton(for: meeting)
                        }
                    }
                }
            }
            .navigationTitle(Text("Meetings"))
        }
        
        // Form khusus untuk add meeting
        //        .sheet(isPresented: $showForm) {
        //            AddMeetingForm(
        //                isPresented: $showForm,
        //                onSave: { newMeeting in
        //                    meetings.append(newMeeting)
        //                    selectedMeeting = newMeeting
        //                }
        //            )
        //        }
        
        // Form khusus untuk mengedit meeting
        //        .sheet(isPresented: $showUpdateForm) {
        //            if let editingMeeting = editingMeeting {
        //                UpdateMeetingForm(
        //                    isPresented: $showUpdateForm,
        //                    meeting: editingMeeting,
        //                    onUpdated: { updatedMeeting in
        //                        if let index = meetings.firstIndex(where: { $0.id == updatedMeeting.id }) {
        //                            meetings[index] = updatedMeeting
        //                            selectedMeeting = updatedMeeting
        //                        }
        //                    }
        //                )
        //            }
        //        }
        //        .sheet(isPresented: $showForm) {
        //            AddMeetingForm(
        //                isPresented: $showForm,
        //                existingMeeting: selectedMeeting, // ⬅️ Ini penting
        //                onSave: { updatedMeeting in
        //                    if let index = meetings.firstIndex(where: { $0.id == updatedMeeting.id }) {
        //                        meetings[index] = updatedMeeting // edit
        //                    } else {
        //                        meetings.append(updatedMeeting) // add
        //                    }
        //                    selectedMeeting = updatedMeeting
        //                }
        //            )
        //        }
    }
    
    private func deleteButton(for meeting: Meeting) -> some View {
        Button(role: .destructive) {
            if let index = meetings.firstIndex(where: { $0.id == meeting.id }) {
                
                // Hapus notifikasi terkait
                NotificationManager.shared.cancelNotifications(for: meeting)
                
                // Hapus meeting dari daftar
                meetings.remove(at: index)
                
                // Reset selection jika yang dihapus adalah yang sedang dipilh
                if selectedMeeting?.id == meeting.id {
                    selectedMeeting = nil
                }
            }
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
    }
    
    private func editButton(for meeting: Meeting) -> some View {
        Button {
            selectedMeeting = meeting
            onEditMeeting(meeting)
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.blue)
    }
    
    private func pinButton(for meeting: Meeting) -> some View {
        Button {
            if let index = meetings.firstIndex(where: { $0.id == meeting.id }) {
                meetings[index].isPinned.toggle()
                
                //                let updated = meetings.remove(at: index)
                //                meetings.insert(updated, at: index)
            }
        } label: {
            Label(meeting.isPinned ? "Unpin" : "Pin", systemImage: meeting.isPinned ? "pin.slash" : "pin")
        }
        .tint(.orange)
    }
}
