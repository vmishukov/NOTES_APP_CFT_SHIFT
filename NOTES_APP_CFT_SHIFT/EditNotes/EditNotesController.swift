//
//  EditNotesController.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import Foundation
import UIKit

final class EditNotesController: UIViewController {
    //MARK: - DELEGATE
    weak var delegate: EditNotesDelegate?
    //MARK: - UI
    private lazy var editNotestTitle : UILabel = {
        let label = UILabel()
        label.text = "Редактирование заметки"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editNotesTextField : UITextField = {
        let textField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingViewLeft
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название заметки"
       // textField.backgroundColor = .systemGroupedBackground
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
    
    private lazy var editNotesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray2.cgColor
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(textView)
        return textView
    }()
    
    private lazy var editNotesButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = .systemBlue
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(didTapEditNotes), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    //MARK: - PUBLIC
    var noteId: UUID?
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        constraitsEditNotestTitle()
        constraitEditNotesTextField()
        constraitEditNotesErrLabel()
        constraitsEditNotesButton()

        consraiteditNotesTextView()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - OBJC
    @objc func textFieldDidChange(_ textField: UITextField) {
      //  updateButtonStatus()
    }
    
    @objc func didTapEditNotes(_ textField: UITextField) {
        guard let title = editNotesTextField.text, let note = editNotesTextView.text, let noteId = noteId else { return }
        let editedNote = Note(id: noteId, title: title, note: note)
        delegate?.editNote(editedNote: editedNote)
        self.dismiss(animated: true)
    }
    
    @objc func hideKeyboard() {
        self.editNotesTextField.endEditing(true)
    }
    //MARK: - public func
    public func setupEdit(title: String?, note: String?, noteId: UUID) {
        editNotesTextField.text = title
        editNotesTextView.text = note
        self.noteId = noteId
    }
    //MARK: - CONSTRAITS
    private func constraitsEditNotestTitle() {
        NSLayoutConstraint.activate([
            editNotestTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editNotestTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 15)
        ])
    }
    private func constraitsEditNotesButton() {
        NSLayoutConstraint.activate([
            editNotesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            editNotesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editNotesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editNotesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func consraiteditNotesTextView() {
        NSLayoutConstraint.activate([
            editNotesTextView.topAnchor.constraint(equalTo: editNotesErrLabel.bottomAnchor,constant: 5),
            editNotesTextView.bottomAnchor.constraint(equalTo: editNotesButton.topAnchor, constant: -20),
            editNotesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editNotesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    private func constraitEditNotesTextField() {
        NSLayoutConstraint.activate([
            editNotesTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editNotesTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            editNotesTextField.topAnchor.constraint(equalTo: editNotestTitle.topAnchor,constant: 40),
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
//MARK: - UITextViewDelegate
extension EditNotesController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 500
    }
}
