//
//  NotesTableCell.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import Foundation
import UIKit

final class NotesTableCell: UITableViewCell {
    //MARK: - Identifer
    static let cellIdentifer = "NotesCell"
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = .blue
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
