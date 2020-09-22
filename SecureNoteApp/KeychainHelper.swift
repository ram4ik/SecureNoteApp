//
//  KeychainHelper.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import Foundation

enum KeychainErrorType {
    case serviceError
    case badDataError
    case itemNotFoundError
    case unableToConvertStringError
}

struct KeychainError: Error {
    var message: String?
    var type: KeychainErrorType
    
    init(status: OSStatus, type: KeychainErrorType) {
        self.type = type
        
        if let errorMessage = SecCopyErrorMessageString(status, nil) {
            self.message = String(describing: errorMessage)
        } else {
            self.message = "Received status code: \(status)"
        }
    }
    
    init(type: KeychainErrorType) {
        self.type = type
    }
    
    init(message: String, type: KeychainErrorType) {
        self.message = message
        self.type = type
    }
}

class KeychainWrapper {
    func storeGenericPassword(account: String, service: String, password: String) throws {
        if password.isEmpty {
            try deleteGenericPasswordFor(account: account, service: service)
            return
        }
        
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data")
            throw KeychainError(type: .badDataError)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            break
        case errSecDuplicateItem:
            try updateGenericPasswordFor(account: account, service: service, password: password)
        default:
            throw KeychainError(status: status, type: .serviceError)
        }
    }
    
    func getGenericPasswordFor(account: String, service: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError(type: .itemNotFoundError)
        }
        
        guard status == errSecSuccess else {
            throw KeychainError(status: status, type: .serviceError)
        }
        
        guard let existingItem = item as? [String: Any],
              let valueData = existingItem[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: .utf8) else {
            throw KeychainError(type: .unableToConvertStringError)
        }
        
        return value
    }
    
    func updateGenericPasswordFor(account: String, service: String, password: String) throws {
        guard let passwordData = password.data(using: .utf8) else {
            print("error converting value to data")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        let attr: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attr as CFDictionary)
        
        guard status != errSecItemNotFound else {
            throw KeychainError(message: "Matching item not found", type: .itemNotFoundError)
        }
        
        guard status == errSecSuccess else {
            throw KeychainError(status: status, type: .serviceError)
        }
    }
    
    func deleteGenericPasswordFor(account: String, service: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError(status: status, type: .serviceError)
        }
    }
}
