//
//  EditNotesController.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import Foundation
import UIKit

final class EditNotesController: UIViewController {
    //MARK: - UI
    private lazy var editNotesTextField : UITextField = {
        let textField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingViewLeft
        textField.leftViewMode = .always
        
       // textField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название заметки"
        //textField.layer.cornerRadius = 16
        textField.backgroundColor = .systemGroupedBackground
        textField.tintColor = .systemBlue
        textField.borderStyle = .bezel
        textField.clearButtonMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                       for: .editingChanged)
        textField.addSubview(editNotesErrLabel)
        view.addSubview(textField)
        textField.delegate = self
        return textField
    }()
    
    private lazy var editNotesErrLabel : UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        constraitEditNotesTextField()
        constraitEditNotesErrLabel()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - OBJC
    @objc func textFieldDidChange(_ textField: UITextField) {
      //  updateButtonStatus()
    }
    @objc func hideKeyboard() {
        self.editNotesTextField.endEditing(true)
    }
    //MARK: - CONSTRAITS
    private func constraitEditNotesTextField() {
        NSLayoutConstraint.activate([
            editNotesTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editNotesTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            editNotesTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            editNotesTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        constraitEditNotesErrLabel()
    }
    private func constraitEditNotesErrLabel() {
        NSLayoutConstraint.activate([
            editNotesErrLabel.centerXAnchor.constraint(equalTo: editNotesErrLabel.centerXAnchor),
            editNotesErrLabel.topAnchor.constraint(equalTo: editNotesTextField.bottomAnchor, constant: 8)
        ])
    }
}

//MARK: - UITextFieldDelegate
extension EditNotesController: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count ?? 0) +  (string.count - range.length) >= 38 {
            editNotesErrLabel.isHidden = false
            return false
        }
        editNotesErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        editNotesErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.editNotesTextField.resignFirstResponder()
        return true
    }
}
