//
//  MeetingContent.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 08/05/25.
//

import SwiftUI

//struct SessionContent: View {
//    
//    @Binding var selectedMeeting: Meeting?
//    @Binding var showAddSessionSheet: Bool
//    @Binding var sessions: [Session]
//    
//    
//    var body: some View {
//        ZStack {
//            if selectedMeeting != nil {
//                List {
//                    Section {
//                        Button {
//                            showAddSessionSheet = true
//                            } label: {
//                                Label("Add Session", systemImage: "plus.circle")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    Section(header: Text("Sessions")) {
//                        if sessions.isEmpty {
//                            Text("No Session")
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        } else {
//                            
//                            // List of sessions for this meeting
//                            ForEach(sessions) { session in
//                                Text(session.subtopic)
//                            }
//                        }
//                    }
//                }
//                .listStyle(SidebarListStyle())
//                .navigationTitle("Sessions")
//            } else {
//                Text("No Session")
//                    .foregroundColor(.gray)
//                    .font(.title)
//            }
//            
//            // Overlay for Add Session
//            if showAddSessionSheet {
//                Color.black.opacity(0.3)
//                    .edgesIgnoringSafeArea(.all)
//                
//                AddSessionForm(isPresented: $showAddSessionSheet) { newSession in
//                    sessions.append(newSession)
//                }
//                .frame(maxWidth: 500)
//                .transition(.scale)
//            }
//        }
//    }
//}

//struct SessionContent: View {
//    @Binding var selectedMeeting: Meeting?
//    @Binding var showAddSessionSheet: Bool
//    @Binding var sessions: [Session]
//    
//    var body: some View {
//        ZStack {
//            List {
//                if let _ = selectedMeeting {
//                    Section {
//                        Button {
//                            showAddSessionSheet = true
//                        } label: {
//                            Label("Add Session", systemImage: "plus.circle")
//                                .foregroundColor(.blue)
//                                .padding(.leading)
//                        }
//                    }
//                    
//                    Section(header: Text("Sessions")) {
//                        if sessions.isEmpty {
//                            Text("No Session")
//                                .foregroundColor(.gray)
//                        } else {
//                            ForEach(sessions) { session in
//                                Text(session.subtopic)
//                            }
//                        }
//                    }
//                } else {
//                    Text("No Meeting Selected")
//                        .foregroundColor(.gray)
//                        .font(.title)
//                }
//            }
//            .listStyle(.plain)
//        }
//    }
//}

//struct SessionContent: View {
//    @Binding var selectedMeeting: Meeting?
//    @Binding var showAddSessionSheet: Bool
//    @Binding var meetings: [Meeting]
//
//    var body: some View {
//        ZStack {
//            List {
//                if let _ = selectedMeeting {
//                    Section {
//                        Button {
//                            showAddSessionSheet = true
//                        } label: {
//                            Label("Add Session", systemImage: "plus.circle")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
//            }
//            .listStyle(SidebarListStyle())
//            .navigationTitle("Sessions")
//
//            if let meeting = selectedMeeting {
//                if meeting.sessions.isEmpty {
//                    Text("No Session")
//                        .foregroundColor(.gray)
//                        .font(.title)
//                } else {
//                    ScrollView {
//                        LazyVStack(alignment: .leading, spacing: 12) {
//                            ForEach(meeting.sessions) { session in
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(session.subtopic)
//                                        .font(.headline)
//                                    Text("\(session.duration.hour ?? 0)h \(session.duration.minute ?? 0)m")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                }
//            } else {
//                Text("No Session")
//                    .foregroundColor(.gray)
//                    .font(.title)
//            }
//        }
//        .onChange(of: meetings) {
//            if let currentID = selectedMeeting?.id {
//                selectedMeeting = meetings.first(where: { $0.id == currentID })
//            }
//        }
//    }
//}

struct SessionContent: View {
    @Binding var selectedMeeting: Meeting?
    @Binding var showAddSessionSheet: Bool
    @Binding var meetings: [Meeting]
    @Binding var selectedSession: Session?
    @Binding var timeRemaining: Int
    
//    @Binding var showUpdateSessionSheet: Bool
//    @Binding var sessionToEdit: Session?
    
    var onEditSession: (Session) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            if let meeting = selectedMeeting {
                // Tombol "Add Session"
                Button {
                    selectedSession = nil
                    showAddSessionSheet = true
                } label: {
                    Label("Add Session", systemImage: "plus.circle")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                .padding(.top)

                // Daftar Session
                if meeting.sessions.isEmpty {
                    Spacer()
                    Text("No Session")
                        .foregroundColor(.gray)
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    List {
                        ForEach(meeting.sessions.sorted { $0.isPinned && !$1.isPinned }) { session in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(session.subtopic)
                                        .font(.headline)
                                    if session.isPinned {
                                        Image(systemName: "pin.fill")
                                            .foregroundColor(.orange)
                                    }
                                }
                                Text("\(session.duration.hour ?? 0)h \(session.duration.minute ?? 0)m \(session.duration.second ?? 0)s")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .onTapGesture {
                                handleSessionTap(session)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                pinButton(for: session, in: meeting)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                editButton(for: session)
                                deleteButton(for: session, in: meeting)
                            }
                        }
                    }
                    .listStyle(.plain)

//                    ScrollView {
//                        LazyVStack(alignment: .leading, spacing: 12) {
//                            ForEach(meeting.sessions.sorted { $0.isPinned && !$1.isPinned }) { session in
//                                VStack(alignment: .leading, spacing: 4) {
//                                    HStack {
//                                        Text(session.subtopic)
//                                            .font(.headline)
//                                        if session.isPinned {
//                                            Image(systemName: "pin.fill")
//                                                .foregroundColor(.orange)
//                                        }
//                                    }
//                                    Text("\(session.duration.hour ?? 0)h \(session.duration.minute ?? 0)m \(session.duration.second ?? 0)s")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
//                                .onTapGesture {
//                                    handleSessionTap(session)
////                                    selectedSession = session
////                                    if let remaining = session.timeRemaining {
////                                        timeRemaining = remaining
////                                    } else {
////                                        timeRemaining = (session.duration.hour ?? 0) * 3600 + (session.duration.minute) * 60 + (session.duration.second ?? 0)
////                                    }
//                                }
//                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                                    pinButton(for: session, in: meeting)
//                                }
//                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                                    editButton(for: session)
//                                    deleteButton(for: session, in: meeting)
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
                }
            } else {
                Spacer()
                Text("No Session")
                    .foregroundColor(.gray)
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Sessions")
        .onChange(of: meetings) {
            if let currentID = selectedMeeting?.id {
                selectedMeeting = meetings.first(where: { $0.id == currentID })
            }
        }
//        .sheet(isPresented: $showAddSessionSheet) {
//            AddSessionForm(
//                isPresented: $showAddSessionSheet,
//                onSave: { newSession in
//                    guard let selectedMeetingID = selectedMeeting?.id else { return }
//                    if let meetingIndex = meetings.firstIndex(where: { $0.id == selectedMeetingID }) {
//                        var meeting = meetings[meetingIndex]
//                        meeting.sessions.append(newSession)
//                        meetings[meetingIndex] = meeting
//                        selectedMeeting = meeting
//                        selectedSession = newSession
//                    }
//                }
//            )
//        }
//        .sheet (isPresented: $showUpdateSessionSheet) {
//            if let editingSession = sessionToEdit {
//                UpdateSessionForm(
//                    isPresented: $showUpdateSessionSheet,
//                    existingSession: editingSession,
//                    onSave: { updatedSession in
//                        guard let selectedMeetingID = selectedMeeting?.id else { return }
//                        if let meetingIndex = meetings.firstIndex(where: { $0.id == selectedMeetingID }) {
//                            var meeting = meetings[meetingIndex]
//
//                            if let sessionIndex = meeting.sessions.firstIndex(where: { $0.id == updatedSession.id }) {
//                                meeting.sessions[sessionIndex] = updatedSession
//                                meetings[meetingIndex] = meeting
//                                selectedMeeting = meeting
//                                selectedSession = updatedSession
//                            }
//                        }
//                    }
//                )
//            }
//        }
    }
    
    private func handleSessionTap(_ session: Session) {
        selectedSession = session
        if let remaining = session.timeRemaining {
            timeRemaining = remaining
        } else {
            let h = session.duration.hour ?? 0
            let m = session.duration.minute ?? 0
            let s = session.duration.second ?? 0
            timeRemaining = h * 3600 + m * 60 + s
        }
    }
    
    private func deleteButton(for session: Session, in meeting: Meeting) -> some View {
        Button(role: .destructive) {
            if let meetingIndex = meetings.firstIndex(where: { $0.id == meeting.id }) {
                if let sessionIndex = meetings[meetingIndex].sessions.firstIndex(where: { $0.id == session.id }) {
                    meetings[meetingIndex].sessions.remove(at: sessionIndex)
                    if selectedSession?.id == session.id {
                        selectedSession = nil
                    }
                }
            }
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
    }

    private func editButton(for session: Session) -> some View {
        Button {
            selectedSession = session
            onEditSession(session)
//            sessionToEdit = session
//            showUpdateSessionSheet = true
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.blue)
    }

    private func pinButton(for session: Session, in meeting: Meeting) -> some View {
        Button {
            if let meetingIndex = meetings.firstIndex(where: { $0.id == meeting.id }) {
                if let sessionIndex = meetings[meetingIndex].sessions.firstIndex(where: { $0.id == session.id }) {
                    meetings[meetingIndex].sessions[sessionIndex].isPinned.toggle()
                }
            }
        } label: {
            Label(session.isPinned ? "Unpin" : "Pin", systemImage: session.isPinned ? "pin.slash" : "pin")
        }
        .tint(.orange)
    }

}

