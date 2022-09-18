/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

import SwiftUI

class UserValidationControl: ObservableObject {
    
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
                return nil
            }
            .assign(to: &$validationMessage)
    }
}
