//
//  NotesTableViewController.swift
//  WorkList
//
//  Created by Максим Горячкин on 24.03.2022.
//

import CoreData
import UIKit

protocol NotesTableViewControllerProtocol {
    func reloadData(with note: Note)
}

class NotesTableViewController: UITableViewController {
    private var notes: [Note] = []
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"),
                                    style: .done,
                                    target: self,
                                    action: #selector(addNewNote))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Work List"
        navigationItem.rightBarButtonItem = rightBarButton
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !notes.isEmpty {
            navigationItem.leftBarButtonItem = editButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var configure = cell.defaultContentConfiguration()
        configure.text = notes[indexPath.row].name
        
        cell.contentConfiguration = configure
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        StorageManager.shared.delete(notes[indexPath.row])
        notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        if notes.isEmpty {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = NoteViewController()
        noteVC.note = notes[indexPath.row]
        show(noteVC, sender: nil)
    }
    
    private func getData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let notes):
                self.notes = notes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func addNewNote() {
        let newNoteVC = NewNoteViewController()
        newNoteVC.delegate = self
        present(newNoteVC, animated: true)
    }
}

extension NotesTableViewController: NotesTableViewControllerProtocol {
    func reloadData(with note: Note) {
        notes.append(note)
        tableView.insertRows(at: [IndexPath(row: self.notes.count - 1, section: .zero)], with: .automatic)
        navigationItem.leftBarButtonItem = editButtonItem
    }
}
