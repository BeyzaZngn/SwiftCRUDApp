//
//  AddPostViewController.swift
//  SwiftCRUDApp
//
//  Created by Beyza Zengin on 1.10.2025.
//

import Foundation

import UIKit

final class AddPostViewController: UIViewController {
    private let titleField = UITextField()
    private let bodyField = UITextView()
    private let saveButton = UIButton(type: .system)
    var onSave: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Post"; view.backgroundColor = .systemBackground

        titleField.borderStyle = .roundedRect; titleField.placeholder = "Title"
        bodyField.layer.borderWidth = 1; bodyField.layer.borderColor = UIColor.lightGray.cgColor; bodyField.layer.cornerRadius = 8
        saveButton.setTitle("Save", for: .normal); saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleField, bodyField, saveButton])
        stack.axis = .vertical; stack.spacing = 12; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bodyField.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc private func saveTapped() {
        onSave?(titleField.text ?? "", bodyField.text ?? "")
        navigationController?.popViewController(animated: true)
    }
}
