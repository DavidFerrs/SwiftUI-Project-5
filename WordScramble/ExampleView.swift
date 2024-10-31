//
//  ExampleView.swift
//  WordScramble
//
//  Created by David Ferreira on 30/10/24.
//

import SwiftUI

struct ExampleView: View {
    let people = ["Finn", "Fiona", "Jake", "Bimbo"]
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
    func testBundles() {
        if let fileURL = Bundle.main.url(forResource: "somfile", withExtension: "txt"){
            if let fileContents = try? String(contentsOf: fileURL){
                
            }
        }
    }
    
    func testStrings() {
        let input = """
        a
        b
        c
        """
        let letters = input.components(separatedBy: "\n")
        let letter = letters.randomElement()
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let word = "swift"
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRang = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let allGood = misspelledRang.location == NSNotFound
    }
}

#Preview {
    ExampleView()
}
