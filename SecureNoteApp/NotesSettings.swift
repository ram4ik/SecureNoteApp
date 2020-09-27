//
//  NotesSettings.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import SwiftUI
import CoreData

struct NotesSettings: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var showEnterPassword = false
    @State private var passwordSuccess = false
    @State private var showCreatePassword = false
    
    var body: some View {
        VStack {
            Color.clear.sheet(isPresented: $showCreatePassword, content: {
                CreateNewPassword(createPassword: self.$showCreatePassword)
            }).frame(width: 100, height: 20)
            
            Button("Update password") {
                if PasswordHelper.isPasswordBlank {
                    self.showCreatePassword.toggle()
                } else {
                    self.showEnterPassword.toggle()
                }
            }.sheet(isPresented: $showEnterPassword, content: {
                EnterPasswordScreen(showUnlockScreen: self.$showEnterPassword, authSuccess: self.$passwordSuccess)
                    .onDisappear() {
                        if self.passwordSuccess {
                            self.showCreatePassword.toggle()
                        }
                    }
            })
            
            Divider()
            
            Button(action: {
                self.deleteSecureRecords()
                PasswordHelper.deletePassword()
            }, label: {
                Text("Reset Password")
            })
        }
    }
    
    private func deleteSecureRecords() {
        let request: NSFetchRequest<SecureNote> = SecureNote.fetchRequest()
        request.predicate = NSPredicate.init(format: "isSecured==1")
        
        do {
            let objects = try moc.fetch(request)
            for item in objects {
                moc.delete(item)
            }
            
            try moc.save()
        } catch {
            print("\(error)")
        }
    }
}

struct NotesSettings_Previews: PreviewProvider {
    static var previews: some View {
        NotesSettings()
    }
}
