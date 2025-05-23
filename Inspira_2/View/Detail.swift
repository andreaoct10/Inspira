//
//  Detail.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 08/05/25.
//

import SwiftUI
import NaturalLanguage

//struct Detail: View {
//    var body: some View {
//        VStack {
//            Text("Detail Area")
//                .foregroundColor(.gray)
//                .font(.title)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.white)
//    }
//}

//struct Detail: View {
//    var session: Session
//    
//    @State private var timeRemaining: Int
//    @State private var timerRunning = false
//    @State private var noteText = ""
//    //@State private var timer: Timer? = nil
//    
//    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    
//    init(session: Session) {
//        self.session = session
//        let totalSeconds = (session.duration.hour ?? 0) * 3600 + (session.duration.minute ?? 0) * 60
//        _timeRemaining = State(initialValue: totalSeconds)
//    }
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            Text("Timers")
//                .font(.title.bold())
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            ZStack {
//                Circle()
//                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
//                
//                Circle()
//                    .trim(from: 0, to: progress(for: session))
//                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
//                    .rotationEffect(.degrees(-90))
//                    //.animation(.linear(duration: 1.0), value: timeRemaining)
//                    .animation(.easeInOut, value: progress(for: session))
//                
//                VStack(spacing: 12) {
//                    Text(timeFormatted())
//                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
//                    Text("\(timeRemaining / 60) minutes remaining")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    
//                    Button(action: {
//                        //toogleTimer(for: session)
//                    }) {
//                        Image(systemName: timerRunning ? "pause.circle.fill" : "play.circle.fill")
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .foregroundColor(.blue)
//                    }
//                }
//            }
//            .frame(width: 220, height: 220)
//            
//            VStack(alignment: .leading) {
//                Text("Notes")
//                    .font(.headline)
//                TextEditor(text: $noteText)
//                    .frame(height: 150)
//                    .padding(8)
//                    .background(Color(UIColor.secondarySystemBackground))
//                    .cornerRadius(10)
//            }
//            Spacer()
//        }
//        .padding()
//        .onReceive(timer) { _ in
//            if timerRunning && timeRemaining > 0 {
//                timeRemaining -= 1
//            }
//        }
////        .onDisappear {
////            timer?.invalidate()
////        }
//    }
//    
//    private func timeFormatted() -> String {
//        let hours = timeRemaining / 3600
//        let minutes = (timeRemaining % 3600) / 60
//        let seconds = timeRemaining % 60
//        return String(format: "%02dh:%02dm:%02ds", hours, minutes, seconds)
//        
//    }
//    
////    private func toogleTimer(for session: Session) {
////        if timerRunning {
////            timer?.invalidate()
////            timerRunning = false
////        } else {
////            timerRunning = true
////            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
////                if timeRemaining > 0 {
////                    timeRemaining -= 1
////                } else {
////                    timer?.invalidate()
////                    timerRunning = false
////                }
////            }
////        }
////    }
//    
//    private func progress(for session: Session) -> CGFloat {
//        let total = (session.duration.hour ?? 0) * 3600 + (session.duration.minute ?? 0) * 60
//        guard total > 0 else { return 0 }
//        return 1 - CGFloat(timeRemaining) / CGFloat(total)
//    }
//}

struct Detail: View {
    @Binding var session: Session

    //@State private var timeRemaining: Int
    //@State private var timerRunning = false
    @State private var noteText = ""
    @State private var timerFinished = false
    @State private var showDurationEditor = false
    @State private var editingDuration: Int = 0
    
    //@State private var summaryText = ""
    @State private var isLoading = false
    @State private var summarizeWorkItem: DispatchWorkItem?
    
    @StateObject private var timerManager: TimerManager

    //private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(session: Binding<Session>) {
        self._session = session
        let totalSeconds = (session.wrappedValue.duration.hour ?? 0) * 3600 + (session.wrappedValue.duration.minute ?? 0) * 60 + (session.wrappedValue.duration.second ?? 0)
        //let totalSeconds = min((session.duration.hour ?? 0) * 3600 + (session.duration.minute ?? 0) * 60, 18000) // Max 5 hours
        //self._timeRemaining = State(initialValue: totalSeconds)
        self._timerManager = StateObject(wrappedValue: TimerManager(initialTime: totalSeconds))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    if timerFinished {
                        Text(session.subtopic.isEmpty ? "Session" : session.subtopic)
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("Timers")
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Button(action: {
                            showDurationEditor = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "pencil")
                                Text("Timer")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
//                    Text("Timers")
//                        .font(.title.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        showDurationEditor = true
//                    }) {
//                        HStack(spacing: 4) {
//                            Image(systemName: "pencil")
//                            Text("Timer")
//                                .font(.subheadline)
//                        }
//                        .foregroundColor(.blue)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 6)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                    }
                }
                .padding(.horizontal)
                
                if !timerFinished {
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: progress(for: session))
                        //.stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .stroke(timerFinished ? Color.blue : Color.blue,
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut, value: progress(for: session))
                        
                        VStack(spacing: 12) {
                            Text(timeFormatted(from: timerManager.timeRemaining))
                                .font(.system(size: 24, weight: .semibold, design: .monospaced))
                            //                    Text("\(timeRemaining / 60) minutes remaining")
                            //                        .font(.subheadline)
                            //                        .foregroundColor(.secondary)
                            
                            Button(action: {
                                if timerManager.isRunning {
                                    timerManager.pause()
                                    session.timeRemaining = timerManager.timeRemaining
                                } else {
                                    timerManager.start()
                                }
                            }) {
                                Image(systemName: timerManager.isRunning ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.blue)
                            }
                            //                        if timerFinished {
                            //                            Button(action: {
                            //                                //editingDuration = session.duration
                            //                                //resetTimer()
                            //                                showDurationEditor = true
                            //                                //timerRunning.toggle()
                            //                            }) {
                            //                                Image(systemName: "arrow.counterclockwise.circle.fill")
                            //                                    .resizable()
                            //                                    .frame(width: 60, height: 60)
                            //                                    .foregroundColor(.blue)
                            //                            }
                            //                        } else {
                            //                            Button(action: {
                            //                                if timerManager.isRunning {
                            //                                    timerManager.pause()
                            //                                    session.timeRemaining = timerManager.timeRemaining
                            //                                } else {
                            //                                    timerManager.start()
                            //                                }
                            //                                //                            timerRunning.toggle()
                            //                                //
                            //                                //                            if !timerRunning {
                            //                                //                                // Simpan waktu terakhir saat timer di-pause
                            //                                //                                session.timeRemaining = timeRemaining
                            //                                //                            }
                            //                            }) {
                            //                                Image(systemName: timerManager.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            //                                    .resizable()
                            //                                    .frame(width: 60, height: 60)
                            //                                    .foregroundColor(.blue)
                            //                            }
                            //                        }
                        }
                    }
                    .frame(width: 220, height: 220)
                }
                
                VStack(alignment: .leading) {
                    Text("Notes")
                        .font(.headline)
//                    ScrollView {
                        TextEditor(text: $session.notes)
                            .scrollDismissesKeyboard(.immediately)
                            .frame(minHeight: 150, maxHeight: 300)
                            .padding(3)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            .cornerRadius(5)
                            .autocorrectionDisabled()
                            .scrollContentBackground(.hidden)
//                    }
                    .frame(height: 300)
                    
                    if let summary = session.summary, !summary.isEmpty {
                        Text("Summary")
                            .font(.headline)
                            //.padding(.top, 8)
                        
                        Text(summary)
                            .padding(3)
                            //.frame(width: 645, alignment: .leading)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
//        .onReceive(timer) { _ in
//            guard timerRunning && timeRemaining > 0 else { return }
//
//                DispatchQueue.global(qos: .userInitiated).async {
//                    let newTime = timeRemaining - 1
//                    if newTime >= 0 {
//                        DispatchQueue.main.async {
//                            timeRemaining = newTime
//                            session.timeRemaining = newTime
//
//                            if newTime == 0 {
//                                timerRunning = false
//                                timerFinished = true
//                                isLoading = true
//                                summarizeText(from: session.notes) { summary in
//                                    DispatchQueue.main.async {
//                                        summaryText = summary
//                                        isLoading = false
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            if timerRunning && timeRemaining > 0 {
//                timeRemaining -= 1
//                session.timeRemaining = timeRemaining // Simpan setiap detik berjalan
//                if timeRemaining == 0 {
//                    timerRunning = false
//                    timerFinished = true
//                    
//                    isLoading = true
//                    summarizeText(from: session.notes) { summary in
//                        summaryText = summary
//                    }
//                }
//            }
       // }
        .sheet(isPresented: $showDurationEditor) {
            EditDuration(session: $session, durationInSeconds: $editingDuration) { newDuration in
                session.duration = DateComponents(
                    hour: newDuration / 3600,
                    minute: (newDuration % 3600) / 60,
                    second: newDuration % 60
                )
                timerManager.reset(to: newDuration)
                //timeRemaining = newDuration
                //timerRunning = false
                timerFinished = false
                showDurationEditor = false
                resetTimer()
            } onCancel: {
                showDurationEditor = false
            }
        }
        .onAppear {
            let hour = session.duration.hour ?? 0
            let minute = session.duration.minute ?? 0
            let second = session.duration.second ?? 0
            editingDuration = hour * 3600 + minute * 60 + second
            
            if let savedRemaining = session.timeRemaining {
                timerManager.reset(to: savedRemaining)
                //timeRemaining = savedRemaining
            } else {
                timerManager.reset(to: editingDuration)
                //timeRemaining = editingDuration
            }
            
            timerFinished = session.isFinished
        }
        .onChange(of: session.id, initial: false) { _, _ in
//            timerManager.reset(to: totalDurationInSeconds())
//            //timeRemaining = totalDurationInSeconds()
//            //timerRunning = false
//            timerFinished = false
            if let savedRemaining = session.timeRemaining {
                // Timer pernah berjalan -> lanjutkan dari sisa waktu
                timerManager.reset(to: savedRemaining)
                timerFinished = (savedRemaining == 0)
            } else {
                // Timer belum pernah dimulai -> reset ke durasi penuh
                let newDuration = totalDurationInSeconds()
                timerManager.reset(to: newDuration)
                timerFinished = false
                //timerManager.reset(to: totalDurationInSeconds())
            }
            //timerFinished = session.isFinished
        }
        .onChange(of: session.notes) { _, _ in
            guard timerFinished else { return } // Membatasi untuk auto summarize hanya berjalan jika timer sudah selesai
            
            summarizeWorkItem?.cancel()
            
            let workItem = DispatchWorkItem {
                summarizeText(from: session.notes) { summary in
                    session.summary = summary
                }
            }
            summarizeWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: workItem) // Kalo 15 detik gada interaksi typing, auto summary lagi
        }
        .onChange(of: timerManager.timeRemaining) { _, newValue in
            session.timeRemaining = newValue
            
            if newValue == 0 && !timerFinished {
                timerFinished = true
                isLoading = true
                summarizeText(from: session.notes) { summary in
                    session.summary = summary
                    isLoading = false
                }
            }
        }
    }

//    private func timeFormatted() -> String {
//        timeFormatted(from: timerManager.timeRemaining)
//    }
    
    // Versi dengan parameter (bisa dipake di tempat lain)
    private func timeFormatted(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
//        let hours = timeRemaining / 3600
//        let minutes = (timeRemaining % 3600) / 60
//        let seconds = timeRemaining % 60
        return String(format: "%02dh:%02dm:%02ds", hours, minutes, seconds)
    }

    private func progress(for session: Session) -> CGFloat {
        let total = min((session.duration.hour ?? 0) * 3600 + (session.duration.minute ?? 0) * 60 + (session.duration.second ?? 0), 18000) // Max 5 hours
        guard total > 0 else { return 0 }
        return 1 - CGFloat(timerManager.timeRemaining) / CGFloat(total)
    }
    
    private func resetTimer() {
        let duration = totalDurationInSeconds()
        timerManager.reset(to: duration)
//        timeRemaining = totalDurationInSeconds()
//        timerRunning = false
        timerFinished = false
    }
    
    private func totalDurationInSeconds() -> Int {
        (session.duration.hour ?? 0) * 3600 + (session.duration.minute ?? 0) * 60 + (session.duration.second ?? 0)
    }
}

//#Preview {
//    Detail()
//}
