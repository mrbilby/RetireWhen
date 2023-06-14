//
//  dismissGesture.swift
//  RetireWhen
//
//  Created by James Bailey on 14/06/2023.
//

import Foundation
import SwiftUI

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
