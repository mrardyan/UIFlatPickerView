// © 2025 UIFlatPickerView. All rights reserved.

import XCTest
@testable import UIFlatPickerView

final class UIFlatPickerViewTests: XCTestCase {
    
    func testUIFlatPickerViewInitialization() {
        let pickerView = UIFlatPickerView()
        XCTAssertNotNil(pickerView)
        XCTAssertEqual(pickerView.scrollingStyle, .default)
        XCTAssertEqual(pickerView.selectionStyle, .none)
        XCTAssertTrue(pickerView.enabled)
    }
    
    func testScrollingStyleEnum() {
        XCTAssertEqual(UIFlatPickerView.ScrollingStyle.default.rawValue, 0)
        XCTAssertEqual(UIFlatPickerView.ScrollingStyle.infinite.rawValue, 1)
    }
    
    func testSelectionStyleEnum() {
        XCTAssertEqual(UIFlatPickerView.SelectionStyle.none.rawValue, 0)
        XCTAssertEqual(UIFlatPickerView.SelectionStyle.defaultIndicator.rawValue, 1)
        XCTAssertEqual(UIFlatPickerView.SelectionStyle.overlay.rawValue, 2)
        XCTAssertEqual(UIFlatPickerView.SelectionStyle.image.rawValue, 3)
    }
    
    func testSelectionMethods() {
        let pickerView = UIFlatPickerView()
        
        // Test initial state
        XCTAssertNil(pickerView.selectedRow(inComponent: 0))
        
        // Test selection (should not crash even without data source)
        pickerView.selectRow(5, inComponent: 0, animated: false)
    }
    
    func testPickerComponentInitialization() {
        let component = PickerComponent()
        XCTAssertNotNil(component)
        XCTAssertEqual(component.scrollingStyle, .default)
        XCTAssertEqual(component.selectionStyle, .none)
        XCTAssertTrue(component.enabled)
    }
    
    func testDefaultSelectionViews() {
        let pickerView = UIFlatPickerView()
        
        // Test that selection views are created
        XCTAssertNotNil(pickerView.defaultSelectionIndicator)
        XCTAssertNotNil(pickerView.selectionOverlay)
        XCTAssertNotNil(pickerView.selectionImageView)
        
        // Test initial alpha values
        XCTAssertEqual(pickerView.defaultSelectionIndicator.alpha, 0.0)
        XCTAssertEqual(pickerView.selectionOverlay.alpha, 0.0)
        XCTAssertEqual(pickerView.selectionImageView.alpha, 0.0)
    }
} 