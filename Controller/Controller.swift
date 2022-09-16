//
//  Controller.swift
//  NPC
//
//  Created by Le Nguyen on 10/09/2022.
//

import SwiftUI

class Controller: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published private(set) var validationMessage: String?
    
    var inputValid: Bool {
        validationMessage == nil
    }
    
    init() {
        // you subscribe to any changes to the email field input
        $email
        // you ignore the first empty value that it gets initialised with
            .dropFirst()
        // you give the user a bit of time to finish typing
            .debounce(for: 0.6, scheduler: RunLoop.main)
        // you get rid of duplicated inputs as they do not change anything in terms of validation
            .removeDuplicates()
        // you validate the input string and in case of problems publish an error message
            .map { input in
                guard !input.isEmpty else {
                    return "Email cannot be left empty"
                }
                
                // Validator most case, call check regrex function
                guard input.isValidEmail else {
                    return "Email is not valid"
                }
        // in case the input is valid the error message is nil
                return nil
            }
        // you publish the error message for the view to react to
            .assign(to: &$validationMessage)
        
        // Password validation
        $password
            .dropFirst()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                guard !input.isEmpty else {
                    return "Password cannot be left empty"
                }
                guard input.isValidPassword else {
                    return "Password is not valid"
                }
//                guard inputelse {
//                        return "Password do not match"
//                    }
                return nil
            }
            .assign(to: &$validationMessage)
    }
}
