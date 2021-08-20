//
//  NSRange.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 18/08/21.
//

import Foundation
import UIKit

public extension NSRange {

    /// Range with 0 location and length
    static var zero: NSRange {
        return NSRange(location: 0, length: 0)
    }

    var firstCharacterRange: NSRange {
        return NSRange(location: location, length: 1)
    }

    var lastCharacterRange: NSRange {
        return NSRange(location: location + length, length: 1)
    }

    var nextPosition: NSRange {
        return NSRange(location: location + 1, length: 0)
    }

    var endLocation: Int {
        return location + length
    }

    /// Converts the range to `UITextRange` in given `UITextInput`. Returns nil if the range is invalid in the `UITextInput`.
    /// - Parameter textInput: UITextInput to convert the range in.
    func toTextRange(textInput: UITextInput) -> UITextRange? {
        guard let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
              let rangeEnd = textInput.position(from: rangeStart, offset: length)
        else { return nil }
        
        return textInput.textRange(from: rangeStart, to: rangeEnd)
    }

    /// Checks if the range is valid in given `UITextInput`
    /// - Parameter textInput: UITextInput to validate the range in.
    func isValidIn(_ textInput: UITextInput) -> Bool {
        guard location > 0 else { return false }
        let end = location + length
        let contentLength = textInput.offset(from: textInput.beginningOfDocument, to: textInput.endOfDocument)
        return end < contentLength
    }

    /// Shifts the range with given shift value
    /// - Parameter shift: Int value to shift range by.
    /// - Returns: Shifted range with same length.
    /// - Important: The shifted range may or may not be valid in a given string. Validity of shifted range must always be checked at the usage site.
    func shiftedBy(_ shift: Int) -> NSRange {
        return NSRange(location: self.location + shift, length: length)
    }
}
