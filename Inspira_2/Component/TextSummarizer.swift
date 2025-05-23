//
//  TextSummarizer.swift
//  Inspira_2
//
//  Created by Andrea Octaviani on 13/05/25.
//

import SwiftUI
import Foundation
import NaturalLanguage

func summarizeText(from text: String, completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        let sentences = text
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var rankedSentences: [(sentence: String, score: Int)] = []
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        
        for sentence in sentences {
            tagger.string = sentence
            let recognizer = NLLanguageRecognizer()
            recognizer.processString(sentence)
            let language = recognizer.dominantLanguage ?? .english
            tagger.setLanguage(language, range: sentence.startIndex..<sentence.endIndex)
            
            var score = 0
            tagger.enumerateTags(in: sentence.startIndex..<sentence.endIndex, unit: .word, scheme: .lexicalClass) { tag, _ in
                if tag == .noun || tag == .verb {
                    score += 1
                }
                return true
            }
            rankedSentences.append((sentence, score))
        }
        
        let bestSentences = rankedSentences
            .sorted(by: { $0.score > $1.score })
            .prefix(5)
            .map { $0.sentence }
        
        let result = bestSentences.map { "• \($0)" }.joined(separator: "\n\n")
        
        DispatchQueue.main.async {
            completion(result.isEmpty ? "No important sentences found." : result)
        }
    }
}
