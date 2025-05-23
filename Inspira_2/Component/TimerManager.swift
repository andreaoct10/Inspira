//
//  TimerManager.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 13/05/25.
//

import Foundation
import Combine
import AVFoundation

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    @Published private(set) var isRunning = false
    private var timer: DispatchSourceTimer?
    private var audioPlayer: AVAudioPlayer?
    
    init(initialTime: Int) {
        self.timeRemaining = initialTime
    }
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        timer?.schedule(deadline: .now(), repeating: 1.0)
        
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                DispatchQueue.main.async {
                    self.timeRemaining -= 1
                }
            } else {
                self.pause()
                DispatchQueue.main.async {
                    self.playSound()
                }
            }
        }
        timer?.resume()
    }
    
    func pause() {
        timer?.cancel()
        timer = nil
        DispatchQueue.main.async {
            self.isRunning = false
        }
    }
    
    func reset(to newTime: Int) {
        pause()
        timeRemaining = newTime
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "ringtone", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
}
