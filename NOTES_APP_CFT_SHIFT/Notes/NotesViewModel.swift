//
//  EditNotesViewModel.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import Foundation

final class NotesViewModel {
    // MARK: - Private
    private(set) var notes: [Note] = [] {
        didSet {
            notesBinding?(notes)
        }
    }
    private var dataProvider: NotesStore
    // MARK: - Binding
    var notesBinding: Binding<[Note]>?
    
    // MARK: - Init
    init() {
        self.dataProvider = NotesStore()
        self.dataProvider.delegate = self
        setNotes()
    }
    // MARK: - PUBLIC FUNC
    public func addNote(note: Note) {
        do {
            try dataProvider.addNote(note: note)
        } catch {
            assertionFailure("\(error)")
        }
    }
    public func deleteNote(noteId: UUID) {
        do {
            try dataProvider.deleteNote(noteId: noteId)
        } catch {
            assertionFailure("\(error)")
        }
    }
    public func deleteAllNotes() {
        do {
            try dataProvider.deleteAllNotes()
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    public func fetchNote(noteId: UUID) throws -> Note? {
        do {
            return try dataProvider.fetchNote(noteId: noteId)
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }
    // MARK: - private
    private func setNotes() {
        do {
            if let notes = try dataProvider.fetchAllNotes() {
                self.notes = notes
            }
        } catch {
            assertionFailure("\(error)")
        }
    }
}
// MARK: - NotesDataProviderDelegate
extension NotesViewModel: NotesDataProviderDelegate {
    func notesStoreDidChange() {
        setNotes()
    }
}
