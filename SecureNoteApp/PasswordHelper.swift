//
//  PasswordHelper.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import Foundation

class PasswordHelper {
    
    private static let account = "SecureNote"
    private static let service = "UnlockNotePassword"
    
    static var isPasswordBlank: Bool {
        getStorePassword() == ""
    }
    
    static func getStorePassword() -> String {
        let keychainWrapper = KeychainWrapper()
        if let password = try? keychainWrapper.getGenericPasswordFor(account: account, service: service) {
            return password
        }
        return ""
    }
    
    static func updateStorePassword(_ password: String) {
        let keychainWrapper = KeychainWrapper()
        
        do {
            try keychainWrapper.storeGenericPassword(account: account, service: service, password: password)
        } catch let error as KeychainError {
            print("Error setting password \(error.message ?? "no message")")
        } catch {
            print("An error occured setting the password")
        }
    }
    
    static func validatePassword(_ password: String) -> Bool {
        let currentPassword = getStorePassword()
        return password == currentPassword
    }
    
    static func changePassword(currentPassword: String, newPassword: String) -> Bool {
        guard validatePassword(currentPassword) == true else { return false }
        updateStorePassword(newPassword)
        return true
    }
    
    static func deletePassword() {
        let keychainWrapper = KeychainWrapper()
        
        do {
            try keychainWrapper.deleteGenericPasswordFor(account: account, service: service)
        } catch {
            print("Error occured while deleting password \(error.localizedDescription)")
        }
    }
}
