//
//  EditContactViewController.swift
//  ModuleTasklSpalah
//
//  Created by mac on 17.12.2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
    
    @IBOutlet private weak var ibScrollView: UIScrollView!
    @IBOutlet private weak var ibImageView: UIImageView!

    @IBOutlet private weak var viewImage: UIView!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var phoneNumberField: UITextField!
    @IBOutlet private weak var modeButton: UIBarButtonItem!
    private let picker = UIImagePickerController()
    
    var contact: Contact?
    
    private var isEditMode: Bool {
        return contact != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setAvatar(_:)))
        viewImage.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        if isEditMode {
            modeButton.title = "Save"
        } else {
            modeButton.title = "Add"
            deleteButton.isHidden = true
        }
        if let contact = contact {
            firstNameField.text = contact.firstName
            lastNameField.text = contact.lastName
            emailField.text = contact.email
            phoneNumberField.text = contact.phoneNumber
            ibImageView.image = contact.image
        }
        firstNameField.tag = 0
        lastNameField.tag = 1
        emailField.tag = 2
        phoneNumberField.tag = 3
        viewImage.circleView()
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        phoneNumberField.delegate = self
        picker.delegate = self
    }
    
    private func showAlert(withTitle: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func showActionSheet() {
        let alertVC = UIAlertController(title: "Action Sheet", message: "Choose", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            print("Camera has been opened")
            self.openCamera()
        }
        let galeryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            print("Galary has been opened")
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertVC.addAction(cameraAction)
        alertVC.addAction(galeryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func setupContactInfo(_ contact: Contact?) {
        guard var currentContact = contact else { return }
        let newName = firstNameField.text ?? ""
        guard !newName.isEmpty else {
            showAlert(withTitle: "Alert", message: "Required fields have to be filled", buttonTitle: "OK")
            return
        }
        let newSirname = lastNameField.text ?? ""
        guard !newSirname.isEmpty else {
            showAlert(withTitle: "Alert", message: "Required fields have to be filled", buttonTitle: "OK")
            return
        }
        currentContact.firstName = newName
        currentContact.lastName = newSirname
        currentContact.image = ibImageView.image ?? #imageLiteral(resourceName: "user-5")
        isEditMode ? DataManager.instance.editContact(currentContact) : DataManager.instance.addContact(currentContact)
    }
    func openGallary() {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func openCamera() {
        picker.sourceType = UIImagePickerControllerSourceType.camera
        self .present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Private actions
    
    @IBAction private func deletePressed(_ sender: UIButton) {
        guard let contact = contact else { return }
        DataManager.instance.deleteContact(contact)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func barButtonItemPressed(_ sender: UIBarButtonItem) {
        if isEditMode {
            setupContactInfo(contact)
        } else {
            let newContact = Contact(firstName: "", lastName: "")
            setupContactInfo(newContact)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func setAvatar(_ sender: UITapGestureRecognizer) {
        showActionSheet()
    }
}

// MARK: - UITextFieldDelegate

extension EditContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.window?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [ String: Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        ibImageView.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Notifications

extension EditContactViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        ibScrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        ibScrollView.contentInset = UIEdgeInsets.zero
    }
}
