//
//  AddNewNote.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import SwiftUI

struct AddNewNote: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Binding var showAdd: Bool
    
    @State private var createPassword = false
    @State private var noteText: String = ""
    @State private var isSecured: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Create new note.")
                .font(.title)
                .padding(.top, 30)
            
            TextField("Note", text: $noteText)
            
            Divider()
            
            Button {
                self.isSecured.toggle()
                if self.isSecured == true && !BioAuth.biometricAuthSupported() && PasswordHelper.isPasswordBlank {
                    self.createPassword.toggle()
                    print("create new password called")
                }
            } label: {
                HStack {
                    Text("Secure Note?")
                        .foregroundColor(.primary)
                    
                    Group {
                        if isSecured {
                            Image(systemName: "checkmark.shield")
                        } else {
                            Image(systemName: "shield")
                        }
                    }
                    .font(.title)
                }
            }.sheet(isPresented: $createPassword) {
                CreateNewPassword(createPassword: self.$createPassword).onDisappear() {
                    if PasswordHelper.isPasswordBlank {
                        self.isSecured.toggle()
                    }
                }
            }
            
            HStack {
                Button {
                    self.saveNewNote()
                    self.showAdd.toggle()
                } label: {
                    Text("Save")
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.blue.opacity(0.4)))
                        .contentShape(Rectangle())
                }

            }.padding(.top, 30)
            
            Spacer()
        }.padding()
    }
    
    private func saveNewNote() {
        let noteContext = SecureNote(context: self.moc)
        noteContext.id = UUID()
        noteContext.created = Date()
        noteContext.note = self.noteText
        noteContext.isSecured = self.isSecured
        
        do {
            try self.moc.save()
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}

