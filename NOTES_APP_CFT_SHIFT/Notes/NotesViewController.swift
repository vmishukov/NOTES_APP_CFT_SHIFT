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
    
    private lazy var notesTabler: UITableView = {
        let tableView = UITableView()
        
        
        return tableView
    }()
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navBarItem()
    }
    //MARK: - NAVBAR SETUP
    private func navBarItem() {
        if let navBar = navigationController?.navigationBar {
            let letfButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: nil)
            navBar.topItem?.title = "Заметки"
            navBar.prefersLargeTitles = true
            navigationItem.leftBarButtonItem = letfButton
        }
    }
    //MARK: - constraits
    
}

