//
//  AddMeetingIntent.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 17/05/25.
//

//import AppIntents
//
//@available(iOS 17, *)
//
//struct AddMeetingIntent: AppIntent, ProvidesDialog {
//    
//    static var title: LocalizedStringResource = "Add Meeting"
//    static var description = IntentDescription("Create a new meeting and save it to the app.")
//    
//    
//    // Parameter in Shortcuts
//    @Parameter(title: "Meeting Topic")
//    var topic: String
//    
//    @Parameter(title: "Date", default: .now)
//    var date: Date
//
//    func perform() async throws -> some IntentResult {
//        let meeting = Meeting(topic: topic, date: date)
//        await MeetingManager.shared.add(meeting)
//        
//        // Confirmation text in Shortcuts
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        let when = formatter.string(from: date)
//        
//        //let confirmationDialog = IntentDialog(stringLiteral: "Added “\(topic)” on \(when).")
//        
//        return .result(dialog: "Added “\(topic)” on \(when).")
//        //return .result(dialog: "Added “\(topic)” on \(when).")
//    }
//}

//import AppIntents
//
//@available(iOS 17, *)
//struct AddMeetingIntent: AppIntent/*, ProvidesDialog*/ {
//
//    static var title: LocalizedStringResource = "Add Meeting"
//    static var description =
//        IntentDescription("Create a new meeting and save it to the app.")
//
//    //‑‑ Parameters shown in Shortcuts
//    @Parameter(title: "Meeting Topic")
//    var topic: String
//
//    @Parameter(title: "Date", default: .now)
//    var date: Date
//
//    //‑‑ Main action
//    func perform() async throws -> some IntentResult {
//
//        let meeting = Meeting(topic: topic, date: date)
//        await MeetingManager.shared.add(meeting)
//
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        let when = formatter.string(from: date)
//
//        // Confirmation spoken / shown in Shortcuts
//        return .result(dialog: "Added “\(topic)” on \(when).")
//    }
//}
