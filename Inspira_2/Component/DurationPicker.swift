//
//  Duration.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 10/05/25.
//

import SwiftUI

//struct DurationPicker: View {
//    @Binding var duration: Int // total in minutes
//
//    var body: some View {
//        HStack {
//            Picker(selection: Binding(
//                get: { duration / 60 },
//                set: { duration = $0 * 60 + duration % 60 }
//            ), label: Text("Hours")) {
//                ForEach(0..<24) { hour in
//                    Text("\(hour) h").tag(hour)
//                }
//            }
//            .pickerStyle(.wheel)
//
//            Picker(selection: Binding(
//                get: { duration % 60 },
//                set: { duration = (duration / 60) * 60 + $0 }
//            ), label: Text("Minutes")) {
//                ForEach(0..<60) { minute in
//                    Text("\(minute) m").tag(minute)
//                }
//            }
//            .pickerStyle(.wheel)
//        }
//    }
//}

//struct DurationPicker: View {
//    @Binding var duration: Int // total in minutes
//
//    var body: some View {
//        HStack {
//            Picker(selection: Binding(
//                get: { duration / 60 },
//                set: { newHour in
//                    // If hour is set to 5, force minute to 0
//                    if newHour >= 5 {
//                        duration = 5 * 60
//                    } else {
//                        duration = newHour * 60 + (duration % 60)
//                    }
//                }
//            ), label: Text("Hours")) {
//                ForEach(0...5, id: \.self) { hour in
//                    Text("\(hour) h").tag(hour)
//                }
//            }
//            .pickerStyle(.wheel)
//
//            Picker(selection: Binding(
//                get: { duration % 60 },
//                set: { newMinute in
//                    let currentHour = duration / 60
//                    if currentHour == 5 {
//                        duration = 5 * 60 // lock to max 5 hours
//                    } else {
//                        duration = currentHour * 60 + newMinute
//                    }
//                }
//            ), label: Text("Minutes")) {
//                ForEach(0..<60, id: \.self) { minute in
//                    Text("\(minute) m").tag(minute)
//                }
//            }
//            .pickerStyle(.wheel)
//            
//            Picker(selection: Binding(
//                get: { duration % 60 },
//                set: { newSecond in
//                    let hours = duration / 3600
//                    let minutes = (duration % 3600) / 60
//                    let newDuration = hours * 3600 + minutes * 60 + newSecond
//                        duration = min(newDuration, 18000)
//                    }
//            ), label: Text("Seconds")) {
//                ForEach(0..<60) { second in
//                    Text("\(second) s").tag(second)
//                }
//            }
//            .pickerStyle(.wheel)
//        }
//    }
//}


//struct DurationPicker: View {
//    @Binding var duration: Int // total in seconds
//
//    var body: some View {
//        HStack {
//            // Hours Picker
//            Picker(selection: Binding(
//                get: { duration / 3600 },
//                set: { newHour in
//                    let cappedDuration = newHour * 3600 + (duration % 3600)
//                    duration = min(cappedDuration, 18000) // max 5 hours
//                }
//            ), label: Text("Hours")) {
//                ForEach(0...5, id: \.self) { hour in
//                    Text("\(hour) h").tag(hour)
//                }
//            }
//            .pickerStyle(.wheel)
//
//            // Minutes Picker
//            Picker(selection: Binding(
//                get: { (duration % 3600) / 60 },
//                set: { newMinute in
//                    let hours = duration / 3600
//                    let seconds = duration % 60
//                    let newDuration = hours * 3600 + newMinute * 60 + seconds
//                    duration = min(newDuration, 18000)
//                }
//            ), label: Text("Minutes")) {
//                ForEach(0..<60) { minute in
//                    Text("\(minute) m").tag(minute)
//                }
//            }
//            .pickerStyle(.wheel)
//
//            // Seconds Picker
//            Picker(selection: Binding(
//                get: { duration % 60 },
//                set: { newSecond in
//                    let hours = duration / 3600
//                    let minutes = (duration % 3600) / 60
//                    let newDuration = hours * 3600 + minutes * 60 + newSecond
//                    duration = min(newDuration, 18000)
//                }
//            ), label: Text("Seconds")) {
//                ForEach(0..<60) { second in
//                    Text("\(second) s").tag(second)
//                }
//            }
//            .pickerStyle(.wheel)
//        }
//    }
//}

struct DurationPicker: View {
    @Binding var duration: Int // total in seconds

    var body: some View {
        HStack {
            Picker(selection: Binding(
                get: { duration / 3600 },
                set: { newHour in
                    let minutes = (duration % 3600) / 60
                    let seconds = duration % 60
                    let newDuration = newHour * 3600 + minutes * 60 + seconds
                    duration = min(newDuration, 18000)
                }
            ), label: Text("Hours")) {
                ForEach(0...5, id: \.self) { hour in
                    Text("\(hour) h").tag(hour)
                }
            }
            .pickerStyle(.wheel)

            Picker(selection: Binding(
                get: { (duration % 3600) / 60 },
                set: { newMinute in
                    let hours = duration / 3600
                    let seconds = duration % 60
                    let newDuration = hours * 3600 + newMinute * 60 + seconds
                    duration = min(newDuration, 18000)
                }
            ), label: Text("Minutes")) {
                ForEach(0..<60, id: \.self) { minute in
                    Text("\(minute) m").tag(minute)
                }
            }
            .pickerStyle(.wheel)

            Picker(selection: Binding(
                get: { duration % 60 },
                set: { newSecond in
                    let hours = duration / 3600
                    let minutes = (duration % 3600) / 60
                    let newDuration = hours * 3600 + minutes * 60 + newSecond
                    duration = min(newDuration, 18000)
                }
            ), label: Text("Seconds")) {
                ForEach(0..<60) { second in
                    Text("\(second) s").tag(second)
                }
            }
            .pickerStyle(.wheel)
        }
    }
}
