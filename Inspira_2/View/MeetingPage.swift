//
//  MeetingPage.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 08/05/25.
//

import SwiftUI

struct MeetingPage: View {
    @State private var isSidebarVisible: Bool = true
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var showForm: Bool = false
    @State private var showAddSessionSheet: Bool = false
    @State private var showUpdateMeetingForm: Bool = false
    @State private var showUpdateSessionSheet: Bool = false
    @State private var sessionToEdit: Session? = nil
    @State private var meetingToEdit: Meeting? = nil
    
    // Data
    @State private var meetings: [Meeting] = []
    @State private var selectedMeeting: Meeting? = nil
    @State private var sessions: [Session] = []
    @State private var selectedSession: Session?
    @State var timeRemaining: Int = 0
    
    @State private var navPath: [Session] = []
    
    var body: some View {
        ZStack {
            NavigationSplitView {
                if isSidebarVisible || horizontalSizeClass == .compact {
                    Sidebar(showForm: $showForm, meetings: $meetings, selectedMeeting: $selectedMeeting, onEditMeeting: { meeting in
                        meetingToEdit = meeting
                        showUpdateMeetingForm = true
                    })
                }
            } content: {
                SessionContent(selectedMeeting: $selectedMeeting, showAddSessionSheet: $showAddSessionSheet, meetings: $meetings, selectedSession: $selectedSession, timeRemaining: $timeRemaining, onEditSession: { session in
                    sessionToEdit = session
                    showUpdateSessionSheet = true
                })
            } detail: {
                if let selectedMeeting,
                   let session = selectedSession,
                   let meetingIndex = meetings.firstIndex(where: { $0.id == selectedMeeting.id}),
                   let sessionIndex = meetings[meetingIndex].sessions.firstIndex(where: { $0.id == session.id}) {
                    Detail(session: $meetings[meetingIndex].sessions[sessionIndex])
                        .id(selectedSession?.id)
                } else {
                    Text("Detail area")
                        .foregroundColor(.gray)
                }
                //                if let session = selectedSession {
                //                    Detail(session: session)
                //                } else {
                //                    Text("Detail area")
                //                        .foregroundColor(.gray)
                //                }
                //                Detail(session: $selectedSession)
            }
            //            .toolbar(content: {
            //                ToolbarItem(placement: .topBarLeading) {
            //                    Button(action: {
            //                        withAnimation {
            //                            isSidebarVisible.toggle()
            //                        }
            //                    }) {
            //                        Image(systemName: "sidebar.leading")
            //                    }
            //                }
            //            })
            // Overlay form
            .overlay {
                if showForm {
                    AddMeetingForm(isPresented: $showForm, onSave: { newMeeting in
                        if let index = meetings.firstIndex(where: { $0.id == newMeeting.id}) {
                            meetings[index] = newMeeting
                        } else {
                            meetings.append(newMeeting)
                        }
                        selectedMeeting = newMeeting
                        //                        meetings.append(meeting)})
                    })
                    .transition(.opacity)
                    .zIndex(1)
                }
                
                if showUpdateMeetingForm, let meetingToEdit {
                    UpdateMeetingForm(
                        isPresented: $showUpdateMeetingForm,
                        meeting: meetingToEdit,
                        onUpdated: { updatedMeeting in
                            if let index = meetings.firstIndex(where: { $0.id == updatedMeeting.id }) {
                                meetings[index] = updatedMeeting
                                selectedMeeting = updatedMeeting
                            }
                    })
                    .transition(.opacity)
                    .zIndex(1)
                }
                
                if showAddSessionSheet && !showUpdateSessionSheet {
                    AddSessionForm(isPresented: $showAddSessionSheet, onSave: {newSession in
                        if let index = meetings.firstIndex(where: { $0.id == selectedMeeting?.id }) {
                            meetings[index].sessions.append(newSession)
                            selectedMeeting = meetings[index]
                            selectedSession = newSession
                        }
                    })
                    .transition(.opacity)
                    .zIndex(1)
                }
                
                if showUpdateSessionSheet && !showAddSessionSheet, let sessionToEdit {
                    UpdateSessionForm(
                        isPresented: $showUpdateSessionSheet,
                        existingSession: sessionToEdit,
                        onSave: { updatedSession in
                            if let meetingIndex = meetings.firstIndex(where: { $0.id == selectedMeeting?.id }) {
                                if let sessionIndex = meetings[meetingIndex].sessions.firstIndex(where: { $0.id == updatedSession.id }) {
                                    meetings[meetingIndex].sessions[sessionIndex] = updatedSession
                                    selectedMeeting = meetings[meetingIndex]
                                    selectedSession = updatedSession
                                }
                            }
                    })
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
        .animation(.easeInOut, value: showForm || showAddSessionSheet || showUpdateMeetingForm || showUpdateSessionSheet)
//        .animation(.easeInOut, value: showAddSessionSheet)
//        .animation(.easeInOut, value: showUpdateMeetingForm)
//        .animation(.easeInOut, value: showUpdateSessionSheet)
    }
}


#Preview {
    MeetingPage()
}
