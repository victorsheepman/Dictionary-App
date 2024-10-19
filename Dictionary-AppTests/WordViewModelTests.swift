//
//  WordViewModelTests.swift
//  Dictionary-AppTests
//
//  Created by Victor Marquez on 19/10/24.
//

import XCTest
@testable import Dictionary_App

final class WordViewModelTests: XCTestCase {
    
    var viewModel: DictionaryModelView!
    
    override func setUp() {
        super.setUp()
        viewModel = DictionaryModelView()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testFetchWordSuccess() async {
        // Given: una palabra válida para buscar
        viewModel.wordSearched = "example"
        
        // When: el método `fetchWord` es ejecutado
        await viewModel.fetchWord()
        
        // Then: la palabra debería haberse cargado correctamente, y los estados deberían reflejar el éxito
        XCTAssertNotNil(viewModel.word, "La palabra debería haberse cargado correctamente.")
        XCTAssertFalse(viewModel.isEmpty, "No debería estar vacío.")
        XCTAssertFalse(viewModel.isNoFound, "La palabra debería haberse encontrado.")
    }
    
    func testFetchWordEmpty() async {
        // Given: Una string vacio para buscar
        viewModel.wordSearched = ""
        
        // When: el método `fetchWord` es ejecutado
        await viewModel.fetchWord()
        
        // Then: verifica que el estado `isEmpty` sea verdadero
        XCTAssertTrue(viewModel.isEmpty, "Debería marcarse como vacío.")
        XCTAssertNil(viewModel.word, "La palabra no debería haberse cargado.")
    }
    
    func testFetchWordNotFound() async {
        // Given: simula una palabra que no existe
        viewModel.wordSearched = "palabranoexiste"
        
        // When: ejecuta el método asíncrono
        await viewModel.fetchWord()
        
        // Then: verifica que `isNoFound` sea verdadero
        XCTAssertTrue(viewModel.isNoFound, "Debería indicar que no se encontró la palabra.")
        XCTAssertNil(viewModel.word, "La palabra no debería haberse cargado.")
    }
    
}
