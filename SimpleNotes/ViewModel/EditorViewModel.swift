//
//  EditorViewModel.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 19/08/21.
//

import Foundation
import CoreData
import SwiftUI

class EditorViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    lazy var context = container.viewContext
    
    init() {
        self.container = NSPersistentContainer(name: "SimpleNotes")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
    
    func addBullet(stringList: [String],
                   font: UIFont,
                   bullet: String = "\u{2022}",
                   indentation: CGFloat = 20,
                   lineSpacing: CGFloat = 2,
                   paragraphSpacing: CGFloat = 12,
                   textColor: UIColor = .black,
                   bulletColor: UIColor = .black) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
    
    func addNumber(stringList: [String],
                   font: UIFont,
                   indentation: CGFloat = 20,
                   lineSpacing: CGFloat = 2,
                   paragraphSpacing: CGFloat = 12,
                   textColor: UIColor = .black) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let numberList = NSMutableAttributedString()
        for (index, string) in stringList.enumerated() {
            let formattedString = "\(index+1). \(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            numberList.append(attributedString)
        }
        
        return numberList
    }
    
    func addItem(title: String, attributedNote: NSAttributedString) {
        let newItem = Item(context: context)
        newItem.title = title
        newItem.note = attributedNote
        newItem.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateItem(id: NSManagedObjectID ,title: String, attributedNote: NSAttributedString){
        do {
            if let object = context.object(with: id) as? Item {
                object.title = title
                object.note = attributedNote
                try context.save()
            }
        } catch _ {
            // error handling
            fatalError("Unresolved error")
        }
    }
    
    
    func deleteItem(id: NSManagedObjectID){
        do {
            let object = context.object(with: id)
            context.delete(object)
            try context.save()
        } catch _ {
            // error handling
            fatalError("Unresolved error")
        }
    }
    
}
