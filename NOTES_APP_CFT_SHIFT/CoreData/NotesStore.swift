//
//  NotesStore.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import Foundation
import CoreData
import UIKit

final class NotesStore: NSObject {
    // MARK: - context
    private let context: NSManagedObjectContext
    //MARK: - FETCH RESULT CONTROLLER
    private var notesFetchedResultsController: NSFetchedResultsController<NotesCoreData>?
    //MARK: - DELEGATE
    weak var delegate: NotesDataProviderDelegate?
    // MARK: - INIT
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    private init (context: NSManagedObjectContext) {
        self.context = context
        super.init()
        FetchedResultsControllerSetup()
    }
    // MARK: - FetchedResultsControllerSetup
    private func FetchedResultsControllerSetup() {
        let fetchRequest = NSFetchRequest<NotesCoreData>(entityName: "NotesCoreData")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "noteId", ascending: false)]
        let context = self.context
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        self.notesFetchedResultsController = fetchedResultController
    }
    // MARK: - ADD NOTE
    func addNote(note: Note) throws {
        let NotesCoreData = NotesCoreData(context: context)
        NotesCoreData.noteId = note.id
        NotesCoreData.title = note.title
        NotesCoreData.note = note.note
        try context.save()
    }
    // MARK: - ADD NOTE
    func editNote(note: Note) throws {
        let fetchNotesCoreData = NotesCoreData.fetchRequest()
        fetchNotesCoreData.predicate = NSPredicate(format: "%K == %@",
                                                   #keyPath(NotesCoreData.noteId),
                                                   note.id as CVarArg)
        guard let noteToEdit = try context.fetch(fetchNotesCoreData).first else { return }
        noteToEdit.title = note.title
        noteToEdit.note = note.note
        try context.save()
    }
    
    // MARK: - REMOVE NOTE
    func deleteNote(noteId: UUID) throws {
        let noteRequest = NotesCoreData.fetchRequest()
        noteRequest.predicate = NSPredicate(format: "%K == %@",
                                            #keyPath(NotesCoreData.noteId),
                                            noteId as CVarArg)
        if let noteToRemove = try context.fetch(noteRequest).first {
            context.delete(noteToRemove)
        }
        try context.save()
    }
    // MARK: - REMOVE ALL
    func deleteAllNotes() throws {
        let noteRequest = NotesCoreData.fetchRequest()
        
        let notes = try context.fetch(noteRequest)
        notes.forEach{
            note in
            context.delete(note)
        }
        try context.save()
    }
    // MARK: - FETCH NOTE
    func fetchNote(noteId: UUID) throws -> Note? {
        let noteRequest = NotesCoreData.fetchRequest()
        noteRequest.predicate = NSPredicate(format: "%K == %@",
                                            #keyPath(NotesCoreData.noteId),
                                            noteId as CVarArg)
        if let note = try context.fetch(noteRequest).first {
            if let noteId = note.noteId, let title = note.title, let noteText = note.note {
                return Note(id: noteId, title: title, note: noteText)
            }
        }
        return nil
    }
    // MARK: - FETCH NOTES
    func fetchAllNotes() throws -> [Note]? {
        let noteRequest = NotesCoreData.fetchRequest()
        let notes = try context.fetch(noteRequest)
        return notes.compactMap{
            if let noteId = $0.noteId, let title = $0.title, let noteText = $0.note {
                return Note(id: noteId, title: title, note: noteText)
            }
            return nil
        }
    }
    // MARK: - destroyPersistentStore
    func destroyPersistentStore() {
        guard let firstStoreURL = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else {
            print("Missing first store URL - could not destroy")
            return
        }
        do {
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: firstStoreURL, ofType: "NotesDataModel", options: nil)
        } catch  {
            print("Unable to destroy persistent store: \(error) - \(error.localizedDescription)")
        }
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension NotesStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.notesStoreDidChange()
    }
}
