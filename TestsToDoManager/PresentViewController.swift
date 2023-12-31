//
//  PresentViewController.swift
//  TestsToDoManager
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import UIKit

protocol PresentViewDelegate: AnyObject {
    func didCreated(new task: Task)
    func edited(task: Task)
}


class PresentViewController: UIViewController {
    
    private var titleField: UITextField! = nil
    private var secondaryField: UITextField! = nil
    
    var task: Task! = nil
    weak var delegate: PresentViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLayout()
        configurePreinstallData()
        
        view.accessibilityIdentifier = "ModalView"
    }
    
    private func configurePreinstallData() {
        titleField.text = task?.title
        secondaryField.text = task?.description
    }

    
    private func makeLayout() {
        
        view.backgroundColor = .systemGroupedBackground
        let titleView = makeLabel(title: "Task name")
        titleField = makeTextField(placeholder: "Name your task")
        
        let secondaryView = makeLabel(title: "Description")
        secondaryField = makeTextField(placeholder: "Title description")
        
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Create task"
        configuration.baseBackgroundColor = .blue
        configuration.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        let saveButton = UIButton(configuration: configuration)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        
        
        [titleView, titleField, secondaryView, secondaryField, saveButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            titleField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleField.heightAnchor.constraint(equalToConstant: 32),
            
            secondaryView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            secondaryView.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            secondaryView.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            secondaryField.topAnchor.constraint(equalTo: secondaryView.bottomAnchor, constant: 8),
            secondaryField.trailingAnchor.constraint(equalTo: secondaryView.trailingAnchor),
            secondaryField.leadingAnchor.constraint(equalTo: secondaryView.leadingAnchor),
            secondaryField.heightAnchor.constraint(equalToConstant: 32),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: secondaryField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: secondaryField.trailingAnchor)
        ])
    }
    
    @objc
    private func saveButtonTapped(_ sender: UIButton) {
        
        guard let title = titleField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            let alertController = UIAlertController(title: "Необходимо заполнить поля ввода", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        
        if var task {
            task.title = title
            task.description = secondaryField.text!
            delegate?.edited(task: task)
            dismiss(animated: true, completion: nil)
        } else {
            let newTask = Task(title: title, description: secondaryField.text!, isComplete: false)
            delegate?.didCreated(new: newTask)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension PresentViewController {
    private func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }
    
    private func makeLabel(title: String) -> UIView {
        var configuration = UIListContentConfiguration.plainHeader()
        configuration.text = title
        let view = configuration.makeContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension PresentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
