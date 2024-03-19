//
//  CreateNoteViewController.swift
//  NOTES_APP_CFT_SHIFT
//
//  Created by Vladislav Mishukov on 17.03.2024.
//

import Foundation
import UIKit

final class CreateNotesViewController: UIViewController {
    //MARK: - DELEGATE
    weak var delegate: CreateNotesDelegate?
    //MARK: - UI
    private lazy var createNotestTitle : UILabel = {
        let label = UILabel()
        label.text = "Создание заметки"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doneEditButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = .systemBlue
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapDoneEditButton), for: .touchUpInside)
        view.addSubview(button)
        return button
        
    }()
        
    private lazy var createNotesTextField : UITextField = {
        let textField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingViewLeft
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название заметки"
        textField.tintColor = .systemBlue
        textField.borderStyle = .bezel
        textField.clearButtonMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                       for: .editingChanged)
        textField.addSubview(createNotesErrLabel)
        view.addSubview(textField)
        textField.delegate = self
        return textField
    }()
    
    private lazy var createNotesErrLabel : UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var createNotesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray2.cgColor
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(textView)
        return textView
    }()
    
    private lazy var createNotesButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = .systemBlue
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(didTapСreateNotes), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        constraitsCreateNotestTitle()
        constraitsDoneEditButton()
        constraitsCreateNotesTextField()
        constraitsCreateNotesErrLabel()
        constraitsCreateNotesButton()
        consraitsCreateNotesTextView()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - OBJC
    @objc func textFieldDidChange(_ textField: UITextField) {
      //  updateButtonStatus()
    }
    
    @objc func didTapDoneEditButton(_ sender: UIButton) {
        createNotesTextView.endEditing(true)
    }
    
    @objc func didTapСreateNotes(_ sender: UIButton) {
        guard let title = createNotesTextField.text, let note = createNotesTextView.text else { return }
        let newNote = Note(id: UUID(), title: title, note: note)
        delegate?.createNewNote(note: newNote)
        self.dismiss(animated: true)
    }
    
    
    @objc func hideKeyboard() {
        self.createNotesTextField.endEditing(true)
    }
    //MARK: - CONSTRAITS
    private func constraitsCreateNotestTitle() {
        NSLayoutConstraint.activate([
            createNotestTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createNotestTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 15)
        ])
    }
    private func constraitsCreateNotesButton() {
        NSLayoutConstraint.activate([
            createNotesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            createNotesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createNotesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createNotesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func constraitsDoneEditButton() {
        NSLayoutConstraint.activate([
            doneEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneEditButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            doneEditButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func consraitsCreateNotesTextView() {
        NSLayoutConstraint.activate([
            createNotesTextView.topAnchor.constraint(equalTo: createNotesErrLabel.bottomAnchor,constant: 5),
            createNotesTextView.bottomAnchor.constraint(equalTo: createNotesButton.topAnchor, constant: -20),
            createNotesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createNotesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    private func constraitsCreateNotesTextField() {
        NSLayoutConstraint.activate([
            createNotesTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createNotesTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            createNotesTextField.topAnchor.constraint(equalTo: createNotestTitle.topAnchor,constant: 40),
            createNotesTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        constraitsCreateNotesErrLabel()
    }
    private func constraitsCreateNotesErrLabel() {
        NSLayoutConstraint.activate([
            createNotesErrLabel.centerXAnchor.constraint(equalTo: createNotesErrLabel.centerXAnchor),
            createNotesErrLabel.topAnchor.constraint(equalTo: createNotesTextField.bottomAnchor, constant: 8)
        ])
    }
}
//MARK: - UITextFieldDelegate
extension CreateNotesViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count ?? 0) +  (string.count - range.length) >= 38 {
            createNotesErrLabel.isHidden = false
            return false
        }
        createNotesErrLabel.isHidden = true
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        createNotesErrLabel.isHidden = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.createNotesTextField.resignFirstResponder()
        return true
    }
}
//MARK: - UITextViewDelegate
extension CreateNotesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneEditButton.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        doneEditButton.isHidden = true
    }
    
}
