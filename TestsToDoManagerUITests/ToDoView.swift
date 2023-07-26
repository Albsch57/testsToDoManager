//
//  ToDoView.swift
//  TestsToDoManagerUITests
//
//  Created by Alyona Bedrosova on 25.07.2023.
//

import XCTest

struct ToDoView {
    
    private let app = XCUIApplication()
    
    func maketextField(name: String, description: String) {
        // Заполнить поля названия и описания задачи
        let titleTextField = app.textFields["Name your task"]
        let descriptionTextField = app.textFields["Title description"]
        
        titleTextField.tap()
        titleTextField.typeText(name)
        
        descriptionTextField.tap()
        descriptionTextField.typeText(description)
        
        descriptionTextField.typeText("\n")
    }
    
    func buttonSaved() {
        let button = app.buttons["Create task"]
        XCTAssert(button.exists)
        button.tap()
    }
    
    func makeSure(text: String) {
        Thread.sleep(forTimeInterval: 1)
        let newRow = app.tables.firstMatch.staticTexts[text]
        XCTAssert(newRow.exists)
    }
    
    func task(to button: String, boundBy: Int) {
        // Выбрать одну из существующих задач в списке.
        let taskToEdit = app.cells.element(boundBy: boundBy)
        
        // Нажать на кнопку редактирования задачи
        taskToEdit.swipeLeft()
        taskToEdit.buttons[button].tap()
    }
    
    func closeModalController() {
        let modalView = app.otherElements["ModalView"]
        
        let startCoord = modalView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let endCoord = modalView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
        
        //  let modalStillExists = modalView.waitForExistence(timeout: 5)
        //  XCTAssertFalse(modalStillExists, "Modal screen was not closed by swipe")
    }
    
    func makeSureEmptyVC() {
        let taskListScreen = app.navigationBars["To Do List"].firstMatch
        XCTAssertTrue(taskListScreen.exists, "Не удалось вернуться на экран списка задач.")
    }
    
    func goHome() {
        // вернуться домой, свернуть экран
        XCUIDevice.shared.press(.home)
        Thread.sleep(forTimeInterval: 2)
        XCUIApplication().activate()
    }
    
    
    
}
