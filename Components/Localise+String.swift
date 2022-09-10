//
//  Localise+String.swift
//  NPC
//
//  Created by Le Nguyen on 11/09/2022.
//

import SwiftUI

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
