// © 2025 Ardyan - Pattern Matters. All rights reserved.

import UIKit
import UIFlatPickerView

class CustomPickerViewController: UIViewController {
    
    // MARK: - UI Elements
    private let pickerView = UIFlatPickerView()
    private let selectedValueLabel = UILabel()
    
    // MARK: - Data
    private let colors = ["Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Pink", "Brown"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPicker()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Custom Styled Picker"
        view.backgroundColor = .systemBackground
        
        // Setup selected value label
        selectedValueLabel.text = "Selected: Red"
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
        pickerView.selectionStyle = .image
        pickerView.textColor = .white
        pickerView.selectionIndicatorColor = .systemOrange
        pickerView.backgroundColor = .systemGray6
        pickerView.layer.borderWidth = 1
        pickerView.layer.borderColor = UIColor.systemGray4.cgColor
        pickerView.layer.cornerRadius = 8
        pickerView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UIFlatPickerViewDataSource
extension CustomPickerViewController: UIFlatPickerViewDataSource {
    func numberOfComponents(in pickerView: UIFlatPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return colors[row]
    }
}

// MARK: - UIFlatPickerViewDelegate
extension CustomPickerViewController: UIFlatPickerViewDelegate {
    
    func pickerViewRowsHeight(_ pickerView: UIFlatPickerView) -> CGFloat {
        return 44.0
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValueLabel.text = "Selected: \(colors[row])"
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, didTapRow row: Int, inComponent component: Int) {
        // Handle tap events if needed
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, styleForLabel label: UILabel, forComponent component: Int, highlighted: Bool) {
        // Style the label based on highlight state
        if highlighted {
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = pickerView.textColor
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = pickerView.textColor.withAlphaComponent(0.7)
        }
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, viewForRow row: Int, forComponent component: Int, highlighted: Bool, reusingView view: UIView?) -> UIView? {
        // Custom view for the picker
        var customView: UIView = UIView()
        
        if let view {
            view.subviews.forEach { $0.removeFromSuperview() }
            customView = view
        }
        
        customView.backgroundColor = highlighted ? .systemBlue : .clear
        customView.layer.cornerRadius = 8
        customView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = colors[row]
        label.textColor = highlighted ? .white : .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        customView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
        ])
        
        return customView
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, widthForComponent component: Int) -> CGFloat {
        return -1 // Use equal distribution
    }
} 
