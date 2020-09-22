//
//  CreateNewPassword.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import SwiftUI

struct CreateNewPassword: View {
    
    @Binding var createPassword: Bool
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Text("Create new password")
                .font(.title)
            
            Text("Enter password to secure note.")
            
            SecureField("Enter password", text: $password)
            Divider()
            SecureField("Confirm password", text: $confirmPassword)
            Divider()
            
            if password.isEmpty {
                Text("Password can't be empty")
                    .foregroundColor(.red)
            }
            
            if password != confirmPassword {
                Text("Password don't match")
                    .foregroundColor(.red)
            }
            
            Button {
                PasswordHelper.updateStorePassword(self.password)
                self.createPassword.toggle()
            } label: {
                Text("Save")
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.blue.opacity(0.4)))
                    .contentShape(Rectangle())
            }.disabled((password != confirmPassword) || (password.isEmpty))
            Spacer()

        }.padding()
    }
}
