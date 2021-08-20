//
//  UITextField+Extension.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 18/08/21.
//

import Foundation
import SwiftUI

extension UITextView {
    func selectedTextIndexes() -> (startIndex:String.Index,endIndex:String.Index)? {
        if let range = self.selectedTextRange {
            if !range.isEmpty {
                let location = self.offset(from: self.beginningOfDocument, to: range.start)
                let length = self.offset(from: range.start, to: range.end)

                let startIndex = self.text!.index(self.text!.startIndex, offsetBy: location)
                let endIndex = self.text!.index(startIndex, offsetBy: length)

                return (startIndex,endIndex)
            } else{
                print("empty")
            }
        }
        return nil
    }
}
