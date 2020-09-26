//
//  NoteDetailView.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import SwiftUI

struct NoteDetailView: View {
    var note: SecureNote
    
    @State private var showUnlock = false
    @State private var authSuccess = false
    
    var body: some View {
        VStack {
            if note.isSecured {
                if !authSuccess {
                    VStack {
                        Text("This is a secured note.")
                        Button(action: {
                            BioAuth.tryBioAuth { (success) in
                                if success {
                                    self.authSuccess.toggle()
                                } else {
                                    self.showUnlock.toggle()
                                }
                            }
                        }, label: {
                            Text("Unlock")
                        }).sheet(isPresented: $showUnlock, content: {
                            EnterPasswordScreen(showUnlockScreen: self.$showUnlock, authSuccess: self.$authSuccess)
                        })
                        
                        Spacer()
                    }
                } else {
                    VStack {
                        Text(note.note ?? "")
                        Spacer()
                    }
                }
            } else {
                VStack {
                    Text(note.note ?? "")
                    Spacer()
                }
            }
        }.padding()
    }
}
