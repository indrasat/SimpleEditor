//
//  EditorView.swift
//  SimpleNotes
//
//  Created by Indra Kurniawan on 17/08/21.
//

import SwiftUI
import CoreData


struct EditorView: View {
    @StateObject var viewModel = EditorViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    //let persistenceController = PersistenceController.shared
    
    @State var titleState = String()
    @State var attributedNoteState =  NSAttributedString()
    @State private var selectedText: String = ""
    @State private var backToRoot: Bool = false
    @State var didAppear = false
    
    var id: NSManagedObjectID!
    var title: String!
    var attributedNote: NSAttributedString!
    
    private var titlePlaceholder: String = "Add Title Here"
    private var notePlaceholder: String = "Add Note Here"
    

    init(id: NSManagedObjectID?, title: String?, attributedNote: NSAttributedString? ){
        self.id = id

        if let title = title {
            self.title = title
        } else {
            self.title = titlePlaceholder
        }

        if let attributedNote = attributedNote {
            self.attributedNote = attributedNote
        } else {
            self.attributedNote =  NSAttributedString(string: notePlaceholder)
        }
    }
    
    var body: some View {
        
        VStack{
            ScrollView{
                TextField(titlePlaceholder, text: $titleState)
                    .foregroundColor(self.titleState == titlePlaceholder ? .gray : .primary)
                    .onTapGesture {
                        if self.titleState == titlePlaceholder {
                            self.titleState = ""
                        }
                    }
                
                
                TextView(attributedString: $attributedNoteState, fixedWidth: .infinity)
                    .foregroundColor(self.attributedNoteState == NSAttributedString(string: notePlaceholder) ? .gray : .primary)
                    .onTapGesture {
                        if self.attributedNoteState == NSAttributedString(string: notePlaceholder) {
                            self.attributedNoteState = NSAttributedString()
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification)) { obj in
                        if let textEditor = obj.object as? UITextView {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let selectedTextIndexes = textEditor.selectedTextIndexes() {
                                    let startIndex = selectedTextIndexes.startIndex
                                    let endIndex = selectedTextIndexes.endIndex
                                    if let selectedText = textEditor.text?.substring(with: startIndex..<endIndex) {
                                        self.selectedText = selectedText
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
            }
            .environment(\.managedObjectContext, viewModel.context)
            
            HStack{
                Button(action: {
                    if let font = UIFont(name: "Avenir", size: 12) {
                        let selectedText = selectedText == "" ? $attributedNoteState.wrappedValue.string : selectedText
                        attributedNoteState = NSAttributedString(string: selectedText, attributes: [ NSAttributedString.Key.font: font.bold() ])
                        
                    }
                }) {
                    Image("Bold").resizable().frame(width: 20, height: 20, alignment: .center)
                }
                .frame(minWidth:0, maxWidth: .infinity)
                
                Button(action: {
                    if let font = UIFont(name: "Avenir", size: 12) {
                        let selectedText = selectedText == "" ? $attributedNoteState.wrappedValue.string : selectedText
                        attributedNoteState = NSAttributedString(string: selectedText, attributes: [ NSAttributedString.Key.font: font.italics() ])
                        
                    }
                }) {
                    Image("Italic").resizable().frame(width: 20, height: 20, alignment: .center)
                }
                .frame(minWidth:0, maxWidth: .infinity)
                
                Button(action: {
                    if let font = UIFont(name: "Avenir", size: 12) {
                        let selectedText = selectedText == "" ? $attributedNoteState.wrappedValue.string : selectedText
                        attributedNoteState = viewModel.addBullet(stringList: selectedText.components(separatedBy: "\n"), font: font)
                        
                    }
                }) {
                    Image("UnOrdered").resizable().frame(width: 20, height: 20, alignment: .center)
                }
                .frame(minWidth:0, maxWidth: .infinity)
                
                Button(action: {
                    if let font = UIFont(name: "Avenir", size: 12) {
                        let selectedText = selectedText == "" ? $attributedNoteState.wrappedValue.string : selectedText
                        attributedNoteState = viewModel.addNumber(stringList: selectedText.components(separatedBy: "\n"), font: font)
                        
                    }
                }) {
                    Image("Ordered").resizable().frame(width: 20, height: 20, alignment: .center)
                }
                .frame(minWidth:0, maxWidth: .infinity)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let id =  self.id {
                        Button("Save", action: {
                            viewModel.updateItem(id: id, title: titleState, attributedNote: attributedNoteState)
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                    } else {
                        Button("Save", action: {
                            viewModel.addItem(title: titleState, attributedNote: attributedNoteState)
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        })
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    if let id =  self.id {
                        Button("Delete", action: {
                            viewModel.deleteItem(id: id)
                            presentationMode.wrappedValue.dismiss()

                        })
                    }
                }
            }
            
            
            
        }
        .onAppear(){
            if !didAppear {
                self.titleState = self.title
                self.attributedNoteState = self.attributedNote
                didAppear = true
            }
        }
    }
    
}

