//
//  NoteCell.swift
//  SecureNoteApp
//
//  Created by ramil on 25.09.2020.
//

import SwiftUI

struct NoteCell: View {
    
    var isSecured: Bool
    var text: String
    
    var body: some View {
        Group {
            if isSecured {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "lock")
                            .foregroundColor(Color.red)
                    }
                    
                    Text(self.randomText(length: Int.random(in: 10...50)))
                        .blur(radius: 10)
                }
            } else {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "doc.text")
                            .foregroundColor(Color.blue)
                    }
                    
                    Text(text)
                }
            }
        }
    }
    
    func randomText(length: Int) -> String {
        let letters = "ABCDEFJKLMNOPQRSTVWXYZ       abCDEFJIKLMNOPQRSTVWYZ"
        return String((0..<length).map { _ in letters.randomElement() ?? " " })
    }
}
