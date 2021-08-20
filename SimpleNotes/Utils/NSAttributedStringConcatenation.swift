//
//  NSAttributedStringConcatenation.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 19/08/21.
//

import Foundation

public class NSAttributedStringConcatenation {
    
    static func concat(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {

        let a = lhs.mutableCopy() as! NSMutableAttributedString
        let b = rhs.mutableCopy() as! NSMutableAttributedString

        a.append(b)

        return a.copy() as! NSAttributedString
    }

//    static func concat(lhs: NSAttributedString, rhs: String) -> NSAttributedString {
//
//        let a = lhs.mutableCopy() as! NSMutableAttributedString
//        let b = NSMutableAttributedString(string: rhs)
//
//        let c =  a.append(b)
//
//        return a.copy() as! NSAttributedString
//    }
//
//    static func concat(lhs: String, rhs: NSAttributedString) -> NSAttributedString {
//
//        let a = NSMutableAttributedString(string: lhs)
//        let b = lhs.mutableCopy() as! NSMutableAttributedString
//
//        let c =  a.append(b)
//
//        return a.copy() as! NSAttributedString
//    }

}
