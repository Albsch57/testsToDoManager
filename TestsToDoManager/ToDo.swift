//
//  ToDo.swift
//  TestsToDoManager
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import Foundation
import UIKit

struct Task: Equatable {
    let id: UUID = UUID()
    var title: String
    var description: String
    var isComplete: Bool
}

class ToDoManager {
    
    private var tasks: [Task] = []
    
    var taskCount: Int {
        tasks.count
    }
    
    func task(for index: Int) -> Task? {
        guard tasks.indices.contains(index) else { return nil }
        return tasks[index]
    }
    
    func index(for task: Task) -> Int {
        tasks.firstIndex(where: { $0 == task })!
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func removeTask(of index: Int) {
        tasks.remove(at: index)
    }
    
    func removetask(by task: Task) {
        tasks.removeAll(where: { $0 == task })
    }
    
    func markCompleted(id: UUID, completed: Bool) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index].isComplete = completed
        }
    }
    
    func replaceTask(by id: UUID, with task: Task) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index] = task
        }
    }
    
    func task(by id: UUID) -> Task? {
        tasks.first(where: {$0.id == id})
    }
    
    func filterTasks(isComplete: Bool) -> [Task] {
        return tasks.filter { $0.isComplete == isComplete }
    }
    
}
