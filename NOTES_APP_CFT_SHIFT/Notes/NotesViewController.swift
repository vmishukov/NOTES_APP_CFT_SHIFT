//
//  ViewController.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import UIKit

class NotesViewController: UIViewController {
    //MARK: - UI
    private lazy var trackerNothingFoundImage : UIImageView = {
        let ImageView = UIImageView()
        let picture = UIImage(systemName: "checkmark")
        ImageView.image = picture
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ImageView)
        return ImageView
    }()
    
    private lazy var notesTable: UITableView = {
        let tableView = UITableView()
        tableView.register(NotesTableCell.self, forCellReuseIdentifier: NotesTableCell.cellIdentifer)
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        return tableView
    }()
    //MARK: - VIEW MODEL
    private var viewModel: NotesViewModel!
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NotesViewModel()
        bind()
        view.backgroundColor = .systemBackground
        constraitsNotesTable()
        navBarItem()
    }
    //MARK: - NAVBAR SETUP
    private func navBarItem() {
        if let navBar = navigationController?.navigationBar {
            let letfButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(Self.didTapAddNoteButton))
            navBar.topItem?.title = "Заметки"
            navBar.prefersLargeTitles = true
            navigationItem.leftBarButtonItem = letfButton
            
            let rightButton = UIBarButtonItem(
                barButtonSystemItem: .trash,
                target: self,
                action: #selector(didTapDeleteAllButton)
            )
            navBar.topItem?.setRightBarButton(rightButton, animated: false)
        }
    }
    //MARK: - BINDING SETUP
    private func bind() {
        viewModel.notesBinding = { [weak self]_ in
            guard let self = self else { return }
            self.notesTable.reloadData()
        }
    }
    //MARK: - constraits
    private func constraitsNotesTable() {
        NSLayoutConstraint.activate([
            notesTable.topAnchor.constraint(equalTo: view.topAnchor),
            notesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            notesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    //MARK: - OBJC
    @objc private func didTapAddNoteButton(_ sender: UIButton) {
        let view = CreateNotesViewController()
        view.delegate = self
        present(view, animated: true)
    }
    
    @objc private func didTapDeleteAllButton(_ sender: UIButton) {
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.viewModel.deleteAllNotes()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let alert = UIAlertController(title: "Вы действительно хотите удалить ВСЕ записи?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    //MARK: - CONFIGURATION MENU SETUP
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration{
        
        let context = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { (action) -> UIMenu? in
            guard let cell = self.notesTable.cellForRow(at: indexPath) as? NotesTableCell else {
                return nil
            }
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    guard let uuid = cell.noteId else { return }
                    self.viewModel.deleteNote(noteId: uuid)
                }
                let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
                let alert = UIAlertController(title: "Вы действительно хотите удалить запись?", message: nil, preferredStyle: .actionSheet)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
            return UIMenu( children: [deleteAction])
        }
        return context
    }
}

//MARK: - UITableViewDataSource
extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableCell.cellIdentifer, for: indexPath) as? NotesTableCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        cell.noteId = viewModel.notes[indexPath.row].id
        cell.textLabel?.text = viewModel.notes[indexPath.row].title
        cell.detailTextLabel?.text = viewModel.notes[indexPath.row].note
        return cell
    }
}
//MARK: - UITableViewDelegate
extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = EditNotesController()
        view.delegate = self
        present(view,animated: true)
        view.setupEdit(title: viewModel.notes[indexPath.row].title, note: viewModel.notes[indexPath.row].note, noteId: viewModel.notes[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(indexPath: indexPath)
    }
}

//MARK: - CreateNotesDelegate
extension NotesViewController: CreateNotesDelegate {
    func createNewNote(note: Note) {
        viewModel.addNote(note: note)
    }
}
//MARK: -
extension NotesViewController: EditNotesDelegate {
    func editNote(editedNote: Note) {
        viewModel.editNote(editedNote: editedNote)
    }
}
