//
//  ViewController.swift
//  WorkList
//
//  Created by Максим Горячкин on 24.03.2022.
//

import UIKit
import CloudKit

class NoteViewController: UIViewController {
    
    var note: Note!
    var barButtonIsHidden = true
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .white
        view.text = note.noteBody
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(touchesEnd))
        return view
    }()
    
    private lazy var shareBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        setContstrains()
        navigationItem.title = note.name
        navigationItem.rightBarButtonItem = shareBarButton
        textView.delegate = self
    }
    
    @objc func touchesEnd() {
        textView.resignFirstResponder()
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    @objc func share() {
        guard let text = textView.text else { return }
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(activityVC, animated: true)
    }
    
    private func setContstrains() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
                                    ])
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        StorageManager.shared.saveNoteBody(note, text)
    }
}
