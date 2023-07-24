//
//  ViewController.swift
//  TestsToDoManager
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var tasks: [Task] = []
    
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
    private func buttonAddTapped() {
        let vc = PresentViewController()
        vc.delegate = self
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
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = tasks[indexPath.row].description
        configuration.secondaryText = tasks[indexPath.row].title
        configuration.image = UIImage(systemName: tasks[indexPath.row].isComplete ? "checkmark.circle.fill" : "circle")
        cell.contentConfiguration = configuration
        return cell
    }
    
}


extension ListViewController: PresentViewDelegate {
    func edited(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func didCreated(new task: Task) {
        tasks.append(task)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
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
        tasks[indexPath.row].isComplete = true
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    private func deleteTask(at indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    
    private func editTask(at indexPath: IndexPath) {
        let taskToEdit = tasks[indexPath.row]
        
        let editVC = PresentViewController()
        editVC.task = taskToEdit
        editVC.delegate = self
        present(editVC, animated: true, completion: nil)
    }
    
}
