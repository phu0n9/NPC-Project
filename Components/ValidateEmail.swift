//
//  ValidateEmail.swift
//  NPC
//
//  Created by Le Nguyen on 10/09/2022.
//

import SwiftUI

extension String {
    // SwiftUI 5.0 and above
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
