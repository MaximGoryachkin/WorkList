//
//  StorageManager.swift
//  WorkList
//
//  Created by Максим Горячкин on 27.03.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WorkList")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print(error)
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: Fetch Data
    func fetchData(completion: (Result<[Note], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            let notes = try viewContext.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // MARK: Save Data
    func saveName(_ noteName: String, completion: (Note) -> Void) {
        let note = Note(context: viewContext)
        note.name = noteName
        
        completion(note)
        saveContext()
    }
    
    func saveNoteBody(_ note: Note, _ noteBody: String) {
        note.noteBody = noteBody
        saveContext()
    }
    
    // MARK: Delete Data
    func delete(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                print(error)
            }
        }
    }
}
