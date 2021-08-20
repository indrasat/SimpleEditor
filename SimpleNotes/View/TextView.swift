//
//  TextView.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 19/08/21.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var attributedString: NSAttributedString
    var fixedWidth: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("pre content size update: \(textView.contentSize)") // width is over limit
            let newSize = textView.sizeThatFits(CGSize(width: parent.fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            textView.contentSize = CGSize(width: max(newSize.width, parent.fixedWidth), height: newSize.height)
            var attributes =  [NSAttributedString.Key: Any] ()
            let font = UIFont(name: "Avenir", size: 12)
//            parent.$attributedString.wrappedValue.enumerateAttributes(in: NSRange(location: 0, length: parent.attributedString.string.count), options: []) { (dict, range, value) in
//                if dict.keys.contains(.font) {
//                    attributes[NSAttributedString.Key.font] = font?.bold
//                }
//            }
            
            parent.$attributedString.wrappedValue = NSAttributedString(string:textView.text, attributes: attributes)
            print("post content size update: \(textView.contentSize)") // width is updated
        }
    }
    
    
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        textView.attributedText = self.attributedString
        
    }
}
