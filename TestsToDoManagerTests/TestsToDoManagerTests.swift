//
//  TestsToDoManagerTests.swift
//  TestsToDoManagerTests
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import XCTest
@testable import TestsToDoManager

final class TestsToDoManagerTests: XCTestCase {
    
    var taskManager: ToDoManager! = nil

    override func setUpWithError() throws {
        try super.setUpWithError()
        taskManager = ToDoManager()
    }

    override func tearDownWithError() throws {
        taskManager = nil
        try super.tearDownWithError()
    }

    func testAddTask() throws {
        
        let startCount = taskManager.taskCount
        let task = makeTask()
        taskManager.addTask(task)
        
        XCTAssertEqual(taskManager.taskCount, startCount + 1)
    }
    
    func testRemoveTask() throws {
        
        // v1
        let task = makeTask()
        
        taskManager.addTask(task)
        let startCount = taskManager.taskCount
        
        taskManager.removetask(by: task)
        XCTAssertEqual(taskManager.taskCount, startCount - 1)
        
        // v2
        taskManager.addTask(task)
        let countTask = taskManager.taskCount
        let index = taskManager.index(for: task)
        
        taskManager.removeTask(of: index)
        XCTAssertEqual(taskManager.taskCount, countTask - 1)
        
        // V3
        taskManager.addTask(task)
        let indexTask = taskManager.index(for: task)
        
        taskManager.removetask(by: task)
        XCTAssertNil(taskManager.task(for: indexTask)) // Должен быть nil
    }
    
    func testUpdateCompleteStatus() throws {
        
    }
    
    func testTaskByIndex() throws {
        
    }
    
    private func makeTask() -> Task {
        .init(title: "TEst Task", description: "Test Description", isComplete: false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
