// © 2025 Ardyan - Pattern Matters. All rights reserved.

import UIKit
import UIFlatPickerView

class InfinitePickerViewController: UIViewController {
    
    // MARK: - UI Elements
    private let pickerView = UIFlatPickerView()
    private let selectedValueLabel = UILabel()
    
    // MARK: - Data
    private let numbers = Array(1...100).map { String($0) }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPicker()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Infinite Scrolling Picker"
        view.backgroundColor = .systemBackground
        
        // Setup selected value label
        selectedValueLabel.text = "Selected: 1"
        selectedValueLabel.font = .systemFont(ofSize: 18)
        selectedValueLabel.textAlignment = .center
        selectedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pickerView)
        view.addSubview(selectedValueLabel)
        
        NSLayoutConstraint.activate([
            // Picker view
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Selected value label
            selectedValueLabel.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 30),
            selectedValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectionStyle = .overlay
        pickerView.textColor = .black
        pickerView.selectionIndicatorColor = .systemGreen
        pickerView.infiniteScrollEnabled = true
        pickerView.backgroundColor = .systemBackground
        pickerView.layer.borderWidth = 1
        pickerView.layer.borderColor = UIColor.systemGray4.cgColor
        pickerView.layer.cornerRadius = 8
        pickerView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UIFlatPickerViewDataSource
extension InfinitePickerViewController: UIFlatPickerViewDataSource {
    func numberOfComponents(in pickerView: UIFlatPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return numbers[row]
    }
}

// MARK: - UIFlatPickerViewDelegate
extension InfinitePickerViewController: UIFlatPickerViewDelegate {
    
    func pickerViewRowsHeight(_ pickerView: UIFlatPickerView) -> CGFloat {
        return 44.0
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValueLabel.text = "Selected: \(numbers[row])"
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, didTapRow row: Int, inComponent component: Int) {
        // Handle tap events if needed
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, styleForLabel label: UILabel, forComponent component: Int, highlighted: Bool) {
        // Default styling
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, viewForRow row: Int, forComponent component: Int, highlighted: Bool, reusingView view: UIView?) -> UIView? {
        return nil
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, widthForComponent component: Int) -> CGFloat {
        return -1 // Use equal distribution
    }
} 
