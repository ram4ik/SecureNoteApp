//
//  BioAuth.swift
//  SecureNoteApp
//
//  Created by ramil on 22.09.2020.
//

import LocalAuthentication

class BioAuth {
    
    static func tryBioAuth(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reasson = "Authenticate to unlock"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasson) { (authSuccess, err) in
                guard err == nil else {
                    print("Failed in biometric auth: \(err?.localizedDescription)")
                    completion(false)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(authSuccess)
                }
            }
            
        } else {
            if let errorString = error?.localizedDescription {
                print("Biometric error \(errorString)")
            }
            completion(false)
        }
    }
    
    static func biometricAuthSupported() -> Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
