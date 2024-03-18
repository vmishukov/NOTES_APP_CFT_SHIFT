//
//  EditNotesDelegate.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 18.03.2024.
//

import Foundation

protocol EditNotesDelegate: AnyObject {
    func editNote(editedNote: Note)
}
