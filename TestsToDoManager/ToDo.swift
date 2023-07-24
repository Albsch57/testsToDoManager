//
//  ToDo.swift
//  TestsToDoManager
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import Foundation
import UIKit

struct Task {
    var title: String
    var description: String
    var status: TaskStatus
}

enum TaskStatus: String {
    case completed = "Выполнено"
    case notCompleted = "Не выполнено"
}

