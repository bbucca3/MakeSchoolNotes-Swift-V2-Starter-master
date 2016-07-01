//
//  DisplayNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift
//Displays each note


class DisplayNoteViewController: UIViewController {

    
    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    var note: Note?
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //using the optional binding technique to unwrap the value in the note property and storing the actual value (if it exists) in a local variable named note.
        
        if let note = note {
            // This code will only execute if the note property was not nil. We are setting the text field and text view properties to the note's title and content, respectively
            noteTitleTextField.text = note.title
            noteContentTextView.text = note.content
        } else {
            // This code is executed if the note property was nil. This happens if we are creating a new note, so we set the text field and text view to empty strings to ensure that our users can immediately begin typing their new note.
            noteTitleTextField.text = ""
            noteContentTextView.text = ""
        }
    }
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        //border around the input box
        noteContentTextView.layer.cornerRadius = 5
        noteContentTextView.layer.borderColor = UIColor.blueColor().CGColor
        noteContentTextView.layer.borderWidth = 1
        self.view.addSubview(noteContentTextView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listNotesTableViewController = segue.destinationViewController as! ListNotesTableViewController
        if segue.identifier == "Save" {
            // if note exists, update title and content
            if let note = note {
                // 1
                let newNote = Note()
                newNote.title = noteTitleTextField.text ?? ""
                newNote.content = noteContentTextView.text ?? ""
                RealmHelper.updateNote(note, newNote: newNote)
            } else {
                // if note does not exist, create new note
                let note = Note()
                note.title = noteTitleTextField.text ?? ""
                note.content = noteContentTextView.text ?? ""
                note.modificationTime = NSDate()
                // 2
                RealmHelper.addNote(note)
            }
            // 3 list of notes
            listNotesTableViewController.notes = RealmHelper.retrieveNotes()
        }
    }

}
