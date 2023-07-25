//
//  ViewController.swift
//  TestsToDoManager
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let taskManager = ToDoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        makeLayout()
        makeTitle()
        makeButtonAdd()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc
    func buttonAddTapped() {
        let vc = PresentViewController()
        
        vc.delegate = self
        
//        let alertController = UIAlertController(title: "Вы уверены?", message: nil, preferredStyle: .alert)
//        alertController.addAction(.init(title: "Ok", style: .default))
//        alertController.addAction(.init(title: "Cancel", style: .cancel))
//        navigationController?.present(alertController, animated: true)
//
//        let view = UIView()
//        view.backgroundColor = .systemGreen
//        view.frame = .init(x: 100, y: 100, width: 100, height: 100)
//        view.accessibilityIdentifier = "boxView"
//
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + [2, 1, 3, 5].randomElement()!, execute: {
//            self.view.addSubview(view)
//        })
        
        
         navigationController?.present(vc, animated: true)

    }
}


extension ListViewController {
    private func makeLayout() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func makeTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "To Do List"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    
    private func makeButtonAdd() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonAddTapped))
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskManager.taskCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = taskManager.task(for: indexPath.row) else { fatalError("Index not contains in task manager") }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = task.title
        configuration.secondaryText = task.description
        configuration.image = UIImage(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
        cell.contentConfiguration = configuration
        return cell
    }
    
}


extension ListViewController: PresentViewDelegate {
    func edited(task: Task) {
        taskManager.replaceTask(by: task.id, with: task)
        
        let index = taskManager.index(for: task)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func didCreated(new task: Task) {
        taskManager.addTask(task)
        let index = taskManager.index(for: task)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            self?.completeTask(at: indexPath)
            completionHandler(true)
        }
        completeAction.backgroundColor = .green
        completeAction.image = .init(systemName: "checkmark")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteTask(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editTask(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, completeAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    private func completeTask(at indexPath: IndexPath) {
        
        if var task = taskManager.task(for: indexPath.row) {
               let newCompletedStatus = !task.isComplete
               task.isComplete = newCompletedStatus
               taskManager.markCompleted(id: task.id, completed: newCompletedStatus)
               tableView.reloadRows(at: [indexPath], with: .automatic)
           }
    }
    
    
    private func deleteTask(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Вы уверены?", message: nil, preferredStyle: .alert)
        
        alertController.addAction(.init(title: "Delete", style: .default, handler: { _ in
            self.taskManager.removeTask(of: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }))
        
        
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        navigationController?.present(alertController, animated: true)
     
    }
    
    
    private func editTask(at indexPath: IndexPath) {
        guard let task = taskManager.task(for: indexPath.row) else { return }
        let editVC = PresentViewController()
        editVC.task = task
        editVC.delegate = self
        present(editVC, animated: true, completion: nil)
    }
    
}
