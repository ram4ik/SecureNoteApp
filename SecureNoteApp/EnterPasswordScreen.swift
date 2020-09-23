//
//  EnterPasswordScreen.swift
//  SecureNoteApp
//
//  Created by ramil on 23.09.2020.
//

import SwiftUI

struct EnterPasswordScreen: View {
    
    @Binding var showUnlockScreen: Bool
    @Binding var authSuccess: Bool
    
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Enter Password")
                .font(.title)
            
            Text("Enter Password to Unlock note.")
            
            SecureField("Enter password...", text: $password)
            Divider()
            
            Button {
                print(self.password)
                self.authSuccess = PasswordHelper.validatePassword(self.password)
                self.showUnlockScreen.toggle()
            } label: {
                Text("Unlock")
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.blue.opacity(0.4)))
                    .contentShape(Rectangle())
            }
            Spacer()
        }.padding()
    }
}
