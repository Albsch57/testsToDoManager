//
//  ViewController.swift
//  TestsToDoManager
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import UIKit

class ListViewController: UIViewController {
//
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDoCell")
//        return tableView
//    }()
//
//    private var dataSource: UITableViewDiffableDataSource<Int, Task>! = nil
    
    private let tableView = UITableView()
    private var tasks: [Task] = []
    private var items = [Item]()
    
    struct Item {
        var title: String
        var text: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        makeLayout()
        makeTitle()
        makeButtonAdd()
        
        tableView.dataSource = self
  //      tableView.delegate = self
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
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = tasks[indexPath.row].description
        configuration.secondaryText = "id: \(tasks[indexPath.row].title)"
        cell.contentConfiguration = configuration
        return cell
    }
    
    
}


extension ListViewController: PresentViewDelegate {
    func didCreated(new task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }

}
