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
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
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
        present(view, animated: true)
    }
    //MARK: - CONFIGURATION MENU SETUP
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration{
        
        let context = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { (action) -> UIMenu? in
            guard let cell = self.notesTable.cellForRow(at: indexPath) as? NotesTableCell else {
                return nil
            }
            let edit = UIAction(title: "Редактировать" ) { (_) in
                let view = EditNotesController()
                self.present(view,animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    //guard let uuid = cell.getUiid() else { return }
                    //self.viewModel.removeTracker(trackerId: uuid)
                }
                let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
                let alert = UIAlertController(title: "Вы действительно хотите удалить запись?", message: nil, preferredStyle: .actionSheet)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
            return UIMenu( children: [edit, deleteAction])
        }
        return context
    }
}

//MARK: - UITableViewDataSource
extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableCell.cellIdentifer, for: indexPath) as? NotesTableCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        cell.textLabel?.text = "dsdsd"
        cell.detailTextLabel?.text = "dsds"
        return cell
    }
    
}
//MARK: - UITableViewDelegate
extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = EditNotesController()
        present(view,animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(indexPath: indexPath)
    }
}
