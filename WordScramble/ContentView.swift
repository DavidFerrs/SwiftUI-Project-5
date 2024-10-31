//
//  ContentView.swift
//  WordScramble
//
//  Created by David Ferreira on 30/10/24.
//

import SwiftUI

struct ContentView: View {

    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    var calculateScore: Int {
        var score = 0
        for word in usedWords {
            score += word.count - 2
        }
        return score
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section {
                        TextField("Enter your new word", text: $newWord)
                            .textInputAutocapitalization(.never)
                    }
                    
                    Section {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count - 2).circle")
                                Text(word)
                            }
                        }
                    }
                    
                }
                .navigationTitle(rootWord)
                .toolbar(){
                    Button("Restart", action: startGame)
                }
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) { } message: {
                    Text(errorMessage)
                }
                
                Text("YourScore is: \(calculateScore)")
                    .font(.largeTitle)
            }
            
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word is too short", message: "Be creative, use 3 letters or more!")
            return
        }
        
        guard isDiferrentFromRoot(word: answer) else {
            wordError(title: "Word is equal to root", message: "You can't use the root word")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used alredy", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
            
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                restart()
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func restart() {
        usedWords = [String]()
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isDiferrentFromRoot(word: String) -> Bool {
        word.compare(rootWord, options: .caseInsensitive) != .orderedSame
    }
    
    func isLongEnough(word: String) -> Bool {
        word.count >= 3
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
