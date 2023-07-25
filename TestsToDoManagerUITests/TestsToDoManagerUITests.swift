//
//  TestsToDoManagerUITests.swift
//  TestsToDoManagerUITests
//
//  Created by Alyona Bedrosova on 24.07.2023.
//

import XCTest

final class TestsToDoManagerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let toDoView = ToDoView()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        app.navigationBars["To Do List"].buttons["Add"].tap()
        
        try super.setUpWithError()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        try super.tearDownWithError()
    }
    
    
    //Проверка создания новой задачи:
    func testTaskCreation() throws {
        toDoView.maketextField(name: "Yes", description: "To go")
        
        toDoView.buttonSaved()
        
        toDoView.makeSure(text: "Yes")
    }
    
    // Проверка редактирования задачи:
    func testEditTask() throws {
        toDoView.maketextField(name: "Yes", description: "To go")
        
        toDoView.buttonSaved()
        
        // Нажать на кнопку редактирования задачи
        toDoView.task(to: "Edit", boundBy: 0)
        
        // Внести изменения в поля названия и описания задачи
        toDoView.maketextField(name: "No", description: "Waiting")
        
        // Нажать на кнопку сохранения
        toDoView.buttonSaved()
        
        // Убедиться, что задача была изменена в списке задач
        toDoView.makeSure(text: "YesNo")
    }
    
    // Проверка удаления задачи:
    func testDeleteTask() throws {
        toDoView.maketextField(name: "Yes", description: "To go")
        
        toDoView.buttonSaved()
        
        // Выбрать одну из существующих задач в списке
        toDoView.task(to: "Delete", boundBy: 0)
        
        addUIInterruptionMonitor(withDescription: "Delete Task") { alert in
            alert.buttons["Delete"].tap()
            return true
        }
        
        // !!! без следующего действия работать не будет
        app.navigationBars["To Do List"].buttons["Add"].tap()
        
        toDoView.closeModalController()
        
        // Убедиться, что задача исчезла из списка задач
        let newRow = app.tables.firstMatch.staticTexts["Yes"]
        XCTAssertFalse(newRow.exists)
    }
    
    // Проверка отметки задачи как выполненной:
    func testCompleteTask() throws {
        toDoView.maketextField(name: "Yes", description: "To go")
        
        toDoView.buttonSaved()
        
        toDoView.task(to: "selected", boundBy: 0)
        
        /////// Убедиться, что статус задачи изменился на "Выполнено" и она стала перечеркнутой.
        //        let switchElement = app.tables.firstMatch.switches.firstMatch
        //        let statusText = switchElement.label
        //        let statusValue = (statusText == "true")
        //        XCTAssertTrue(statusValue)
        
        //----// Проверка отмены отметки задачи как выполненной:
        toDoView.task(to: "selected", boundBy: 0)
        
        //        let newRow = app.tables.firstMatch.staticTexts["false"]
        //        XCTAssert(newRow.exists)
        
        //        let statusLabel = app.staticTexts["false"]
        //               XCTAssertTrue(statusLabel.exists, "Статус задачи не изменился на 'true'.")
        
        //        let newRow = app.tables.firstMatch.switches.firstMatch
        //        XCTAssertTrue(newRow.exists)
    }
    
    
    // Проверка навигации между экранами:
    func testCheckScreen() throws {
        toDoView.maketextField(name: "Check", description: "Screens")
        
        toDoView.closeModalController()
        
        // Убедиться, что вернулись на экран списка задач.
        toDoView.makeSureEmptyVC()
    }
    
    // Проверка валидации ввода данных:
    func testValidation() throws {
        toDoView.buttonSaved()
        
        addUIInterruptionMonitor(withDescription: "Необходимо заполнить поля ввода") { alert in
            alert.buttons["OK"].tap()
            return true
        }
        
        toDoView.closeModalController()
        
        toDoView.makeSureEmptyVC()    
    }
    
    
    
    
    
    
    func testAlert() throws {
        
        app.navigationBars["To Do List"].buttons["Add"].tap()
        
        // Добавляем наблюдатель, который будет ждать пока появится всплывающее окно, и нажмет на кнопку OK
        addUIInterruptionMonitor(withDescription: "Вы уверены?") { alert in
            alert.buttons["Cancel"].tap()
            return true
        }
        
        
    }
    
    func testBoxSleep() throws {
        app.navigationBars["To Do List"].buttons["Add"].tap()
        
        // Ждем!
        let predicate = NSPredicate(format: "identifier == %@", "boxView")
        let boxView = app.otherElements.element(matching: predicate).firstMatch
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: boxView)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: 15)
        XCTAssertEqual(result, .completed)
        
    }
    
    
    
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

